//
//  Artwork.swift
//
//  Created by Li Ju on 12/04/2018.
//  Reference: https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
//

import Foundation
import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let discription: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let url:String

    var imageName: String? {
		if (discipline == "Plaque") {
			return "SmallFlags"
		}
		else if (discipline.contains("ad")){
			return "Ads"
		}
		else {
			return nil
		}
    }
    
    init(title: String, discription: String, discipline: String, coordinate: CLLocationCoordinate2D,url:String) {
        self.title = title
        self.discription = discription
        self.discipline = discipline
        self.coordinate = coordinate
        self.url=url
        super.init()
    }
    //Read annotion attributes from parsed json file.
    init?(json: [Any]) {
        // 1
        self.title = json[2] as? String ?? "No Title"
        self.discription = json[0] as! String
        self.url=json[5] as! String        
        self.discipline = json[1] as! String
        // 2
        if let latitude = Double(json[3] as! String),
            let longitude = Double(json[4] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
    //Get the url of annotation
    var getUrl:String? {
        return url
    }
    //Get the description of the annotation
    var subtitle: String? {
        return discription
    }
  
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}






























