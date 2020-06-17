//
//  RegisterFirst.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
    
class RegisterFirst: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var mobilenumber: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
 
        mobilenumber.delegate = self
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  || mobilenumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Email and Mobile Number cannot be empty."
        }
        
        let cleanedEmail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isEmailValid(cleanedEmail) == false || cleanedEmail.contains("@ust.edu.ph") == false {
            // Invalid email format
            return "Please make sure you have typed a valid @ust.edu.ph email."
        }
        
        else if mobilenumber.text!.count != 11 {
            return "Please make sure you have typed a valid mobile number."
        }
        
        else if (isEmailValid(cleanedEmail) == false || cleanedEmail.contains("@ust.edu.ph") == false) && (mobilenumber.text!.count != 11) {
            return "Please make sure you have typed a valid @ust.edu.ph email and mobile number."
        }
        
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
                //print ("Shared preferences could not save.")
                self.showToast(controller: self, message: "Error Creating User", seconds: 2)
            }

            else {
                self.transitionToLoading()
                //print ("Shared preferences saved.")
            }
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
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//        let compSepByCharInSet = string.components(separatedBy: aSet)
//        let numberFiltered = compSepByCharInSet.joined(separator: "")
//        return string == numberFiltered
//    }
    
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 11 characters
        return updatedText.count <= 11
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
