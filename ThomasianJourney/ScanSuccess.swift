//
//  ScanSuccess.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
import Lottie

class ScanSuccess: UIViewController {

    @IBOutlet var animationView: AnimationView!
    
    func playAnimation(){
        animationView.animation = Animation.named("qr")
        animationView.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playAnimation()
    }

    @IBAction func backToHome(_ sender: Any) {
        
        let mainPage =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainPage) as? MainPage
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func printSticker(_ sender: Any) {
    }
}
