//
//  ScanSuccess.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit

class ScanSuccess: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backToHome(_ sender: Any) {
        
        let mainPage =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainPage) as? MainPage
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func viewPortfolio(_ sender: Any) {
        
        let menuPortfolio =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.menuPortfolio) as? MenuPortfolio
        view.window?.rootViewController = menuPortfolio
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func printSticker(_ sender: Any) {
    }
}
