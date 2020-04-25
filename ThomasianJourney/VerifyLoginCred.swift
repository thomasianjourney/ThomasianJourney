//
//  VerifyLoginCred.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 4/23/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit
import Lottie

class VerifyLoginCred: UIViewController {
    
    @IBOutlet var animationView: AnimationView!
    
    var activityid = ""
    
    func playAnimation(){
        animationView.animation = Animation.named("load")
        animationView.loopMode = .loop
        animationView.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
        
        print (activityid)
    }
    
}
