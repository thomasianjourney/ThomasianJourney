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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
    
    }
    //this function prints something when a date is selected
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //insert code here
        
    }
    
}
