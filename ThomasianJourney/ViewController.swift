//
//  ViewController.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 11/27/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var TopBackground: UIImageView!
    
    @IBOutlet weak var doRoundedButton: UIButton!
    
    var gradientLayer: CAGradientLayer!
    
    /*func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //doRoundedButton.layer.cornerRadius = 20
    }
    
}

