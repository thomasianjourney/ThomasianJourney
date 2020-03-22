//
//  RegisterSuccess.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
import Lottie

class RegisterSuccess: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet var animationView: AnimationView!
    
    func playAnimation () {
        animationView.animation = Animation.named("check")
        animationView.play()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
        // Do any additional setup after loading the view.

        let preferences = UserDefaults.standard
        
        if preferences.string(forKey: "studName") == nil {
            showToastSecond(controller: self, message: "Student Name Not Found. Please try again.", seconds: 3)
        }
        
        else if preferences.string(forKey: "collegeID") == nil {
            showToastSecond(controller: self, message: "Student College ID Not Found. Please try again.", seconds: 3)
        }
        
        else if preferences.string(forKey: "yearID") == nil {
            showToastSecond(controller: self, message: "Student Year Level Not Found. Please try again.", seconds: 3)
        }
        
        else if preferences.string(forKey: "studPoints") == nil {
            showToastSecond(controller: self, message: "Student Points Not Found. Please try again.", seconds: 3)
        }
            
        else if preferences.string(forKey: "studName") == nil && preferences.string(forKey: "collegeID") == nil && preferences.string(forKey: "yearID") == nil && preferences.string(forKey: "studPoints") == nil {
            showToastSecond(controller: self, message: "Student Information Not Found. Please try again.", seconds: 3)
        }

        else {
            preferences.set(preferences.string(forKey: "useremail"), forKey: "mainuseremail")
            preferences.set(preferences.string(forKey: "usernumber"), forKey: "mainusernumber")
            preferences.set(preferences.string(forKey: "userid"), forKey: "mainuserid")
        }
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        let mainPage =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainPage) as? MainPage
        
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToSecond() {
        let registerSecond =
                storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerSecond) as? RegisterSecond
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = registerSecond
                appDelegate.window?.makeKeyAndVisible()
    }
    
    func showToastSecond(controller: UIViewController, message : String, seconds: Double) {
                
         DispatchQueue.main.async {
        
             let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
             alert.view.backgroundColor = .black
             alert.view.alpha = 0.5
             alert.view.layer.cornerRadius = 15
             controller.present(alert, animated: true)

             self.transitionToSecond()
                     
             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                 alert.dismiss(animated: true)
             }
         }
    }

}
