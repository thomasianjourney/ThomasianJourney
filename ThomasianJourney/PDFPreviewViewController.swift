//
//  PDFPreviewViewController.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 5/6/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit
import PDFKit

@available(iOS 11.0, *)
class PDFPreviewViewController: UIViewController {
    
    var documentData: Data?
    @IBOutlet weak var pdfView: PDFView!
    
    var studregid = ""
    var activityid = ""
    let imagename = "sticker.png"
    var eventID = ""
    var eventTitle = ""
    var eventVenue = ""
    var eventDate = ""
    var eventTime = ""
    var studentNo = ""
    var studentName = ""
    var collegeName = ""
    var referenceNo = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard
                                
        if preferences.string(forKey: "mainuserid") == nil || preferences.string(forKey: "studName") == nil || preferences.string(forKey: "mainstudentno") == nil || preferences.string(forKey: "collegeID") == nil {
            transitionToMain()
        }
        
        else {
            studregid = preferences.string(forKey: "mainuserid")!
            studentName = preferences.string(forKey: "studName")!
            studentNo = preferences.string(forKey: "mainstudentno")!
            collegeName = preferences.string(forKey: "collegeID")!
            
            switch collegeName {
            case "1":
                collegeName = "Commerce"
            case "2":
                collegeName = "IICS"
            case "3":
                collegeName = "Science"
            case "7":
                collegeName = "Graduate School"
            default:
                collegeName = ""
            }
            
            loadData()
        }
    }
    
    func loadData() {
            
        //creating URLRequest
        let url = URL(string: "https://thomasianjourney.website/Register/eventDetails")!

        //setting the method to post
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postData = "activityId="+activityid+"&accountId="+studregid;

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
                    //print (connection.data)
                    //print (self.events.count)
                    
//                    let image = UIImage(named: self.imagename)
                    
                    if connection.message.contains("No Response") {
                        self.showToastToMain(controller: self, message: "No Activity Found", seconds: 3)
                        //DispatchQueue.main.async {
                            //self.transitionToFirst()
                        //}
                    }
                    
                    if connection.message.contains("Results") {
                        
                        let date = connection.data.eventDate.components(separatedBy: CharacterSet(charactersIn: "-: "))
                        var month = date[1]
                        let day = date[2]
                        let year = date[0]
                        
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
                        
                        let eventstart = connection.data.eventDate.components(separatedBy: CharacterSet(charactersIn: "-: "))

                        let starttime = eventstart[3] + ":" + eventstart[4]

                        let eventend = connection.data.eventendDate.components(separatedBy: CharacterSet(charactersIn: "-: "))

                        let endtime = eventend[3] + ":" + eventend[4]
                        
                        self.eventTitle = connection.data.activityName
                        self.eventID = connection.data.activityId
                        self.eventVenue = connection.data.eventVenue
                        self.eventDate = "\(month) \(day), \(year)"
                        self.eventTime = "\(starttime) - \(endtime)"
                        
                        DispatchQueue.main.async {
                        
                            let pdfCreator = PDFCreator(title: self.eventTitle, image: #imageLiteral(resourceName: "sticker"), eventID: self.eventID, eventTitle: self.eventTitle, eventVenue: self.eventVenue, eventDate: self.eventDate, eventTime: self.eventTime, studentNo: self.studentNo, studentName: self.studentName, studentCollege: self.collegeName, referenceNo: self.referenceNo)
                            self.documentData = pdfCreator.createFlyer()
                            
                            if let data = self.documentData {
                                self.pdfView.document = PDFDocument(data: data)
                                self.pdfView.autoScales = true
                            
                            }
    
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
    
    func transitionToMain() {
        
        let mainPage =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainPage) as? MainPage
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
        
    }
    
    func showToastToMain(controller: UIViewController, message : String, seconds: Double) {
        
        DispatchQueue.main.async {
        
             let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
             alert.view.backgroundColor = .black
             alert.view.alpha = 0.5
             alert.view.layer.cornerRadius = 15
             controller.present(alert, animated: true)
                     
             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                 alert.dismiss(animated: true)
                 self.transitionToMain()
             }
         }
    
    }
    
    @IBAction func downloadSticker(_ sender: Any) {
        
        let pdfCreator = PDFCreator(title: eventTitle, image: #imageLiteral(resourceName: "sticker"), eventID: self.eventID, eventTitle: self.eventTitle, eventVenue: self.eventVenue, eventDate: self.eventDate, eventTime: self.eventTime, studentNo: self.studentNo, studentName: self.studentName, studentCollege: self.collegeName, referenceNo: self.referenceNo)
        let pdfData = pdfCreator.createFlyer()
        let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    
    }

}
