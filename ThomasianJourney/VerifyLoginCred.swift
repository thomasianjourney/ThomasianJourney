//
//  VerifyLoginCred.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 4/23/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit
import Lottie

struct VerifyMainData: Decodable {
    let status: String
    let message: String
    let data: VerifyStudentData
}

struct VerifyStudentData: Decodable {
    let studentsId: String
    let studregEmail: String
    let studregmobileNum: String
    let studregName: String
    let studNumber: String
    let studPoints: String
    let yearlevelId: String
}

class VerifyLoginCred: UIViewController {
    
    @IBOutlet var animationView: AnimationView!
    
    var activityid = ""
    var useremail = ""
    
    func playAnimation(){
        animationView.animation = Animation.named("load")
        animationView.loopMode = .loop
        animationView.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
        
        //print (activityid)
        
        let preferences = UserDefaults.standard
        
        if preferences.string(forKey: "mainuseremail") == nil && preferences.string(forKey: "mainusernumber") == nil && preferences.string(forKey: "mainuserid") == nil {
            
            showToastToMain(controller: self, message: "No data", seconds: 3)
        
        }
        
        else {
            let studregid = preferences.string(forKey: "mainuserid")
            
            //creating URLRequest
            let url = URL(string: "https://thomasianjourney.website/register/studentdetails")!

            //setting the method to post
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postData = "studentsId="+studregid!;

            //adding the parameters to request body
            request.httpBody = postData.data(using: String.Encoding.utf8)
              
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
                  
                if error != nil{
                    //print("Connection Error: \(String(describing: error))")
                    self.showToastToMain(controller: self, message: "Connection Error, please try again.", seconds: 3)
                    return;
                  
                }
              
                else {
              
                    guard let data = data else { return }
                     
                    do {
                          
                        let connection = try JSONDecoder().decode(VerifyMainData.self, from: data)
                        //print (connection)
                        //print("Testing from Connection Itself: \(connection)")
                          
                        if connection.message.contains("not found") {
                            self.showToastToMain(controller: self, message: "Cannot find Student Details", seconds: 3)
                        }
                        
                        if connection.message.contains("login successful.") {
                            
                            //print ("Testing inside the if's")
                            
                            DispatchQueue.main.async {

                                self.useremail = connection.data.studregEmail
                                self.transitionToVerifySuc()
                                
                            }

                        }
                    }
                     
                    catch {
                        //print(error)
                        self.showToast(controller: self, message: "Cannot find Student Details", seconds: 3)
                    }
                  
                }
            }

            //executing the task
            task.resume()
            
        }
    }
    
    func transitionToVerifySuc() {
        
        let VerifyLoginCredSuc =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.VerifyLoginCredSuc) as? VerifyLoginCredSuc
        VerifyLoginCredSuc?.activityid = self.activityid
        VerifyLoginCredSuc?.useremail = self.useremail
        view.window?.rootViewController = VerifyLoginCredSuc
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToMain() {
        
        let mainPage =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainPage) as? MainPage
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
        
    }
    
    func showToastToMain(controller: UIViewController, message : String, seconds: Double) {
        
        DispatchQueue.main.async {
        
             let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
             alert.view.backgroundColor = .black
             alert.view.alpha = 0.5
             alert.view.layer.cornerRadius = 15
             controller.present(alert, animated: true)
                     
             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                 alert.dismiss(animated: true)
                 self.transitionToMain()
             }
         }
    
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    
    }
    
}
