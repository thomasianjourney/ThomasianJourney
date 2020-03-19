//
//  MainPage.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit

class MainPage: UIViewController {

    @IBOutlet var gifView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifView.loadGif(name: "tjmov")
    }
    
    @IBAction func viewCalendarTapped(_ sender: UIButton) {
        let viewCalendar =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.viewCalendar) as? ViewCalendar
        
        view.window?.rootViewController = viewCalendar
        view.window?.makeKeyAndVisible()
    }

}
