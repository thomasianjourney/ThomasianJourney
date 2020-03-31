//
//  MainPage.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit

//for the rounded views

@IBDesignable
class RoundedViews: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            DispatchQueue.main.async {
                self.layer.cornerRadius = self.cornerRadius
            }
        }
    }
}

@IBDesignable
class RoundButtons: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            DispatchQueue.main.async {
                self.layer.cornerRadius = self.cornerRadius
            }
        }
    }
}
/*
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }*/



struct MainData: Decodable {
    let status: String
    let message: String
    let data: StudentData
}

struct StudentData: Decodable {
    let studentsId: String
    let studregEmail: String
    let studregmobileNum: String
    let studregName: String
    let studNumber: String
    let studPoints: String
    let yearlevelId: String
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

class MainPage: UIViewController {

    @IBOutlet var gifView: UIImageView!
    
    @IBOutlet var studNo: UILabel!
    
    @IBOutlet var points: UILabel!
    
    @IBOutlet var currentDate: UILabel!
    
    @IBOutlet var welcome: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard
        
        //print ("Check Empty Email and Number: \(preferences.string(forKey: "useremail")) \(preferences.string(forKey: "usernumber"))")
        
        if preferences.string(forKey: "mainuseremail") == nil && preferences.string(forKey: "mainusernumber") == nil && preferences.string(forKey: "mainuserid") == nil {
            transitionToFirst()
        }
        
        else {
            let studregid = preferences.string(forKey: "mainuserid")
            
            //creating URLRequest
            let url = URL(string: "https://thomasianjourney.website/register/studentdetails")!

            //setting the method to post
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postData = "studentsId="+studregid!;

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
                          
                        let connection = try JSONDecoder().decode(MainData.self, from: data)
                        //print (connection)
                        
                          
                        if connection.message.contains("not found") {
                            self.showToast(controller: self, message: "Code is incorrect.", seconds: 3)
                            //DispatchQueue.main.async {
                                //self.transitionToFirst()
                            //}
                        }
                        
                        if connection.message.contains("login successful.") {
                            
                            let currentdate = Date()
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd MMMM yyyy"
                            
                            let datestring = formatter.string(from: currentdate)

                            DispatchQueue.main.async {
                                self.welcome.text = "Welcome, \(connection.data.studregName)!"
                                self.studNo.text = "\(connection.data.studNumber)"
                                self.points.text = "\(connection.data.studPoints)"
                                self.currentDate.text = "\(Date().dayOfWeek() ?? ""), \(datestring)"
                            }
                        }
                    }
                     
                    catch {
                        //print(error)
                        self.showToast(controller: self, message: "Code is incorrect.", seconds: 3)
                    }
                  
                }
            }

            //executing the task
            task.resume()
        }
        
        gifView.loadGif(name: "tjmov")
    }
    
    @IBAction func viewCalendarTapped(_ sender: UIButton) {
        let viewCalendar =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.viewCalendar) as? ViewCalendar
        
        view.window?.rootViewController = viewCalendar
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToFirst() {
        
        let registerFirst =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.registerFirst) as? RegisterFirst
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = registerFirst
        appDelegate.window?.makeKeyAndVisible()
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
