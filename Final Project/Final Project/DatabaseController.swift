//
//  DatabaseController.swift
//  Final Project
//
//  Created by zimingg on 3/2/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire
import MapKit

class DatabaseController{
// MARK: - Core Data stack
    private init(){
        self.refreshData()
    }
    class func getContext()->NSManagedObjectContext{
        return DatabaseController.persistentContainer.viewContext
    }
    
  
    public static let EVENT_ADDED_NOTIFICATION = NSNotification.Name("EVENT_ADDED")
    
    static let eventPinClassName:String = String(describing: MapPin.self)
    
    private static let fruitDataURL = "https://s3-us-west-2.amazonaws.com/electronic-armory/buildings.json"
    private let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    func refreshData() {
        // Construct a URL and URLRequest
        let url = URL(string:DatabaseController.fruitDataURL)!
        let urlRequest = URLRequest(url: url)
        
        // Create a data task for the URLRequest
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            // All parameters will potentially be nil depending on what occurred during the request.  Applications
            // should present potential errors to the user as appropriate.
            
            // Check to make sure there is no error
            guard error == nil else {
                print("Error refreshing data \(error!)")
                
                return
            }
            
            // Check to make sure the response is valid and the status code does not indicate an error
            guard let someResponse = response as? HTTPURLResponse, someResponse.statusCode >= 200, someResponse.statusCode < 300  else {
                print("Invalid response or non-200 status code")
                
                return
            }
            
            // Check to make sure there is data
            guard let someData = data else {
                return
            }
            
            // Check to make sure the data is JSON in the form that is expected
            guard ((try? JSONSerialization.jsonObject(with: someData, options: [])) as? Array<Dictionary<String, Any>>) != nil else {
                return
            }
            
            
            DatabaseController.loadEventsOnMap()
        }
        
        // The resume() function starts the URL request.
        dataTask.resume()
    }

    class func loadEventsOnMap(){
//        let headers_c: HTTPHeaders = [
//            "Authorization": "Token 7180abd5e048f813ad911d278c88f2cc46e080c9",
//            "Accept": "application/json"
//        ]

        
        Alamofire.request("http://127.0.0.1:8000/api/messages/", method: .get).responseString {
            response in
            
            let context = DatabaseController.getContext()
            context.perform {
                //print(response.result.value ?? "")
                do{
                    //delete MapPin
                    let fetchRequest: NSFetchRequest<MapPin> = MapPin.fetchRequest()
                    let allPins = try context.fetch(fetchRequest)
                    
                    for item in allPins {
                        context.delete(item)
                    }
                    //delete Events
                    let fetchRequestForEvent: NSFetchRequest<Events> = Events.fetchRequest()
                    let allEvents = try context.fetch(fetchRequestForEvent)
                    
                    for items in allEvents {
                        context.delete(items)
                    }

                    
                    

                    let jsonString = response.result.value!
                    let jsonData = jsonString.data(using: .utf8)
                    //let jsonResult = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    let jsonArray = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSArray
                    //print(jsonArray)
                    
                    for(_,jsonObject) in jsonArray.enumerated(){
                        let currentEvent:Dictionary = jsonObject as! Dictionary<String,AnyObject>
                        let NAME = "name"
                        //let LOCATION = "location"
                        let DECRIPTION = "description"
                        let LAT = "latitude"
                        let LON = "longitude"
                        let CONTENT = "content"
                        let OWNER = "owner"
                        //print(currentEvent)
                        let namestring:String = currentEvent[NAME] as! String
                        let description:String = currentEvent[DECRIPTION] as! String
                        let content:String = currentEvent[CONTENT] as! String
                        let owner:String = currentEvent[OWNER] as! String
                        //let locationDic: Dictionary = currentEvent[LOCATION] as! Dictionary<String,Double>
                        let lat:Double = currentEvent[LAT] as! Double
                        let lon:Double = currentEvent[LON] as! Double
                        
                        let newMapPinEntity = MapPin(context: context)
                        newMapPinEntity.pinTitle = namestring
                        newMapPinEntity.pinDescription = description
                        newMapPinEntity.pinLat = lat as NSNumber
                        newMapPinEntity.pinLon = lon as NSNumber
                        
                        let EventEntity = Events(context:context)
                        EventEntity.content = content
                        EventEntity.lat = lat as NSNumber
                        EventEntity.lon = lon as NSNumber
                        EventEntity.owner = owner
                        
                        newMapPinEntity.setValue(EventEntity, forKey: "relationshipToEvents")
                        
                    }
                    
                }
                catch {
                    print(error)
                }
                DatabaseController.saveContext()
            }
        }
    }

    
    
    
    

    static let persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "Final_Project")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

// MARK: - Core Data Saving support

   class func saveContext () {
    let context = DatabaseController.persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
}
