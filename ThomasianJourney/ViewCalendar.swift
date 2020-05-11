//
//  ViewCalendar.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 2/16/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import FSCalendar
import UIKit

struct ViewCalendarData: Decodable {
    let status: String
    let message: String
    let data: [[String]]
}

class CalendarCell: UITableViewCell {
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventVenue: UILabel!
    @IBOutlet var eventTime: UILabel!
}

class ViewCalendar: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    
    var collegeid = ""
    var dataArray = [[]]
    var eventid = ""
    var eventname = ""
    var eventvenue = ""
    var eventstart = ""
    var eventend = ""
    var eventstatus = ""
    var dateswithmarker: [String] = []
    var sameevents: [String] = []
    var allsameevents = [[]]
    var events = [[]]
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)

    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
//        self.view.addSubview(calendar)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_help_white_small"), style: .plain, target: self, action: #selector(goToViewHelp))
        
        let preferences = UserDefaults.standard
                        
        if preferences.string(forKey: "collegeID") == nil {
            transitionToMain()
        }
        
        else {
            collegeid = preferences.string(forKey: "collegeID")!
            loadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let stringdate = formatter.string(from: date)
        print ("\(stringdate)")
        
        allsameevents.removeAll()

        for (_, item) in dataArray.enumerated() {

            sameevents.removeAll()
            
            for _ in item {

                eventid = item[0] as! String
                eventname = item[1] as! String
                eventvenue = item[2] as! String
                eventstart = item[3] as! String
                eventend = item[4] as! String
                eventstatus = item[5] as! String

//                let eventcomponents = eventstart.components(separatedBy: CharacterSet(charactersIn: "-: "))
//                let dateformat = eventcomponents[0] + "-" + eventcomponents[1] + "-" + eventcomponents[2]

                if eventstart.contains(stringdate) {
//                    print ("Event Date Match: \(eventname)")
                    sameevents.append(eventid)
                    sameevents.append(eventname)
                    sameevents.append(eventvenue)
                    sameevents.append(eventstart)
                    sameevents.append(eventend)
                    sameevents.append(eventstatus)
                    allsameevents = allsameevents + [sameevents]
                    break
                }
                

            }
            
        }
        
        events = allsameevents
        print ("All Events testing \(events) \(events.count)")

    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        print("Calendar")
        let dateString = self.dateFormatter2.string(from: date)
        if self.dateswithmarker.contains(dateString) {
            return 3
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter2.string(from: date)
        if self.dateswithmarker.contains(key) {
            return [UIColor.black, UIColor.black, UIColor.black]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print (self.events.count)
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        print ("Hopefully one row of events: \(event)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell") as! CalendarCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath)
        
//        cell.setTitle(event: [String])
        
        if !event.isEmpty {
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.eventTitle.text = (event[1] as! String)
            cell.eventVenue.text = (event[2] as! String)
            
            let celleventstart = (event[3] as! String).components(separatedBy: CharacterSet(charactersIn: "-: "))
            let starttime = celleventstart[3] + ":" + celleventstart[4]
            let celleventend = (event[4] as! String).components(separatedBy: CharacterSet(charactersIn: "-: "))
            
            let endtime = celleventend[3] + ":" + celleventend[4]
            
            cell.eventTime.text = "\(starttime) - \(endtime)"
            
        }
        
        
        return cell
    }
        
    @objc func goToViewHelp() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let showViewHelp =
        main.instantiateViewController(withIdentifier: Constants.Storyboard.viewHelp) as! ViewHelpController
        
        present(showViewHelp, animated: true, completion: nil)
    }
    
    func loadData() {
                            
        //creating URLRequest
        let url = URL(string: "https://thomasianjourney.website/Register/insertAllEvents")!

        //setting the method to post
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postData = "collegeId="+collegeid;

        //adding the parameters to request body
        request.httpBody = postData.data(using: String.Encoding.utf8)
          
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
              
            if error != nil{
                print("Connection Error: \(String(describing: error))")
                self.showToast(controller: self, message: "Error, please try again.", seconds: 3)
                return;
              
            }
          
            else {
          
                guard let data = data else { return }
                 
                do {
                      
                    let connection = try JSONDecoder().decode(ViewCalendarData.self, from: data)
                    //print (connection.message)
//                    print (connection)
                    //print (self.events.count)
                    
                    if connection.message.contains("No Response") {
                        self.showToast(controller: self, message: "Code is incorrect.", seconds: 3)
                        //DispatchQueue.main.async {
                            //self.transitionToFirst()
                        //}
                    }

                    if connection.message.contains("Results") {
                        self.dataArray = connection.data
//                        print (self.dataArray)
                        for (_, item) in self.dataArray.enumerated() {

                            for _ in item {

                                self.eventstart = item[3] as! String
                                
                                let eventcomponents = self.eventstart.components(separatedBy: CharacterSet(charactersIn: "-: "))
                                let dateformat = eventcomponents[0] + "-" + eventcomponents[1] + "-" + eventcomponents[2]
                                
                                self.dateswithmarker = self.dateswithmarker + [dateformat]

                            }

                        }
                        
//                        print ("Load Data")
//                        print ("Dates With Marker: \(self.dateswithmarker)")
                    }
                }
                 
                catch {
                    print("This is an error: \(error)")
                    DispatchQueue.main.async {
                        self.showToast(controller: self, message: "Data could not be retrieved.", seconds: 3)
                    }

                }
              
            }
        }

        //executing the task
        task.resume()
                
    }
    
    func transitionToMain() {
        let mainPage =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainPage) as? MainPage
        
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
