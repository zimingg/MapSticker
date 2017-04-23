//
//  MeViewController.swift
//  Final Project
//
//  Created by zimingg on 2/23/17.
//  Copyright © 2017 zimingg. All rights reserved.
//


import UIKit
import MapKit
import Alamofire
import CoreData

class MeViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    
    @IBOutlet var selfish:UIImageView!
    
    @IBOutlet var Name:UILabel!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseController.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        try! resultsController.performFetch()
        
        self.fetchedResultsController = resultsController
        
        if let someObjects = fetchedResultsController?.fetchedObjects {
            //print("someObjects: \(someObjects)")
            Name.text! = someObjects[0].name!
            
        }

        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var fetchedResultsController: NSFetchedResultsController<Users>!

    
}

