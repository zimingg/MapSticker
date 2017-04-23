//
//  MapPin_MKAnnotation.swift
//  Final Project
//
//  Created by zimingg on 3/10/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import MapKit


extension MapPin : MKAnnotation {
    public override func didChangeValue(forKey key: String) {
        super.didChangeValue(forKey: key)
        
        if key == "pinLat" {
            print("Changed pinLat to \(value(forKey: "pinLat"))")
        }
    }
    
    public var title: String? {
        get {
            return pinTitle
        }
    }
    public var subtitle: String? {
        get {
            return pinDescription
        }
    }
    public var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(pinLat!.doubleValue, pinLon!.doubleValue)
        }
    }
}
