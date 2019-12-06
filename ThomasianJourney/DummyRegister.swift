//
//  DummyRegister.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 12/6/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
import Firebase

class DummyRegister: UIViewController {

    @IBOutlet weak var LinkSent: UILabel!
    
    @IBOutlet weak var proceedButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var emailLabel: UIButton!
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener { (auth, user) in
            let useremail = user!.email
            self.LinkSent.text = "An e-mail with the verification link has been sent to \(useremail ?? "")"
        }
    }
    
    @IBAction func proceedTapped(_ sender: Any) {
        user!.reload {(error) in
            switch self.user!.isEmailVerified {
            case true:
                let registerSecondLoading =
                    self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSecondLoading) as? RegisterSecondLoading
                
                        self.view.window?.rootViewController = registerSecondLoading
                        self.view.window?.makeKeyAndVisible()
            case false:
                self.showToast(controller: self, message: "Please make sure you have have clicked on the verification link in your email", seconds: 2)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let registerFirst =
                storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerFirst) as? RegisterFirst
        
                view.window?.rootViewController = registerFirst
                view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        user!.reload { (error) in
            self.user!.sendEmailVerification(completion: { (error) in
                self.showToast(controller: self, message: "New Email Verification link has been sent to your email.", seconds: 2)
            })
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
