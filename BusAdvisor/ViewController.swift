//
//  ViewController.swift
//  COMP208 Group Project
//  Bus alert
//  Reference: https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
//             https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
//

import UIKit
import MapKit
import UserNotifications
import CoreLocation
import StoreKit
import AudioToolbox

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
    func setSearchBar(title: String)
}

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var landMarkBtn: UIButton!   // the button to on/off landmark function
    @IBOutlet var label: UILabel!   //the title of navegation bar
	@IBOutlet var cancelBtn: UIButton! //cancel button
	@IBOutlet var mapView: MKMapView!  // map view
    @IBOutlet weak var locateBtn: UIButton! // locate me button
    
	@IBOutlet var distanceDisplay: UILabel!
	
	let locationManager = CLLocationManager()
    var annotationView: MKAnnotationView? = nil
    var resultSearchController: UISearchController? = nil
    var tableResult: MKPlacemark? = nil
    var destinationPoint: MKPointAnnotation? = nil
    var lastLocation:CLLocation = CLLocation()
    var artworks: [Artwork] = []

    var startTrack: Bool = false //Whether user has started tracking.
    var sendArrivalAlert: Bool = false // Whether send arrival alert to user (who will arrive the destination)
    var sendMissAlert: Bool = false // Wheteher send miss alert to user( who have missed the destination)
    var focusOnUserLocation: Bool = false // whether user want to focus on their location(always put their location in the center of the map)
    var firstTime: Bool = true
    var locationSet = Bool()
    
    var arrival = false // whether user has arrived the destination. new change


    struct settingValue {
        static var constrainDistance = 100.0 // the alert distance bewteen destination and user location
        static var isVibration = true   // whether vibration is on
		static var isPowerSave = false
    }
	
	func setSearchBar(title: String) {
		resultSearchController!.searchBar.text = title
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
		
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        mapView.showsTraffic = true
        cancelBtn.isHidden = true
		
		distanceDisplay.isHidden = true
		
        landMarkBtn.isSelected = false
        landMarkBtn.setImage(UIImage(named:"landmarkOff.png"),for: .normal)
        landMarkBtn.setImage(UIImage(named:"landmarkOn.png"), for: .selected)
        locationSet = false
        locationManager.startUpdatingLocation()
        
        mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
		searchBar.placeholder = NSLocalizedString("Search for places", comment: "")

        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow, error in
            self.mapView.delegate = self
        })
		let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
		if (!launchedBefore) {
			self.performSegue(withIdentifier: "ToInstructionView", sender: self)
			UserDefaults.standard.set(true, forKey: "launchedBefore")
		}
    }
    @IBAction func locateMe(_ sender: UIButton) {
		// once user click the locate me button, relocate the user location, put user location at the map center.
		// provide two mode: 1. focus on the user location (always put the user location at the map center); 2. allaw user to interactive with the map (zoom in/out ,etc)
		focusOnUserLocation = !focusOnUserLocation
		if focusOnUserLocation {
			sender.setImage( UIImage(named:"Checked.png"), for:[])
		} else {
			sender.setImage(UIImage(named:"Unchecked.png"), for:[])
		}
		relocate()
	}
	@IBAction func changeLandmark(_ sender: UIButton) {
		landMarkBtn.isSelected = !landMarkBtn.isSelected
		if landMarkBtn.isSelected {
			loadInitialData()
			mapView.addAnnotations(artworks)
			for annotation in mapView.annotations {
				if annotation is Artwork {
					let identifier = "marker"
					annotationView = ArtworkView(annotation: annotation, reuseIdentifier: identifier)
					annotationView!.canShowCallout = true
					//Change the margin of the annomation.
					annotationView!.calloutOffset = CGPoint(x: -5, y: 5)
					annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
					
					// The way to output multiple annotaion values.
					let detailLabel = UILabel()
					detailLabel.numberOfLines = 0
					detailLabel.font = detailLabel.font.withSize(12)
					detailLabel.text = annotation.subtitle!
					annotationView!.detailCalloutAccessoryView = detailLabel
				}
			}
		} else {
			for annotation in mapView.annotations {
				if annotation is Artwork {
					mapView.removeAnnotation(annotation)
				}
			}
		}
	}
    @IBAction func cancelTracking(_ sender: UIButton) {
        // once user click the cancel button, cancel the tracking and never send alert, hide the cancel button. Also remove all the line of user path.
        stopTrack()
    }
	
    func stopTrack() {
        startTrack = false
        sendArrivalAlert = false
        cancelBtn.isHidden = true
		arrival = false
		distanceDisplay.isHidden = true
		
        sendMissAlert = false
        for annotation in mapView.annotations {
            if !(annotation is Artwork) {
                mapView.removeAnnotation(annotation)
            }
        }
        mapView.removeOverlays(self.mapView.overlays)
        resultSearchController!.searchBar.isHidden = false
        self.navigationItem.titleView = resultSearchController!.searchBar
		self.locationManager.allowsBackgroundLocationUpdates = false
		self.locationManager.pausesLocationUpdatesAutomatically = true
        setSearchBar(title: "")
		SKStoreReviewController.requestReview()	// feedback
    }
    
    func relocate() {
        // relocate the user location and put it at the map center.
        let location = locationManager.location?.coordinate
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location!, span)
        mapView.setRegion(region, animated: true)
        
    }
	
	func loadInitialData() {
		guard let fileName = Bundle.main.path(forResource: "LandmarkAndAds", ofType: "json")
			else { return }
		let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
		guard
			let data = optionalData,
			let json = try? JSONSerialization.jsonObject(with: data),
			let dictionary = json as? [String: Any],
			let works = dictionary["data"] as? [[Any]]
			else { return }
		let validWorks = works.compactMap { Artwork(json: $0) }
		artworks.append(contentsOf: validWorks)
	}

    func sendNotification(title: String, body: String) {
        // send notification to the user
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = "By COMP208 Group 21"
        content.body = body
        if settingValue.isVibration{
            content.sound = UNNotificationSound.default()
        }
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "TimeDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

	func alertFunc(title: String, message: String, continueTrack: Bool, cancelTrack: Bool, done: Bool){
        // send alert to user
		sendNotification(title: title, body: message)
        if settingValue.isVibration {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if continueTrack{
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        }
        if cancelTrack {
            alert.addAction(UIAlertAction(title: "End", style: .cancel, handler: {action in self.stopTrack()}))
        }
		if done {
			alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
		}
		
        self.present(alert, animated: true)
    }
    
    func mapView(_ map: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer!{
        // generate the line of user path
        if overlay is MKPolyline{
            let polylineRenderer = MKPolylineRenderer(overlay:overlay)
            polylineRenderer.strokeColor = UIColor(red: 90/255, green: 200/255, blue:251/255, alpha:1)
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }
    
    @objc func confirmDestination(sender: UIButton) {
        // once user confirm the destination, put the user location at the map center, start tracking and give the permission to system to send alert.
        relocate()  //relocate user location
        for annotation in mapView.annotations {
            if !(annotation is Artwork) {
                mapView.removeAnnotation(annotation)
            }
        }
        mapView.addAnnotation(destinationPoint!) //add destination point to the map
        startTrack = true
        focusOnUserLocation = true
        self.locateBtn.setImage( UIImage(named:"Checked.png"), for:[])
        cancelBtn.isHidden = false
        sendMissAlert = true
        sendArrivalAlert = true
        resultSearchController!.searchBar.isHidden = true
        self.navigationItem.titleView = label
        label.text = "Heading to: " + (destinationPoint?.title)!
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is Artwork {
			let identifier = "marker"
			var view: ArtworkView
			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
				as? ArtworkView {
				dequeuedView.annotation = annotation
				view = dequeuedView
				view.canShowCallout = true
			} else {
				view = ArtworkView(annotation: annotation, reuseIdentifier: identifier)
				view.canShowCallout = true
				//Change the margin of the annomation.
				view.calloutOffset = CGPoint(x: -5, y: 5)
				view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
			}
			// The way to output multiple annotaion values.
			let detailLabel = UILabel()
			detailLabel.numberOfLines = 0
			detailLabel.font = detailLabel.font.withSize(12)
			detailLabel.text = annotation.subtitle!
			view.detailCalloutAccessoryView = detailLabel
			return view
		} else if annotation is MKUserLocation {
			return nil
		} else if (annotation.title == resultSearchController!.searchBar.text ){
			let reuseId = "pin2"
			var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView?.pinTintColor = UIColor.green
			pinView?.animatesDrop = true
			pinView?.canShowCallout = true

			let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
			button.setTitle("Select", for: UIControlState())
			button.setTitleColor(UIColor.blue, for: UIControlState())
			button.addTarget(self, action: #selector(ViewController.confirmDestination(sender:)), for: .touchUpInside)
			pinView?.leftCalloutAccessoryView = button
			annotationView = pinView
			return pinView
		} else {
			let reuseId = "pin"
			var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView?.pinTintColor = UIColor.red
			pinView?.animatesDrop = true
			pinView?.canShowCallout = true
			
			let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
			button.setTitle("Select", for: UIControlState())
			button.setTitleColor(UIColor.blue, for: UIControlState())
			button.addTarget(self, action: #selector(ViewController.confirmDestination(sender:)), for: .touchUpInside)
			pinView?.leftCalloutAccessoryView = button
			annotationView = pinView
			return annotationView
		}
		
    }
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
				 calloutAccessoryControlTapped control: UIControl) {
		let location = view.annotation as! Artwork
		let urlInput = location.getUrl!
		if let url = URL(string: urlInput) {
			UIApplication.shared.open(url, options: [:])
		}
	}
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        destinationPoint = MKPointAnnotation();
        destinationPoint?.title = view.annotation?.title!
        destinationPoint?.coordinate = (view.annotation?.coordinate)!
    }
//	func mapView
}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            locationManager.requestLocation()
		} else if status == CLAuthorizationStatus.notDetermined{
			self.locationManager.requestWhenInUseAuthorization()
		} else{
			alertFunc(title: "We need to use your location", message: "Please let us use your location, if you do not want to let us use your location now, you can go to the setting to let us use your location latter", continueTrack: false, cancelTrack: false, done: true)
		}
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let arrivalDistance = 45.0 // the distance to judge whether user has arrived the destination.
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            if (focusOnUserLocation == true || firstTime == true){
                // if in the focusing mode, always put the user location at the map center
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.setRegion(region, animated: true)
                firstTime = false
            }
			if (settingValue.isPowerSave) {
				locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			} else {
				locationManager.desiredAccuracy = kCLLocationAccuracyBest
			}
            if(startTrack){
                // if start tracking
				if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
					self.locationManager.requestAlwaysAuthorization()
				}
				self.locationManager.allowsBackgroundLocationUpdates = true
				self.locationManager.pausesLocationUpdatesAutomatically = false
                if !locationSet {
                    // get the user last location
                    if lastLocation != manager.location{
                        lastLocation = manager.location!
                        locationSet = true
                    }
                }
                let currentLocation:CLLocation = manager.location!
                var destinationLocation = CLLocation(latitude: (destinationPoint?.coordinate.latitude)!, longitude: (destinationPoint?.coordinate.longitude)!)
                let distanceInMeters = destinationLocation.distance(from: currentLocation)
                // compute the distance between user current location and destination
				
				distanceDisplay.text = String(distanceInMeters)
				distanceDisplay.isHidden = false
				
                if (distanceInMeters < arrivalDistance){
                    // user has arrived
                    arrival = true
                }
                print("arrival alert \(sendMissAlert) + distance + \(distanceInMeters) + constrain + \(settingValue.constrainDistance) + arrival +\(arrival)")
                if (sendArrivalAlert && distanceInMeters < settingValue.constrainDistance && arrival == false){
					sendArrivalAlert=false
                    // user will arrive, send notification and pop alert
                   // sendNotification(title: "The destination will be reached", body: "You need perpare to get off the bus")
					alertFunc(title: "You are approaching the destination bus stop",message:"please pay attention to the bus stop",continueTrack: true,cancelTrack: true, done: false)
                }
                if( sendMissAlert && distanceInMeters > 100.0 && arrival){  // user has missed their destination, send notification and pop alert
					sendMissAlert = false
                    //sendNotification(title: "You have missed your destination", body: "Unfortunatly, you have missed the destination")
					alertFunc(title: "You have missed your destination", message: "Unfortunatly, you have missed the destination", continueTrack: false, cancelTrack: true, done: false)
                }
                // draw a blue line to show user path
                let locations = [lastLocation,currentLocation]
                var coordinates = locations.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
                let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
                mapView.add(polyline)
                lastLocation = manager.location!
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        tableResult = placemark
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Bus Stop"
		let region = MKCoordinateRegionMakeWithDistance(placemark.location!.coordinate, 1500, 1500)

		if (placemark.title!.lowercased().contains("stop") || placemark.title!.lowercased().contains("station")) {
			self.mapView.addAnnotation(placemark)
		}
        request.region = region
        for annotation in mapView.annotations{
            if !(annotation is Artwork){
                mapView.removeAnnotation(annotation)
            }
        }
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
                return
            }
            
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.title = item.name!
                annotation.coordinate = item.placemark.coordinate
                
                if let city = placemark.locality,
                    let state = placemark.administrativeArea {
                    annotation.subtitle = "\(city) \(state)"
                }
                self.mapView.addAnnotation(annotation)
            }
        }
        mapView.setRegion(region, animated: true)
		focusOnUserLocation = false
    }

}
