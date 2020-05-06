//
//  ScanSuccess.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
import Lottie

struct StickerData: Decodable {
    let status: String
    let message: String
    let data: StickerDetailsData
}

struct StickerDetailsData: Decodable {
    let attendId: String
    let studattendId: String
    let eventId: String
    let yearLevel: String
    let printSticker: String
}

class ScanSuccess: UIViewController {

    @IBOutlet var animationView: AnimationView!
    var activityid = ""
    var studregid = ""
    var continueSegue = false
    
    func playAnimation(){
        animationView.animation = Animation.named("qr")
        animationView.play()
    }
    
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

    @IBAction func backToHome(_ sender: Any) {
        
        let mainPage =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainPage) as? MainPage
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
        
    }
    
    func loadData() {
                
        //creating URLRequest
        let url = URL(string: "https://thomasianjourney.website/Register/printSticker")!

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
                      
                    let connection = try JSONDecoder().decode(StickerData.self, from: data)
                    //print (connection.message)
                    print (connection)
                    //print (self.events.count)
                    
    //                    let image = UIImage(named: self.imagename)
                    
                    if connection.message.contains("No Response") {
                        self.showToastToMain(controller: self, message: "No Activity Found", seconds: 3)
                        //DispatchQueue.main.async {
                            //self.transitionToFirst()
                        //}
                    }
                    
                    if connection.message.contains("Success") {
                        
//                        let date = connection.data.eventDate.components(separatedBy: CharacterSet(charactersIn: "-: "))
//                        var month = date[1]
//                        let day = date[2]
//                        let year = date[0]
//                        
//                        switch month {
//                        case "01":
//                            month = "Jan"
//                        case "02":
//                            month = "Feb"
//                            break;
//                        case "03":
//                            month = "Mar"
//                        case "04":
//                            month = "April"
//                        case "05":
//                            month = "May"
//                        case "06":
//                            month = "Jun"
//                        case "07":
//                            month = "Jul"
//                        case "08":
//                            month = "Aug"
//                        case "09":
//                            month = "Sep"
//                        case "10":
//                            month = "Oct"
//                        case "11":
//                            month = "Nov"
//                        case "12":
//                            month = "Dec"
//                        default:
//                            month = ""
//                        }
//                        
//                        let eventstart = connection.data.eventDate.components(separatedBy: CharacterSet(charactersIn: "-: "))
//
//                        let starttime = eventstart[3] + ":" + eventstart[4]
//
//                        let eventend = connection.data.eventendDate.components(separatedBy: CharacterSet(charactersIn: "-: "))
//
//                        let endtime = eventend[3] + ":" + eventend[4]
//                        
//                        self.eventTitle = connection.data.activityName
//                        self.eventID = connection.data.activityId
//                        self.eventVenue = connection.data.eventVenue
//                        self.eventDate = "\(month) \(day), \(year)"
//                        self.eventTime = "\(starttime) - \(endtime)"
//                        self.referenceNo = ""
//                        
//                        DispatchQueue.main.async {
//                        
//                            let pdfCreator = PDFCreator(title: self.eventTitle, image: UIImage(named: self.imagename)!, eventID: self.eventID, eventTitle: self.eventTitle, eventVenue: self.eventVenue, eventDate: self.eventDate, eventTime: self.eventTime, studentNo: self.studentNo, studentName: self.studentName, referenceNo: self.referenceNo)
//                            self.documentData = pdfCreator.createFlyer()
//                            
//                            if let data = self.documentData {
//                                self.pdfView.document = PDFDocument(data: data)
//                                self.pdfView.autoScales = true
//                            
//                            }
//
//                        }
                        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToPreview" {
            if #available(iOS 11.0, *) {
                if let PDFPreviewViewController = segue.destination as? PDFPreviewViewController {
                    PDFPreviewViewController.activityid = self.activityid
                }
            }
            
            else {
            
                showToast(controller: self, message: "This feature is only available on iOS 11 and above.", seconds: 3)
                
            }
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "ToPreview" {
         
            if continueSegue == true {
                return true
            }
            
            else {
                showToast(controller: self, message: "You have already downloaded the sticker for this event.", seconds: 3)
                return false
            }
            
        }
        
        return true
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

}
