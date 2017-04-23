//
//  ViewController.swift
//  Final Project
//
//  Created by zimingg on 2/22/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import CoreData
import CoreLocation



class MapviewViewController:UIViewController,MKMapViewDelegate, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate {
    
    var Manager = CLLocationManager()
    var searchResults:[MapPin] = []
    var long = 0.0
    var lat  = 0.0
    @IBOutlet private var MapView: MKMapView!
    @IBAction func Refresh(_ sender: UIBarButtonItem){
        setUserPosition = true
        
        DatabaseController.loadEventsOnMap()
    }
    
    @IBAction func BLogOut(_ sender: UIBarButtonItem){
        
        let context = DatabaseController.getContext()
        context.perform {
            do{
                
                let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
                let allUsers = try context.fetch(fetchRequest)
                
                for item in allUsers {
                    context.delete(item)
                }

        
            }
            catch{}
            DatabaseController.saveContext()
        }
        
        
        
        
        performSegue(withIdentifier: "logoutsegue", sender:self)
        
        
    }

    
    

   
    @IBAction func BAdd(_ sender: UIButton) {
        //performSegue(withIdentifier: "AddPin", sender: self)
        
//        UserDefaults.standard.set(lat, forKey: "lat")
//        UserDefaults.standard.set(long, forKey: "long")
       
      
        
        performSegue(withIdentifier: "PinDetailSegue", sender:self)
    }
   
    //mapView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView: MKAnnotationView?
        if annotation is MapPin {
            if let someAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "HillAnnotation") {
                annotationView = someAnnotationView
            }
            else {
                let pinAnnotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"HillAnnotation")
                pinAnnotationView.pinTintColor = .red
                pinAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                annotationView = pinAnnotationView
            }
            
            annotationView!.annotation = annotation
            annotationView!.canShowCallout = true
            annotationView!.isDraggable = true
        }
        else {
            annotationView = nil
        }

        return annotationView;
        
    }
    
    var selectedPin: MapPin?
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let somePin = view.annotation as? MapPin {
            selectedPin = somePin
            
            performSegue(withIdentifier: "detailseg", sender:self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailseg" {
            
            let destinationVC = segue.destination as! DetailViewController
            let selectedannos = MapView.selectedAnnotations
            //DetailViewController.setSeletPin(selectedannos[0])
            destinationVC.setSeletPin(mappin: selectedannos[0] as! MapPin)

            
            //setSeletPin(mappin: selectedannos[0] as! MapPin)
            //print("selected pin is: \(selectedannos)")
        
        }
        if segue.identifier == "PinDetailSegue"{
            let VC = segue.destination as! AddViewController
            VC.LAT = String(format:"%f", lat)
           
            VC.LONG = String(format:"%f", long)
        
        }
    }
    
    
    
    
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        MapView.removeAnnotations(MapView.annotations)
        if let someObjects = fetchedResultsController?.fetchedObjects {
            MapView.addAnnotations(someObjects)
            
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        
        if setUserPosition {
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
            let mylocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let reigon:MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
            MapView.setRegion(reigon, animated: true)
            
            setUserPosition = false
        }
    }
    
    private var setUserPosition = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUserPosition = true
    }
    
    // MARK: View Management
    override func viewDidLoad() {
        super.viewDidLoad()
        Manager.delegate = self
        Manager.desiredAccuracy = kCLLocationAccuracyBest
        Manager.requestWhenInUseAuthorization()
        Manager.startUpdatingLocation()
        
        UserDefaults.standard.set("", forKey: "lat")
        UserDefaults.standard.set("", forKey: "long")
        
        let fetchRequest: NSFetchRequest<MapPin> = MapPin.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pinTitle", ascending: true)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseController.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        try! resultsController.performFetch()
        
        self.fetchedResultsController = resultsController
        
        if let someObjects = fetchedResultsController?.fetchedObjects {
            //print("someObjects: \(someObjects)")
            MapView.addAnnotations(someObjects)
        }
        
        // TASK THERE: Set navigation bar to transparent.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        //TASK THERE: Set tab bar to transparent.
        self.tabBarController?.tabBar.barTintColor = UIColor.clear
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.shadowImage = UIImage()
        
        
        
        
        
        
        
        
 
    }
    
        
        /*Alamofire.request("https:s3-us-west-2.amazonaws.com/electronic-armory/buildings.json").responseString{ response in
            do{
                let jsonString = response.result.value!
                let jsonData = jsonString.data(using: .utf8)
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                let jsonArray = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSArray
                print(jsonArray)
         
                
            }
            catch {
                print(error)
                }
            }
        }
        */
        
//        Alamofire.request("https://s3-us-west-2.amazonaws.com/electronic-armory/buildings.json").responseString{ response in
//            do{
//                let jsonString = response.result.value!
//                let jsonData = jsonString.data(using: .utf8)
//                //let jsonResult = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
//                let jsonArray = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSArray
//                print(jsonArray)
//                
//                for(index,jsonObject) in jsonArray.enumerated(){
//                    let currentEvent:Dictionary = jsonObject as! Dictionary<String,AnyObject>
//                    let NAME = "name"
//                    let LOCATION = "location"
//                    let DECRIPTION = "description"
//                    let LAT = "latitude"
//                    let LON = "longitude"
//                    print(currentEvent)
//                    let namestring:String = currentEvent[NAME] as! String
//                    let description:String = currentEvent[DECRIPTION] as! String
//                    
//                    let locationDic: Dictionary = currentEvent[LOCATION] as! Dictionary<String,Double>
//                    let lat:Double = locationDic[LAT]! as Double
//                    let lon:Double = locationDic[LON]! as Double
//                    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
//                    let currentMapPin:TheMapPin = TheMapPin(title:namestring, subtitle:description, coordinate:location)
//                    self.MapView.addAnnotation(currentMapPin)
//                    
//                }
//                
//                
//                
//            }
//            catch {
//                print(error)
//            }
 //       }
    

    
    
        
        
    private var fetchedResultsController: NSFetchedResultsController<MapPin>!
}

