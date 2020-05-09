//
//  PrivacyPolicyViewController.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 5/10/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet var privacy: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.bottomAnchor.constraint(equalTo: privacy.bottomAnchor).isActive = true
        
        if let filepath = Bundle.main.path(forResource: "privacypolicy", ofType: "txt") {
            do {
                let policy = try String(contentsOfFile: filepath)
                privacy.text = policy
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
    }
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        let registerFirst =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerFirst) as? RegisterFirst
        
        view.window?.rootViewController = registerFirst
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func declineTapped(_ sender: UIButton) {
        exit(EXIT_SUCCESS)
    }
    
    

}
