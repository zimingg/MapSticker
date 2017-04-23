//
//  ViewController.swift
//  Final Project
//
//  Created by zimingg on 2/23/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MyPostViewController: UIViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate{
    
    private var fetchedResultsController: NSFetchedResultsController<MapPin>!

    
    
    @IBOutlet var tableview : UITableView!
    var searchResults:[MapPin] = []
    var MyPostList:[MapPin] = []
   
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        if let someObjects = fetchedResultsController?.fetchedObjects {
            
            searchResults = someObjects
            
       }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mypostsegue", sender:self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mypostsegue" {
            let detailsViewController = segue.destination as! DetailViewController
            
            let selectedIndexPath = tableview.indexPathForSelectedRow!
            detailsViewController.setSeletPin(mappin: MyPostList[selectedIndexPath.row])
            
            tableview.deselectRow(at: selectedIndexPath, animated: true)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<MapPin> = MapPin.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pinTitle", ascending: true)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseController.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        try! resultsController.performFetch()
        
        self.fetchedResultsController = resultsController
        
        if let someObjects = fetchedResultsController?.fetchedObjects {
            //print("someObjects: \(someObjects)")
            searchResults = someObjects
        }

        
//        let fetchRequest: NSFetchRequest<MapPin> = MapPin.fetchRequest()
//        
//        do{
//            searchResults = try DatabaseController.getContext().fetch(fetchRequest)
//            for item in searchResults{
//                if (item.relationship?.name == "ziming"){
//                    MyPostList.append(item)
//                }
//            }
//            print(searchResults.count)
//            print(MyPostList.count)
//        }
//        catch{
//            print("Error")
//        }
//        
//        
//        NotificationCenter.default.addObserver(forName: DatabaseController.EVENT_ADDED_NOTIFICATION, object: nil, queue: nil){ notification in
//            self.tableview.reloadData()
//
//        }
//        
   }


     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView:UITableView, numberOfRowsInSection: Int)->Int{
        
        MyPostList = []
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        
                do{
                    let userList = try DatabaseController.getContext().fetch(fetchRequest)
                    let CurrentUser = userList[0]
                    
                    for i in searchResults{
                        if i.relationshipToEvents?.owner == CurrentUser.name{
                            MyPostList.append(i)

                        }
                    }
                    //print(MyPostList.count)
                }
                catch{
                    print("Error")
                }


        //return MapEventController.sharedEvents().count
        
        
        
        return MyPostList.count
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell {

        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        //var eventArray:[MapPin] = searchResults
        

        let events: MapPin = MyPostList[indexPath.row]
        
        cell.textLabel?.text = events.pinTitle

        return cell
    }
 
    
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
}
