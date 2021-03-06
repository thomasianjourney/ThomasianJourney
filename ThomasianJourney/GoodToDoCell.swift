//
//  GoodToDoCell.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 5/1/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

class GoodToDoCell: UITableViewCell {

    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var subtitleContents: UILabel!
    
    func setTitle (event: GoodToDoDetails) {
        
        eventTitle.text = event.activityName
        eventDate.text = event.eventDate
        subtitleContents.text = event.eventVenue
        
    }
    
}
