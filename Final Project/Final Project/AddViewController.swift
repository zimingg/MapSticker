//
//  ViewController.swift
//  Final Project
//
//  Created by zimingg on 2/23/17.
//  Copyright © 2017 zimingg. All rights reserved.
//


import UIKit
import MapKit
import Alamofire
import CoreData
import CoreLocation

class AddViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var locationManager: CLLocationManager!
    @IBOutlet var EName : UILabel!
    @IBOutlet var ENameInput : UITextField!
    @IBOutlet var ETime : UILabel!
    @IBOutlet var ETimeInput : UITextField!
    
    @IBOutlet var ElatInput : UITextField!
    @IBOutlet var ElonInput : UITextField!
    @IBOutlet var Elat : UILabel!
    @IBOutlet var Elon : UILabel!
    
    @IBOutlet var EContent : UILabel!
    @IBOutlet var EContentInput : UITextField!
    var LAT = ""
    var LONG = ""
    
    @IBAction func SetCurrentLocation(_ sender: Any) {
        //ElatInput.text = UserDefaults.standard.object(forKey: "lat") as! String?
            
//        print(UserDefaults.standard.object(forKey: "lat"))
//        let LONG = UserDefaults.standard.object(forKey: "long")
//        let LAT  = UserDefaults.standard.object(forKey: "lat")
        ElonInput.text = LONG
        ElatInput.text = LAT
        print(LAT)
        print(LONG)
        
    }
    
    @IBAction func Submit(_ sender: Any) {
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        let num1 = Double(ElatInput.text!)
        let num2 = Double(ElatInput.text!)
        
        if (ElatInput.text == "" || ElonInput.text == "" || EContentInput.text == ""){
            let alert = UIAlertController(title: "Alert", message: "Invalid input! Post failed!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (num1 == nil && num2 == nil){
            let alert = UIAlertController(title: "Alert", message: "Invalid input! Post failed!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        else{
        
        
        do{
            let userList = try DatabaseController.getContext().fetch(fetchRequest)
            let CurrentUser = userList[0]
            
            let TOKEN:String = CurrentUser.token!
            let EventName = ENameInput.text
            let EventDiscription = ETimeInput.text
            let EventLon:Double = Double(ElonInput.text!)!
            let EventLat:Double = Double(ElatInput.text!)!
            let EventContent: String = EContentInput.text ?? "NULL"
            //print(EventLon)
            //print(EventLat)
            let parameters: Parameters = [
                
                "content": EventContent,
                "latitude": EventLat,
                "longitude": EventLon,
                "name": EventName ?? "",
                "description": EventDiscription ?? ""
                
            ]
            let headers_c: HTTPHeaders = [
                //"Authorization": "Token 7180abd5e048f813ad911d278c88f2cc46e080c9",
                "Authorization": "Token \(TOKEN)" ,
                "Accept": "application/json"
            ]
            
            //print("the token is: \(TOKEN)")
            
            Alamofire.request("http://127.0.0.1:8000/api/messages/", method: .post, parameters: parameters, headers: headers_c).responseJSON { response in
                debugPrint(response)
                
                let context = DatabaseController.getContext()
                context.perform {
                    let newMapEntity = MapPin(context: context)
                    newMapEntity.pinTitle = EventName
                    newMapEntity.pinDescription = EventDiscription
                    newMapEntity.pinLat = EventLat as NSNumber
                    newMapEntity.pinLon = EventLon as NSNumber
                    
                    
                    let newEventsEntity = Events(context: context)
                    newEventsEntity.lon = EventLon as NSNumber
                    newEventsEntity.lat = EventLat as NSNumber
                    newEventsEntity.content = EventContent
                    
                    newMapEntity.setValue(newEventsEntity, forKey: "relationshipToEvents")
                    
                    try! context.save()
                }
                DatabaseController.loadEventsOnMap() //new added
                let _ = self.navigationController?.popViewController(animated: true)
            }
            
            //        Alamofire.request("http://127.0.0.1:8000/api/messages/24", method: .delete, headers: headers_c).response{ response in
            //            debugPrint(response)
            //        }
            //
            
            
            //MapviewViewController.MapView.add
            
            
            print("done")
            

            
            
        }
            
            
        catch{
            print("Error")
        }
        }
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
         }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

