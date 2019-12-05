//
//  RegisterFirstLoading.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterFirstLoading: UIViewController {
    
    @IBOutlet weak var proceedButton: UIButton!
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user!.reload { (error) in
            switch self.user!.isEmailVerified {
            case true:
                print("User's email is verified")
            case false:
                
                self.user!.sendEmailVerification { (error) in
                    
                    guard let error = error else {
                        return print("User Email Verification sent")
                    }
                    
                    //self.handleError(error: error)
                }
                
                print("verify it now")
            }
        }
    }
    
    @IBAction func proceedTapped(_ sender: Any) {
        let registerSecondLoading =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSecondLoading) as? RegisterSecondLoading
        
        view.window?.rootViewController = registerSecondLoading
        view.window?.makeKeyAndVisible()    
    }
}
