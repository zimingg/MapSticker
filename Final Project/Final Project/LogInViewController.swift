//
//  LogInViewController.swift
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



class LogInViewController: UIViewController {
    
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var username : UITextField!
    
    @IBOutlet var passwordLabel : UILabel!
    @IBOutlet var password : UITextField!
    
 //    @IBOutlet var noticeLabel : UILabel!
    
    @IBAction func signUp(_ sender: Any){
        
        performSegue(withIdentifier: "signupsegue", sender: self)
    }
    
    func setVaule(username: String, password: String){
        
        print("set!!!")
        
    }
    
    
    @IBAction func login(_ sender: Any){
        let parameters: Parameters = [
            "username": username.text! as String,
            "password": password.text! as String
        ]
        let headers_super: HTTPHeaders = [
            "Authorization": "Token 7180abd5e048f813ad911d278c88f2cc46e080c9",
            "Accept": "application/json"
        ]
        
 
////        
//         Alamofire.request("http://127.0.0.1:8000/api/users/", method: .post, parameters:parameters, headers:headers_super).responseJSON { response in
//            debugPrint(response)
//            print(self.username.text)
//            
//                      }
       
      Alamofire.request("http://127.0.0.1:8000/api/auth/login/", method: .post, parameters:parameters, headers:headers_super).responseString { response in

                do{
                    let jsonString = response.result.value!
                    let jsonData = jsonString.data(using: .utf8)
                    //let jsonResult = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    let jsonDict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDict)
        
                   
                    if let TOKEN = jsonDict["token"]{
                        //print(TOKEN as! String)
                         //self.noticeLabel.text = "login successed!"
                        
                        let context = DatabaseController.getContext()
                        context.perform {
                            
                            let UserEntity = Users(context:context)
                            UserEntity.name = self.username.text! as String
                            //UserEntity.password = self.password.text! as String
                            UserEntity.token = TOKEN as? String
                            
                            DatabaseController.saveContext()

                        }
                        
                        
                        
                         self.dismiss(animated: true)
                        
                        
                    }
                    else{
                        let alert = UIAlertController(title: "Alert", message: "Invalid input! Log in failed!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        //self.noticeLabel.text = "login failed!"
                    }
        
                }
                catch {
                    print(error)
                }


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

