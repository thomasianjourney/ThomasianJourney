//
//  EventDetails.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 3/25/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

class EventDetails: UIViewController {
    @IBOutlet var eventDescription: UILabel!
    
    var nameofevent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDescription.text = "\(nameofevent)"
    }
}
