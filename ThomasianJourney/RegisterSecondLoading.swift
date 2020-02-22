//
//  RegisterSecondLoading.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let decoded  = UserDefaults.standard.object(forKey: "verifyCode")
        //let verifyCode = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data)
        let preferences = UserDefaults.standard
        let verifyCode = preferences.string(forKey: "verifyCode")
        let studentid = preferences.string(forKey: "userid")
        print (verifyCode ?? "No Verify Code Saved")
        print (studentid ?? "No Student ID Saved")

        if verifyCode == nil {
            print ("Verification Code did not save.")
        }

        else {
        
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
                    self.showToast(controller: self, message: "Connection Error. Please make sure you are connected to the internet. ", seconds: 3)
                    return;
                  
                }
              
                else {
              
                    guard let data = data else { return }
                     
                    do {
                          
                        let connection = try JSONDecoder().decode(NewConnection.self, from: data)
                        //print (connection)
                        //print (connection.message)
                          
                        if connection.message.contains("not found") {
                            self.showToast(controller: self, message: "Please request for a new verification code", seconds: 3)
                            print(error ?? "")
                            //DispatchQueue.main.async {
                                //self.transitionToFirst()
                            //}
                        }
                        
                        if connection.message.contains("login successful.") {
                            print("Login Successful")
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
                        print(error)
                    }
                  
                }
            }

            //executing the task
            task.resume()
        }
//        let user = Auth.auth().currentUser
//        
//        user!.reload { (error) in
//            switch user!.isEmailVerified {
//            case true:
//                //print("Email is verified")
//                let registerSuccess =
//                    self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSuccess) as? RegisterSuccess
//                
//                self.view.window?.rootViewController = registerSuccess
//                self.view.window?.makeKeyAndVisible()
//            case false:
//                self.showToast(controller: self, message: "Please make sure you have have clicked on the verification link in your email", seconds: 2)
//            }
//        }
    }
    
//    @IBAction func proceedTapped(_ sender: Any) {
//        let registerSuccess =
//        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSuccess) as? RegisterSuccess
//
//        view.window?.rootViewController = registerSuccess
//        view.window?.makeKeyAndVisible()
//    }
    
    func transitionToMain() {
        
        let registerSuccess =
                storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSuccess) as? RegisterSuccess
        
                view.window?.rootViewController = registerSuccess
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
}
