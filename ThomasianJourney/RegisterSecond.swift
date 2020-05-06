//
//  RegisterSecond.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
import Lottie

class RegisterSecond: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var code1: UITextField!
    
    @IBOutlet var code2: UITextField!
    
    @IBOutlet var code3: UITextField!
    
    @IBOutlet var code4: UITextField!
    
    @IBOutlet var code5: UITextField!
    
    @IBOutlet var code6: UITextField!
    
    @IBOutlet weak var verificationLabel: UILabel!
    
    @IBOutlet var animationView: AnimationView!
    
    let preferences = UserDefaults.standard
    
    var isReadyToResend = true;
    var start = DispatchTime.now()
    
    func playAnimation() {
        animationView.animation = Animation.named("mail")
        animationView.play()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case code1:
                code2.becomeFirstResponder()
            case code2:
                code3.becomeFirstResponder()
            case code3:
                code4.becomeFirstResponder()
            case code4:
                code5.becomeFirstResponder()
            case code5:
                code6.becomeFirstResponder()
            case code6:
                code6.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case code1:
                code1.becomeFirstResponder()
            case code2:
                code1.becomeFirstResponder()
            case code3:
                code2.becomeFirstResponder()
            case code4:
                code3.becomeFirstResponder()
            case code5:
                code4.becomeFirstResponder()
            case code6:
                code5.becomeFirstResponder()
            default:
                break
            }
        }
        else{

        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
        //verifyCode.delegate = self
        
        code1.delegate = self
        code2.delegate = self
        code3.delegate = self
        code4.delegate = self
        code5.delegate = self
        code6.delegate = self
        
        code1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        code2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        code3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        code4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        code5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        code6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
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
    }
    
    @IBAction func verifyButton(_ sender: Any) {
        let verifyCode = "\((code1?.text)!)\((code2?.text)!)\((code3?.text)!)\((code4?.text)!)\((code5?.text)!)\((code6?.text)!)"
        
        if verifyCode == "" {
            self.showToast(controller: self, message: "Code is empty.", seconds: 3)
        }
        
        if verifyCode.count != 6 {
            self.showToast(controller: self, message: "Code is incorrect.", seconds: 3)
        }
        
        else {
            preferences.set(verifyCode, forKey: "verifyCode")

            //  Save to disk
            let didSave = preferences.synchronize()

            if !didSave {
                //print ("Verification Code could not save.")
                self.showToast(controller: self, message: "Error Creating User", seconds: 3)
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
                if self.preferences.string(forKey: "useremail") == nil || self.preferences.string(forKey: "usernumber") == nil {
                    print ("User Email/Number did not save.")
                    self.showToastFirst(controller: self, message: "Error Creating User", seconds: 3)
                }

                else {
                    let email = self.preferences.string(forKey: "useremail")
                    let mobilenumber = self.preferences.string(forKey: "usernumber")
                    
                    //print ("Email: \(email ?? "") Mobile Number: \(mobilenumber ?? "")")

                    let url = URL(string: "https://thomasianjourney.website/register/registerUser")!

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                          
                    let postData = "emailAddress="+email!+"&mobileNumber="+mobilenumber!;

                    request.httpBody = postData.data(using: String.Encoding.utf8)
                            
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                                
                        if error != nil{
                            //print("Connection Error: \(String(describing: error))")
                            self.showToastFirst(controller: self, message: "Request timeout, please try again.", seconds: 3)
                            return;
                        }
                            
                        else {
//                            DispatchQueue.main.async {
//                                self.transitionToLoading()
//                            }
//
//                            guard let data = data else { return }
//
//                            do {
//                                let connection = try JSONDecoder().decode(Connection.self, from: data)
//                                print (connection)
//                                print (connection.data.studregId)
//                                preferences.set(connection.data.studregId, forKey: "userid")
//                            }
//
//                            catch {
//                               print(error)
//                            }
                            
                            self.showToast(controller: self, message: "New verification sent. Please wait for a few minutes before requesting again", seconds: 3)
                        }
                    }
                    
                    task.resume()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
        
        else {
            self.showToast(controller: self, message: "Please wait another five minutes before requesting another verification code", seconds: 3)
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

}
