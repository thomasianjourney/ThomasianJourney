//
//  RegisterFirstLoading.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
//import FirebaseAuth
//import Firebase

struct Connection: Decodable {
    let status: String
    let message: String
}

class RegisterFirstLoading: UIViewController {
    
    //@IBOutlet weak var proceedButton: UIButton!
    
//    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard

        if preferences.string(forKey: "useremail") == nil {
            print ("User Email did not save.")
        }

        if preferences.string(forKey: "usernumber") == nil {
            print ("User Number did not save.")
        }

        else {
            let email = preferences.string(forKey: "useremail")
            let mobilenumber = preferences.string(forKey: "usernumber")

            print ("Shared Preferences from Loading: \(email ?? "") and \(mobilenumber ?? "")")
            
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
                   return;
                
                }
            
               else {
            
                    guard let data = data else { return }
                   
                    do {
                        
                        let connection = try JSONDecoder().decode(Connection.self, from: data)
                        print (connection.message)
                    }
                   
                    catch {
                       print(error)
                    }
                
                }
           }

           //executing the task
           task.resume()
        }
        
//        user!.reload { (error) in
//            switch self.user!.isEmailVerified {
//            case true:
//                print("User's email is verified")
//            case false:
//
//                self.user!.sendEmailVerification { (error) in
//
//                    guard let error = error else {
//                        self.transitionToLoading()
//                        return print("User Email Verification sent")
//                    }
//
//                    print(error.localizedDescription)
//
//                    //self.handleError(error: error)
//                }
//
//                //print("verify it now")
//            }
//        }
    }
    
    func transitionToLoading() {
        
        let dummyRegister =
                storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.dummyRegister) as? DummyRegister
        
                view.window?.rootViewController = dummyRegister
                view.window?.makeKeyAndVisible()
    }
    
//    @IBAction func proceedTapped(_ sender: Any) {
//        let registerSecondLoading =
//        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSecondLoading) as? RegisterSecondLoading
//
//        view.window?.rootViewController = registerSecondLoading
//        view.window?.makeKeyAndVisible()
//    }
}
