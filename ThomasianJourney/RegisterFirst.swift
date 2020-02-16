//
//  RegisterFirst.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
//import FirebaseAuth
//import Firebase

class RegisterFirst: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var mobilenumber: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mobilenumber.delegate = self
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  || mobilenumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields."
        }
        
        let cleanedEmail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //let cleanedMobileNumber = mobilenumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isEmailValid(cleanedEmail) == false || cleanedEmail.contains("@ust.edu.ph") == false {
            // Invalid email format
            return "Please make sure you have typed a valid @ust.edu.ph email."
        }
        
//        if textField(mobilenumber, shouldChangeCharactersIn: NSRange, replacementString: " ") == true {
//            // Make sure only numbers are typed
//            return "Please make sure you have typed a valid mobile number."
//        }
        
        return nil
        
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        // Register credentials of user
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message error
            self.showToast(controller: self, message: error!, seconds: 2)
        }
        
        else {
            
            // Create cleaned versions of the data
            let emailauth = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let mobilenumberauth = mobilenumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            
            let preferences = UserDefaults.standard

            preferences.set(emailauth, forKey: "useremail")
            preferences.set(mobilenumberauth, forKey: "usernumber")

            //  Save to disk
            let didSave = preferences.synchronize()

            if !didSave {
                //  Couldn't save (I've never seen this happen in real world testing)
                print ("Shared preferences could not save.")
                self.showToast(controller: self, message: "Error Creating User", seconds: 2)
            }

            else {
                self.transitionToLoading()
                print ("Shared preferences saved.")
            }
            
//            Auth.auth().createUser(withEmail: emailauth, password: mobilenumberauth) { (res, err) in
//                // Check for errors
//                if err != nil {
//
//                    // There was an error creating the user
//                    self.showToast(controller: self, message: "Error Creating User", seconds: 2)
//                }
//
//                else {
//
//                    // User was created successfully, now store the first name and last name
//                    let db = Firestore.firestore()
//
//                    db.collection("Users").addDocument(data: ["Email":emailauth, "MobileNumber":mobilenumberauth, "uid":res!.user.uid]) { (error) in
//
//                        if error != nil {
//                            // Show error message
//                            self.showToast(controller: self, message: "Error saving data", seconds: 2)
//                        }
//                    }
//
                    self.transitionToLoading()
//                }
//            }
        }
    }
    
    // Check if email is in valid format
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
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
    
    // Check if number is right amount of digits
    
    func transitionToLoading() {
        
        let registerFirstLoading =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerFirstLoading) as? RegisterFirstLoading
        
        view.window?.rootViewController = registerFirstLoading
        view.window?.makeKeyAndVisible()
    }
}
