//
//  SignUpViewController.swift
//  Final Project
//
//  Created by zimingg on 3/14/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Alamofire
import CoreData


class SignUpViewController: UIViewController {

    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var username : UITextField!
    
    @IBOutlet var passwordLabel : UILabel!
    @IBOutlet var password : UITextField!
    
  
    
    @IBAction func back(_ sender: Any){
        self.dismiss(animated: true)
        
    }
    
    @IBAction func signUp(_ sender: Any){
        let parameters: Parameters = [
            "username": username.text! as String,
            "password": password.text! as String
        ]
        let headers_super: HTTPHeaders = [
            "Authorization": "Token 7180abd5e048f813ad911d278c88f2cc46e080c9",
            "Accept": "application/json"
        ]

        Alamofire.request("http://127.0.0.1:8000/api/users/", method: .post, parameters:parameters, headers:headers_super).responseString { response in
            
            do{
                let jsonString = response.result.value!
                let jsonData = jsonString.data(using: .utf8)
                //let jsonResult = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                let jsonDict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                
                if let name_varification = jsonDict["username"]{
                    print("name_v is: \(name_varification)")
                    
                    if (name_varification as? String  == self.username.text){
                        print("hahahaha")
                        
                        self.dismiss(animated: true)


                    }
                    else{
                        let alert = UIAlertController(title: "Alert", message: "Invalid input! Sign up failed!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
    

            }
            catch {print(error)}

        }
    }

    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}






     //self.dismiss(animated: true)


