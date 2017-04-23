//
//  DetailViewController.swift
//  Final Project
//
//  Created by zimingg on 3/11/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import Foundation

import UIKit
import MapKit
import Alamofire
import CoreData



class DetailViewController: UIViewController {

    
    
    @IBOutlet var name: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var content: UITextView!
    
    public func setSeletPin(mappin : MapPin){
        self.selectedMapPin = mappin
        
    }
    
    private var selectedMapPin: MapPin!

    override func viewDidLoad() {
       // print(selectedMapPin)
        name.text = selectedMapPin.pinTitle ?? "ri"
        //print(selectedMapPin.pinTitle)
        time.text = selectedMapPin.pinDescription ?? "ri"
        content.text = selectedMapPin.relationshipToEvents?.content ?? "NULL"
        //print("just show relationship: \(selectedMapPin.relationshipToEvents?.content ?? "null")")
        
        
        
        
        
        
        
        
        
        
    }
}
