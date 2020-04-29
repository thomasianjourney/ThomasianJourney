//
//  FirstYearMustDoCell.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 4/29/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

class FirstYearMustDoCell: UITableViewCell {

    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var subtitleContents: UILabel!
    
    func setTitle (event: FirstYearMustDoDetails) {
        
        eventTitle.text = event.activityName
        eventDate.text = event.eventDate
        subtitleContents.text = event.eventVenue
        
    }
    
}
