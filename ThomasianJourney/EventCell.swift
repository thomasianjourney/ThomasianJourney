//
//  EventCell.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 3/24/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet var date: UIButton!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventDescription: UILabel!
    @IBOutlet var eventStatus: UILabel!
    
    func setTitle (event: AllEventDetails) {
        eventTitle.text = event.activityName
        eventDescription.text = event.eventVenue
        eventStatus.text = event.status
        //print (event.activityName)
    }

}
 
