//
//  EventDetails.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 3/25/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

struct EventData: Decodable {
    let status: String
    let message: String
    let data: EventDetailsData
}

struct EventDetailsData: Decodable {
    let activityId: String
    let activityName: String
    let eventVenue: String
    let eventDate: String
    let description: String
    let eventendDate: String
    let points: String
    let attend: String
}

class EventDetails: UIViewController {
    
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventDescription: UILabel!
    @IBOutlet var eventVenue: UILabel!
    @IBOutlet var eventTime: UILabel!
    @IBOutlet var eventPoints: UILabel!
    
    var eventid = ""
    var eventdatetime = ""
    var endeventdate = ""
    var activityid = ""
    var studregid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let preferences = UserDefaults.standard
                                
        if preferences.string(forKey: "mainuserid") == nil {
            transitionToMain()
        }
        
        else {
            studregid = preferences.string(forKey: "mainuserid")!
            loadData()
            
        }
    }
    
    @IBAction func attendEvent(_ sender: Any) {
        let dateNow = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let eventstart = formatter.date(from: eventdatetime)!
        let eventend = formatter.date(from: endeventdate)!
        
        if dateNow < eventstart {
            
            showToast(controller: self, message: "Event not yet available.", seconds: 3)
            
        }
        
        else if dateNow > eventend {
            
            // Insert Print Sticker Code Here
            showToast(controller: self, message: "Event no longer available.", seconds: 3)
            
        }
        
        else {

            let GPSController =
            storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.GPSController) as? GPSController
            GPSController?.activityid = self.activityid
            view.window?.rootViewController = GPSController
            view.window?.makeKeyAndVisible()
            
        }
    }
    
    func loadData() {
        
        //creating URLRequest
        let url = URL(string: "https://thomasianjourney.website/Register/eventDetails")!

        //setting the method to post
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postData = "activityId="+eventid+"&accountId="+studregid;

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
                      
                    let connection = try JSONDecoder().decode(EventData.self, from: data)
                    //print (connection.message)
                    print (connection.data)
                    //print (self.events.count)
                    
                    if connection.message.contains("No Response") {
                        self.showToastMainActivity(controller: self, message: "No Activity Found", seconds: 3)
                    }
                    
                    if connection.message.contains("Results") {
                        
                        let date = connection.data.eventDate.components(separatedBy: CharacterSet(charactersIn: "-: "))
                        var month = date[1]
                        let day = date[2]
                        
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
                        
                        self.eventdatetime = connection.data.eventDate
                        self.endeventdate = connection.data.eventendDate
                        self.activityid = connection.data.activityId
                        
                        let eventstart = connection.data.eventDate.components(separatedBy: CharacterSet(charactersIn: "-: "))
                        
                        let starttime = eventstart[3] + ":" + eventstart[4]
                        
                        let eventend = connection.data.eventendDate.components(separatedBy: CharacterSet(charactersIn: "-: "))
                        
                        let endtime = eventend[3] + ":" + eventend[4]
                        
                        DispatchQueue.main.async {
                            self.eventDate.text = "\(month)\n\(day)"
                            self.eventTitle.text = connection.data.activityName
                            self.eventDescription.text = connection.data.description
                            self.eventVenue.text = connection.data.eventVenue
                            self.eventPoints.text = connection.data.points
                            self.eventTime.text = "\(starttime) - \(endtime)"
                        }
                    }
                }
                 
                catch {
                    print(error)
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
    
    func transitionToMainActivity() {
        
        let mainActivity =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainActivity) as? MainActivity
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainActivity
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func showToastMainActivity (controller: UIViewController, message : String, seconds: Double) {
        
        DispatchQueue.main.async {
       
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            controller.present(alert, animated: true)

            self.transitionToMainActivity()
                    
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
            }
        }
    }
}
