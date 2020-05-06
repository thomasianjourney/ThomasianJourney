//
//  ViewCalendar.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 2/16/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import FSCalendar
import UIKit

class ViewCalendar: UIViewController, FSCalendarDelegate {
    
    @IBOutlet var calendar: FSCalendar!
    
    @IBAction func viewHelpTapped(_ sender: UIButton) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let showViewHelp =
        main.instantiateViewController(withIdentifier: Constants.Storyboard.viewHelp) as! ViewHelpController
        
        present(showViewHelp, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_help_white_small"), style: .plain, target: self, action: #selector(goToViewHelp))
    
    }
    
    @objc func goToViewHelp() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let showViewHelp =
        main.instantiateViewController(withIdentifier: Constants.Storyboard.viewHelp) as! ViewHelpController
        
        present(showViewHelp, animated: true, completion: nil)
    }
    
    //this function prints something when a date is selected
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //insert code here
        
    }
    
}
