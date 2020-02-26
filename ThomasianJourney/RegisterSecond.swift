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
        
    @IBOutlet weak var verificationLabel: UILabel!
    
    let preferences = UserDefaults.standard
    
    var isReadyToResend = true;
    //var emailRequestStart = 3000000000
    //let uptimeNanoseconds: UInt64 = 0
    //let when = (DispatchTime.now() + 0)
    var start = DispatchTime.now()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //verifyCode.delegate = self
        
        if preferences.string(forKey: "useremail") == nil {
            print ("User Email did not save.")
        }

        else {
            let email = preferences.string(forKey: "useremail")
            verificationLabel.text = "\(email ?? "")"
        }
        
        let Tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
        // Do any additional setup after loading the view.
        
        Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true) { (Timer) in
            //print ("60 seconds.")
            self.isReadyToResend = true
            self.start = DispatchTime.now()
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
//            self.isReadyToResend = true
//            self.start = DispatchTime.now()
//            print(self.isReadyToResend)
//        }
    }
    
    @IBAction func verifyButton(_ sender: Any) {
        
        if verifyCode.text!.count != 6 {
            self.showToast(controller: self, message: "Please make sure you have properly typed the verification code.", seconds: 2)
        }
        
        else {
            //let encodedData = NSKeyedArchiver.archivedData(withRootObject: verifyCode ??  "")
            //preferences.set(encodedData, forKey: "verifyCode")

            preferences.set(verifyCode.text, forKey: "verifyCode")

            //  Save to disk
            let didSave = preferences.synchronize()

            if !didSave {
                //print ("Verification Code could not save.")
                self.showToast(controller: self, message: "Error Creating User", seconds: 2)
            }

            else {
                self.transitionToLoading()
                //print ("Verification Code saved.")
            }
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.transitionToFirst()
    }
    
    @IBAction func resendCodeButton(_ sender: Any) {
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

        //print("Nano Time: \(nanoTime) \nTime Interval: \(timeInterval)")
        
        if isReadyToResend == true || timeInterval >= 300 {
            isReadyToResend = false
            
            let alert = UIAlertController(title: "Resend Verification Code", message: "A verification code will be sent to your e-mail account.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Resend", style: .default, handler: { (action) in
                //print ("Will resend code now.")
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
        
        else {
            self.showToast(controller: self, message: "Please wait another five minutes before requesting another verification code", seconds: 2)
        }
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
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
