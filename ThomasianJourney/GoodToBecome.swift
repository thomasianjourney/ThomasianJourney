//
//  GoodToBecome.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 5/1/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

struct GoodToBecomeData: Decodable {
    let status: String
    let message: String
    let data: [GoodToBecomeDetails]
}

struct GoodToBecomeDetails: Decodable {
    let activityId: String
    let activityName: String
    let eventVenue: String
    let eventDate: String
}

class GoodToBecome: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var events: [GoodToBecomeDetails] = []
    var emptytab1: [String] = []
    var emptytab2: [String] = []
    var emptytab3: [String] = []
    var emptytab4: [String] = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tabBarItem1: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print ("First Year Data: \(emptytab1)")
        //self.tabBarItem1 = UITabBarItem(title: "MUST-DO", image: nil, selectedImage: nil)
        //tabBarItem1.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Poppins", size: 20) ?? ""], for: .normal)
        loadEventsData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadEventsData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print (self.events.count)
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodToBecomeCell") as! GoodToBecomeCell
        
        cell.setTitle(event: event)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
        
    func loadEventsData() {
        let preferences = UserDefaults.standard
        var tabs: [String] = []
                        
        if preferences.string(forKey: "mainuserid") == nil && preferences.string(forKey: "yearID") == nil {
            
            transitionToMain()
            
        }
        
        else {
            
            let studregid = preferences.string(forKey: "mainuserid")
            let yearid = preferences.string(forKey: "yearID")
            let eventclass = "4"
            
            if yearid == "1" {
                
                tabs = emptytab1
                
            }
            
            else if yearid == "2" {
                
                tabs = emptytab2
                
            }
            
            else if yearid == "3" {
                
                tabs = emptytab3
                
            }
            
            else if yearid == "4" {
                
                tabs = emptytab4
                
            }
            
            if tabs[3] == "false" {
                
                //creating URLRequest
                let url = URL(string: "https://thomasianjourney.website/Register/portfolioInfo")!

                //setting the method to post
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                //creating the post parameter by concatenating the keys and values from text field
                let postData = "accountId="+studregid!+"&eventClass="+eventclass+"&yearLevel="+yearid!;

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
                              
                            let connection = try JSONDecoder().decode(GoodToBecomeData.self, from: data)
                            //print (connection)
                            //print (connection.data.count)
                            //print (self.events.count)
                            
    //                        if connection.message.contains("No Response") {
    ////                            self.showToast(controller: self, message: "Code is incorrect.", seconds: 3)
    ////                            DispatchQueue.main.async {
    ////                                self.transitionToFirst()
    ////                            }
    //                        }

                            if connection.message.contains("Results1") {
                                self.events = connection.data
                                DispatchQueue.main.async {

                                    self.tableView.reloadData()

                                }
                            }
                        }
                         
                        catch {
                            print("This is an error: \(error)")
                            self.showToast(controller: self, message: "No events found.", seconds: 3)
                        }
                      
                    }
                    
                }

                //executing the task
                task.resume()
                
            }
            
            else {
                
                showToast(controller: self, message: "No events found.", seconds: 3)
                
            }
            
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
