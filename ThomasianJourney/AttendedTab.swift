//
//  AttendedTab.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 3/23/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

struct AttendedEventData: Decodable {
    let status: String
    let message: String
    let data: [AttendedEventDetails]
}

struct AttendedEventDetails: Decodable {
    let activityId: String
    let activityName: String
    let eventVenue: String
    let eventDate: String
}

class AttendedTab: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var events: [AttendedEventDetails] = []
    var activityId = ""
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tabBarItem1: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarItem1 = UITabBarItem(title: "ATTENDED", image: nil, selectedImage: nil)
        //tabBarItem1.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Poppins", size: 20) ?? ""], for: .normal)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendedCell") as! AttendedCell
        
        cell.setTitle(event: event)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        //print (event.activityName)
        
        activityId = event.activityId
        
        performSegue(withIdentifier: "AttendedEventDetails", sender: nil)
    
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
            let url = URL(string: "https://thomasianjourney.website/Register/insertAttendedEvents")!

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
                          
                        let connection = try JSONDecoder().decode(AttendedEventData.self, from: data)
                        //print (connection.message)
                        //print (connection.data.count)
                        //print (self.events.count)
                        
                        if connection.message.contains("No Response") {
//                            self.showToast(controller: self, message: "Code is incorrect.", seconds: 3)
                        }
                        
                        if connection.message.contains("Results") {
                            self.events = connection.data
                            DispatchQueue.main.async {
                                
                                self.tableView.reloadData()
                                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        let AttendedEvent = segue.destination as? AttendedEvent
        AttendedEvent?.eventid = activityId
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        if identifier == "AttendedEventDetails" {
                
            return false
                
        }
            
        return true

    }
}

