//
//  AttendedTab.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 3/23/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

class AttendedTab: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var tabBarItem1: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarItem1.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Poppins", size: 25) ?? ""], for: .normal)

        //self.tabBarItem = UITabBarItem(title: "ATTENDED", image: nil, selectedImage: nil)
    }
}
