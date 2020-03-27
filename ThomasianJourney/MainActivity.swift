//
//  MainActivity.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 3/19/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

struct AllEventData: Decodable {
    let status: String
    let message: String
    let data: [AllEventDetails]
}

struct AllEventDetails: Decodable {
    let activityId: String
    let activityName: String
    let eventVenue: String
    let eventDate: String
    let status: String
}

class MainActivity: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var events: [AllEventDetails] = []
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.tabBarItem = UITabBarItem(title: "EVENTS", image: nil, selectedImage: nil)
        
        loadEventsData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadEventsData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print (self.events.count)
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        
        cell.setTitle(event: event)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        print (event.activityName)
        let EventDetails =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.EventDetails) as? EventDetails
        EventDetails?.nameofevent = event.activityName
        view.window?.rootViewController = EventDetails
        view.window?.makeKeyAndVisible()
    }
    
    func loadEventsData() {
        let preferences = UserDefaults.standard
                        
        if preferences.string(forKey: "mainuserid") == nil && preferences.string(forKey: "yearID") == nil && preferences.string(forKey: "collegeID") == nil {
            transitionToMain()
        }
        
        else {
            let studregid = preferences.string(forKey: "mainuserid")
            let yearid = preferences.string(forKey: "yearID")
            let collegeid = preferences.string(forKey: "collegeID")
            
            //creating URLRequest
            let url = URL(string: "https://thomasianjourney.website/Register/insertEvents")!

            //setting the method to post
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postData = "collegeId="+collegeid!+"&yearLevel="+yearid!+"&accountId="+studregid!;

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
                          
                        let connection = try JSONDecoder().decode(AllEventData.self, from: data)
                        //print (connection)
                        //print (connection.data.count)
                        self.events = connection.data
                        //print (self.events.count)
                        
                        if connection.message.contains("not found") {
//                            self.showToast(controller: self, message: "Code is incorrect.", seconds: 3)
                            //DispatchQueue.main.async {
                                //self.transitionToFirst()
                            //}
                        }
                        
                        if connection.message.contains("login successful.") {
                            
//                            let currentdate = Date()
//
//                            let formatter = DateFormatter()
//                            formatter.dateFormat = "dd MMMM yyyy"
//
//                            let datestring = formatter.string(from: currentdate)

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
            tableView.reloadData()
        }
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

