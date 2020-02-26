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
        animationView.loopMode = .loop
        animationView.play()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        let mainPage =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainPage) as? MainPage
        
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
    }

}
