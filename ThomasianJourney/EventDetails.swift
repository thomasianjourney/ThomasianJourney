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
    
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventDescription: UILabel!
    @IBOutlet var eventVenue: UILabel!
    @IBOutlet var eventTime: UILabel!
    @IBOutlet var eventPoints: UILabel!
    
    var eventid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard
                                
            if preferences.string(forKey: "mainuserid") == nil {
                transitionToMain()
            }
            
            else {
                let studregid = preferences.string(forKey: "mainuserid")
                
                //creating URLRequest
                let url = URL(string: "https://thomasianjourney.website/Register/eventDetails")!

                //setting the method to post
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                //creating the post parameter by concatenating the keys and values from text field
                let postData = "activityId="+eventid+"&accountId="+studregid!;

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
                            //print (connection)
                            //print (self.events.count)
                            
                            if connection.message.contains("No Response") {
    //                            self.showToast(controller: self, message: "Code is incorrect.", seconds: 3)
                                //DispatchQueue.main.async {
                                    //self.transitionToFirst()
                                //}
                            }
                            
                            if connection.message.contains("Results") {
                                DispatchQueue.main.async {
                                    self.eventTitle.text = connection.data.activityName
                                    self.eventDescription.text = connection.data.description
                                    self.eventVenue.text = connection.data.eventVenue
                                    self.eventPoints.text = connection.data.points
                                }
                            }
                        }
                         
                        catch {
                            print(error)
    //                        self.showToast(controller: self, message: "Code is incorrect.", seconds: 3)
                        }
                      
                    }
                }

                //executing the task
                task.resume()
            }
    }
    
    @IBAction func attendEvent(_ sender: Any) {
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
