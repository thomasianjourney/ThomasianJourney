//
//  EventCell.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 3/24/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet var dateBox: UILabel!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventDescription: UILabel!
    @IBOutlet var eventStatus: UILabel!
    
    func setTitle (event: AllEventDetails) {
        
        let status = event.status
        let date = event.eventDate.components(separatedBy: CharacterSet(charactersIn: "-: "))
        var month = date[1]
        let year = date[0]
        let day = date[2]
        print ("DATE TESTING FOR FORMATTING \(date)")
        
        switch status {
            
        case "absent":
            eventStatus.text = "Not Attended"
        case "upcoming":
            eventStatus.text = "Event Not Yet Available"
            eventStatus.textColor = UIColor(red: 255, green: 140, blue: 0, alpha: 1)
        case "available":
            eventStatus.text = "Event Available"
            eventStatus.textColor = UIColor(red: 0, green: 128, blue: 0, alpha: 1)
        case "cancelled":
            eventStatus.text = "Cancelled"
            eventStatus.textColor = UIColor(red: 178, green: 34, blue: 34, alpha: 1)
        default:
            eventStatus.text = "Attended"
            eventStatus.textColor = UIColor(red: 0, green: 128, blue: 0, alpha: 1)
        }
        
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
        
        dateBox.text = "\(month) \(day) \(year)"
        eventTitle.text = event.activityName
        eventDescription.text = event.eventVenue
    }

}
 
