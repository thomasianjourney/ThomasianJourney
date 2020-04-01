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
        
        switch status {
            
        case "absent":
            eventStatus.text = "Not Attended"
            eventStatus.textColor = UIColor(hexString: "#FF4444")
        case "upcoming":
            eventStatus.text = "Event Not Yet Available"
            eventStatus.textColor = UIColor(hexString: "#FF8C00")
        case "available":
            eventStatus.text = "Event Available"
            eventStatus.textColor = UIColor(hexString: "#008000")
        case "cancelled":
            eventStatus.text = "Cancelled"
            eventStatus.textColor = UIColor(hexString: "#B22222")
        default:
            eventStatus.text = "Attended"
            eventStatus.textColor = UIColor(hexString: "#008000")
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
        
        dateBox.text = "\(month)\n\(day)\n\(year)"
        eventTitle.text = event.activityName
        eventDescription.text = event.eventVenue
    }

}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }

}
