//
//  EventsTabController.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 5/5/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

class EventsTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_help_white_small"), style: .plain, target: self, action: #selector(goToViewHelp))
    }
    
    @objc func goToViewHelp() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let showViewHelp =
        main.instantiateViewController(withIdentifier: Constants.Storyboard.viewHelp) as! ViewHelpController
        
        present(showViewHelp, animated: true, completion: nil)
    }

}
