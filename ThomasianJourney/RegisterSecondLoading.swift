//
//  RegisterSecondLoading.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterSecondLoading: UIViewController {
    
    @IBOutlet weak var proceedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        
        user!.reload { (error) in
            switch user!.isEmailVerified {
            case true:
                print("Email is verified")
            case false:
                self.showToast(controller: self, message: "Please make sure you have have clicked on the verification link in your email", seconds: 2)
            }
        }
    }
    
    @IBAction func proceedTapped(_ sender: Any) {
        let registerSuccess =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSuccess) as? RegisterSuccess
        
        view.window?.rootViewController = registerSuccess
        view.window?.makeKeyAndVisible()
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
