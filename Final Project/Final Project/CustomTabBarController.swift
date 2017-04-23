//
//  CustomTabBarController.swift
//  Final Project
//
//  Created by zimingg on 3/8/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import CoreData


class CustomTabBarController : UITabBarController,NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<Users>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check to see if logged in
        updateForLogInState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // Check to see if logged in
        
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseController.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        try! resultsController.performFetch()
        
        self.fetchedResultsController = resultsController
        
        if let someObjects = fetchedResultsController?.fetchedObjects {
            //print("someObjects: \(someObjects)")
            
                    if (someObjects.count > 0){
                        loggedIn = true
                    }
                    else{
                        loggedIn = false
                    }
        }

        //let loggedIn = false

        
        if !loggedIn {
            performSegue(withIdentifier: "LogInSegueUnanimated", sender: self)
        }
        updateForLogInState()
    }
    
    public func updateForLogInState() {
        //let loggedIn = false
        
        if loggedIn {
            loadingView?.removeFromSuperview()
            loadingView = nil
        }
        else if loadingView == nil {
            let nib = UINib(nibName: "Launch", bundle: nil)
            loadingView = nib.instantiate(withOwner: nil, options: nil).first as? UIView
            
            if let someLoadingView = loadingView {
                someLoadingView.translatesAutoresizingMaskIntoConstraints = false

                view.addSubview(someLoadingView)
                
                view.addConstraint(NSLayoutConstraint(item: someLoadingView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
                view.addConstraint(NSLayoutConstraint(item: someLoadingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
                view.addConstraint(NSLayoutConstraint(item: someLoadingView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
                view.addConstraint(NSLayoutConstraint(item: someLoadingView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            }
        }
    }
    
    private var loadingView: UIView?
    private var loggedIn = false
}
