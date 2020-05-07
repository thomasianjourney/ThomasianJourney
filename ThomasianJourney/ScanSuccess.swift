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
    let referenceNo: String
}

class ScanSuccess: UIViewController {

    @IBOutlet var animationView: AnimationView!
    var activityid = ""
    var studregid = ""
    var referenceNo = ""
    
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
//        let postData = "activityId="+activityid+"&accountId="+studregid;
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
                    
                    if connection.message.contains("Sticker Not Generated") {
                        
                        DispatchQueue.main.async {
                            
                            self.referenceNo = connection.data.referenceNo
                            self.performSegue(withIdentifier: "ToPreview", sender: nil)
                            
                        }
                        
                    }
                    
                    else {
                        
                        DispatchQueue.main.async {

                            self.showToast(controller: self, message: "You have already downloaded the sticker for this event.", seconds: 3)
                            
                        }
                        
                    }
                }
                 
                catch {
                    print(error)
                    self.showToast(controller: self, message: "Data could not be retrieved.", seconds: 3)
                }
              
            }
        }

        //executing the task
        task.resume()
                
    }
    
    @IBAction func printSticker(_ sender: Any) {
        
        loadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToPreview" {
            
            if #available(iOS 11.0, *) {
                if let PDFPreviewViewController = segue.destination as? PDFPreviewViewController {
                    PDFPreviewViewController.activityid = self.activityid
                    PDFPreviewViewController.referenceNo = self.referenceNo
                }
            }
            
            else {
            
                showToast(controller: self, message: "This feature is only available on iOS 11 and above.", seconds: 3)
                
            }
            
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "ToPreview" {
            
            return false
            
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
