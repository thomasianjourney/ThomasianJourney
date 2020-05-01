//
//  VerifyLoginCredSuc.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 4/23/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit
import Lottie

class VerifyLoginCredSuc: UIViewController {
    
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var animationView: AnimationView!
    
    var activityid = ""
    var useremail = ""
    
    func playAnimation(){
        animationView.animation = Animation.named("check")
        animationView.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()

        emailLabel.text = "\(useremail) account."

    }

    @IBAction func continueToScan(_ sender: Any) {
    
        let ScanQRCode =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ScanQRCode) as? ScanQRCode
        ScanQRCode?.activityid = self.activityid
        view.window?.rootViewController = ScanQRCode
        view.window?.makeKeyAndVisible()
    
    }
}
