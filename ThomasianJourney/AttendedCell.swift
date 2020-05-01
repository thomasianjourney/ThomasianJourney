//
//  AttendedCell.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 4/28/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

class AttendedCell: UITableViewCell {

    @IBOutlet var dateBox: UILabel!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventDescription: UILabel!
    @IBOutlet var eventStatus: UILabel!
    
    func setTitle (event: AttendedEventDetails) {
        
        let date = event.eventDate.components(separatedBy: CharacterSet(charactersIn: "-: "))
        var month = date[1]
        let year = date[0]
        let day = date[2]
        
        eventStatus.text = "Attended"
        eventStatus.textColor = UIColor(hexString: "#008000")
        
        switch month {
        case "01":
            month = "Jan"
        case "02":
            month = "Feb"
            break;
        case "03":
            month = "Mar"
        case "04":
            month = "April"
        case "05":
            month = "May"
        case "06":
            month = "Jun"
        case "07":
            month = "Jul"
        case "08":
            month = "Aug"
        case "09":
            month = "Sep"
        case "10":
            month = "Oct"
        case "11":
            month = "Nov"
        case "12":
            month = "Dec"
        default:
            month = ""
        }
        
        dateBox.text = "\(month)\n\(day)\n\(year)"
        eventTitle.text = event.activityName
        eventDescription.text = event.eventVenue
    }

}
