//
//  RegisterSecond.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit

class RegisterSecond: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var verifyCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //verifyCode.delegate = self
        
        let Tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func verifyButton(_ sender: Any) {
        
        if verifyCode.text!.count != 6 {
            self.showToast(controller: self, message: "Please make sure you have properly typed the verification code.", seconds: 2)
        }
        
        else {
            //let encodedData = NSKeyedArchiver.archivedData(withRootObject: verifyCode ??  "")
            let preferences = UserDefaults.standard
            //preferences.set(encodedData, forKey: "verifyCode")

            preferences.set(verifyCode.text, forKey: "verifyCode")

            //  Save to disk
            let didSave = preferences.synchronize()

            if !didSave {
                //  Couldn't save (I've never seen this happen in real world testing)
                print ("Verification Code could not save.")
                self.showToast(controller: self, message: "Error Creating User", seconds: 2)
            }

            else {
                self.transitionToLoading()
                print ("Verification Code saved.")
            }
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.transitionToFirst()
    }
    
    @IBAction func resendCodeButton(_ sender: Any) {
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // get the current text, or use an empty string if that failed
//        let currentText = textField.text ?? ""
//
//        // attempt to read the range they are trying to change, or exit if we can't
//        guard let stringRange = Range(range, in: currentText) else { return false }
//
//        // add their new text to the existing text
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//
//        // make sure the result is under 6 characters
//        return updatedText.count <= 6
//    }
    
    func transitionToFirst() {
        
        let registerFirst =
                storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerFirst) as? RegisterFirst
        
                view.window?.rootViewController = registerFirst
                view.window?.makeKeyAndVisible()
    }
    
    func transitionToLoading() {
        
        let registerSecondLoading =
                storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSecondLoading) as? RegisterSecondLoading
        
                view.window?.rootViewController = registerSecondLoading
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
