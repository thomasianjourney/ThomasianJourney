//
//  RegisterSecond.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit

class RegisterSecond: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        let Tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }

}
