//
//  ArtworkView.swift
//  Demo1
//
//  Reference: https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
//  Copyright © 2018 COMP208. All rights reserved.
//

import UIKit
import MapKit

class ArtworkView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
			if (artwork.discipline == "Plaque") {
				 glyphImage = UIImage(named: "SmallFlags")
			}
			else if (artwork.discipline.contains("ad")){
				glyphImage = UIImage(named: "Ads")
			}
			
            if let imageName = artwork.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
        }
    }
}
