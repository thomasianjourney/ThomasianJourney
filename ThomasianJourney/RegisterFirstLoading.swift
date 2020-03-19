//
//  RegisterFirstLoading.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 2/16/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit
import Lottie

struct Connection: Decodable {
    let status: String
    let message: String
    let data: DataContents
}

struct DataContents: Decodable {
    let studregEmail: String
    let studregmobileNum: String
    let studregId: String
}

class RegisterFirstLoading: UIViewController {
    
    //@IBOutlet weak var proceedButton: UIButton!
    
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

        if preferences.string(forKey: "useremail") == nil || preferences.string(forKey: "usernumber") == nil {
            //print ("User Email/Number did not save.")
            self.showToastFirst(controller: self, message: "Incomplete data found.", seconds: 3)
//            DispatchQueue.main.async {
//                self.transitionToFirst()
//            }
        }

        else {
            let email = preferences.string(forKey: "useremail")
            let mobilenumber = preferences.string(forKey: "usernumber")

            //print ("Shared Preferences from Loading: \(email ?? "") and \(mobilenumber ?? "")")
            
            //creating URLRequest
            let url = URL(string: "https://thomasianjourney.website/register/registerUser")!

            //setting the method to post
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
          
            //creating the post parameter by concatenating the keys and values from text field
            let postData = "emailAddress="+email!+"&mobileNumber="+mobilenumber!;

            //adding the parameters to request body
            request.httpBody = postData.data(using: String.Encoding.utf8)
            
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
               data, response, error in
                
                if error != nil{
                    print("Connection Error: \(String(describing: error))")
                    self.showToastFirst(controller: self, message: "Connection Error. Please make sure you are connected to the internet. ", seconds: 3)
                    return;
                
                }
            
               else {
            
                    guard let data = data else { return }
                   
                    do {
                        let connection = try JSONDecoder().decode(Connection.self, from: data)
                        print (connection)
                        //print (connection.data.studregId)
                        preferences.set(connection.data.studregId, forKey: "userid")
                        
//                        if connection.message.contains("already exists") {
//                            self.showToast(controller: self, message: "Account already exists.", seconds: 3)
//                            DispatchQueue.main.async {
//                                self.transitionToFirst()
//                            }
//                        }
                        
                        if connection.message.contains("entered Wrong Email/Password") {
                            self.showToastFirst(controller: self, message: "Email Not Found.", seconds: 3)
//                            DispatchQueue.main.async {
//                                self.transitionToFirst()
//                            }
                        }
                        
                        else if connection.message.contains("not entered an Email/Password") {
                            self.showToastFirst(controller: self, message: "Incomplete Data Entered.", seconds: 3)
//                            DispatchQueue.main.async {
//                                self.transitionToFirst()
//                            }
                        }
                        
                        else {
                            DispatchQueue.main.async {
                                self.transitionToLoading()
                            }
                        }
                        
                    }
                   
                    catch {
                       //print("THIS IS THE ERROR \(error)")
                        self.showToastFirst(controller: self, message: "Email Not Found.", seconds: 3)
//                        DispatchQueue.main.async {
//                            self.transitionToFirst()
//                        }
                    }
                
                }
           }

           //executing the task
           task.resume()
        }
    }
    
    func transitionToLoading() {
        let registerSecond =
                storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSecond) as? RegisterSecond
        
                view.window?.rootViewController = registerSecond
                view.window?.makeKeyAndVisible()
    }
    
    func transitionToFirst() {
        let registerFirst =
                storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerFirst) as? RegisterFirst
        
                view.window?.rootViewController = registerFirst
                view.window?.makeKeyAndVisible()
    }
    
    func showToastFirst(controller: UIViewController, message : String, seconds: Double) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            
            controller.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
                self.transitionToFirst()
            }
        }
    }
    
    func showToastLoading(controller: UIViewController, message : String, seconds: Double) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            
            controller.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
                self.transitionToLoading()
            }
        }
    }
}
