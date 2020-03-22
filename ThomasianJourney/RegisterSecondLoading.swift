//
//  RegisterSecondLoading.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
import Lottie

struct NewConnection: Decodable {
    let status: String
    let message: String
    let data: NewDataContents
}

struct NewDataContents: Decodable {
    let numbercode: String
    let studentsId: String
    let studregEmail: String
    let studregmobileNum: String
    let studentDetails: StudentDataContents
}

struct StudentDataContents: Decodable {
    let studentName: String
    let studentEmail: String
    let studentPoints: String
    let studentCollegeId: String
    let studentYearLevelId: String
}

class RegisterSecondLoading: UIViewController {
    
    @IBOutlet weak var proceedButton: UIButton!
    
    @IBOutlet var animationView: AnimationView!
    
    func playAnimation(){
        animationView.animation = Animation.named("load")
        animationView.loopMode = .loop
        animationView.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
        
        let preferences = UserDefaults.standard

        if preferences.string(forKey: "useremail") == nil {
            showToastSecond(controller: self, message: "Student Email is empty.", seconds: 3)
        }
        
        else if preferences.string(forKey: "usernumber") == nil {
            showToastSecond(controller: self, message: "Student Mobile is empty.", seconds: 3)
        }
        
        else if preferences.string(forKey: "verifyCode") == nil {
            showToastSecond(controller: self, message: "Number code is empty.", seconds: 3)
        }
        
        else if preferences.string(forKey: "userid") == nil {
            showToastSecond(controller: self, message: "Student ID is empty.", seconds: 3)
        }
            
        else if preferences.string(forKey: "useremail") == nil && preferences.string(forKey: "usernumber") == nil && preferences.string(forKey: "verifyCode") == nil && preferences.string(forKey: "userid") == nil {
            showToastSecond(controller: self, message: "Data is empty.", seconds: 3)
        }

        else {
            //let email = preferences.string(forKey: "useremail")
            //let mobile = preferences.string(forKey: "usernumber")
            let verifyCode = preferences.string(forKey: "verifyCode")
            let studentid = preferences.string(forKey: "userid")
        
            //creating URLRequest
            let url = URL(string: "https://thomasianjourney.website/register/checkCode")!

            //setting the method to post
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postData = "numbercode="+verifyCode!+"&studentsId="+studentid!;
            //let postData = "numbercode="+verifyCode!;

            //adding the parameters to request body
            request.httpBody = postData.data(using: String.Encoding.utf8)
              
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
                  
                if error != nil{
                    print("Connection Error: \(String(describing: error))")
                    self.showToastSecond(controller: self, message: "Error, please try again.", seconds: 3)
                    return;
                  
                }
              
                else {
              
                    guard let data = data else { return }
                     
                    do {
                          
                        let connection = try JSONDecoder().decode(NewConnection.self, from: data)
                        //print (connection)
                        //print (connection.message)
                          
                        if connection.message.contains("not found") {
                            self.showToastSecond(controller: self, message: "Code is incorrect.", seconds: 3)
                            //DispatchQueue.main.async {
                                //self.transitionToFirst()
                            //}
                        }
                        
                        if connection.message.contains("login successful.") {
                            //print("Login Successful")
                        
                            preferences.set(connection.data.studentDetails.studentName, forKey: "studName")
                        preferences.set(connection.data.studentDetails.studentCollegeId, forKey: "collegeID")
                        preferences.set(connection.data.studentDetails.studentYearLevelId, forKey: "yearID")
                            preferences.set(connection.data.studentDetails.studentPoints, forKey: "studPoints")
                            
                            DispatchQueue.main.async {
                                self.transitionToMain()
                            }
                        }
                        
                        // remove when Register is fixed
//                        DispatchQueue.main.async {
//                            self.transitionToMain()
//                        }
                    }
                     
                    catch {
                        //print(error)
                        self.showToastSecond(controller: self, message: "Code is incorrect.", seconds: 3)
                    }
                  
                }
            }

            //executing the task
            task.resume()
        }
    }
    
    func transitionToMain() {
        
        let registerSuccess =
                storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSuccess) as? RegisterSuccess
        
                view.window?.rootViewController = registerSuccess
                view.window?.makeKeyAndVisible()
    }
    
    func transitionToSecond() {
        let registerSecond =
                storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSecond) as? RegisterSecond
        
                view.window?.rootViewController = registerSecond
                view.window?.makeKeyAndVisible()
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        DispatchQueue.main.async {
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
    
    func showToastSecond(controller: UIViewController, message : String, seconds: Double) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            
            controller.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
                self.transitionToSecond()
            }
        }
    }
}
