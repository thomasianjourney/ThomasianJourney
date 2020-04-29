//
//  MenuPortfolio.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit

class MenuPortfolio: UIViewController {
    
    var yearlevel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard

        if preferences.string(forKey: "yearID") == nil {

            showToastToMain(controller: self, message: "No data", seconds: 3)

        }

        else {
            
            yearlevel = preferences.string(forKey: "yearID")!
            
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        if identifier == "ToFirstYear" {

            if Int(yearlevel)! >= 1 {

                //performSegue(withIdentifier: "ToSecondYear", sender: nil)
                return true

            }

            else {

                showToast(controller: self, message: "Not Yet Available", seconds: 3)
                return false

            }
        }

        else if identifier == "ToSecondYear" {

            if Int(yearlevel)! >= 2 {

                return true

            }

            else {

                showToast(controller: self, message: "Not Yet Available", seconds: 3)
                return false

            }

        }

        else if identifier == "ToThirdYear" {

            if Int(yearlevel)! >= 3 {

                return true

            }

            else {

                showToast(controller: self, message: "Not Yet Available", seconds: 3)

            }

        }

        else if identifier == "ToFourthYear" {

            if Int(yearlevel)! >= 4 {

                return true

            }

            else {

                showToast(controller: self, message: "Not Yet Available", seconds: 3)
                return false

            }

        }

        else {

            return false

        }

        return false

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
    
    func transitionToMain() {
        
        let mainPage =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainPage) as? MainPage
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
        
    }
    
    func showToastToMain(controller: UIViewController, message : String, seconds: Double) {
        
        DispatchQueue.main.async {
        
             let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
             alert.view.backgroundColor = .black
             alert.view.alpha = 0.5
             alert.view.layer.cornerRadius = 15
             controller.present(alert, animated: true)
                     
             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                 alert.dismiss(animated: true)
                 self.transitionToMain()
             }
         }
    
    }
    
}
