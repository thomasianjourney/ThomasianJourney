//
//  MenuPortfolio.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit

struct MenuPortfolioData: Decodable {
    let status: String
    let message: String
    let data: [[Bool]]
}

class MenuPortfolio: UIViewController {
    
    var yearlevel = ""
    var studregid = ""
    var year1 = ["true","true","true","true"]
    var year2 = ["true","true","true","true"]
    var year3 = ["true","true","true","true"]
    var year4 = ["true","true","true","true"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard

        if preferences.string(forKey: "yearID") == nil || preferences.string(forKey: "mainuserid") == nil {

            showToastToMain(controller: self, message: "No data", seconds: 3)
            
        }

        else {
            
            yearlevel = preferences.string(forKey: "yearID")!
            studregid = preferences.string(forKey: "mainuserid")!
            
            loadData()
        
        }
        
    }
    
    func loadData() {
        
        //creating URLRequest
        let url = URL(string: "https://thomasianjourney.website/Register/checkPortfolio")!

        //setting the method to post
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postData = "accountId="+studregid;

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
                      
                    let connection = try JSONDecoder().decode(MenuPortfolioData.self, from: data)
                    let dataArray = connection.data
                    //print (connection.data)
                    //print (connection.data.count)
                    //print (self.events.count)
                    
                    
                    if connection.message.contains("No Response") {
                        self.showToast(controller: self, message: "Code is incorrect.", seconds: 3)
                        //DispatchQueue.main.async {
                            //self.transitionToFirst()
                        //}
                    }

                    if connection.message.contains("Results") {
                       
                        for (index, item) in dataArray.enumerated() {
                            
                            //var temp = Array(repeating: "true", count: 4)
                            var temp: [String] = []
                            for dataitem in item {
                                
                                temp = temp + [dataitem.description]
                                //print("index : \(index) item: \(dataitem)")
                            }
                            
                            //print (temp)
                            
                            if (index == 0) {
                                self.year1 = temp;
                            }
                            
                            else if (index == 1) {
                                self.year2 = temp;
                            }
                            
                            else if (index == 2) {
                                self.year3 = temp;
                            
                            }
                            
                            else if (index == 3) {
                                self.year4 = temp;
                            }
                            
                        }
                        
                        //print ("Year 1: \(self.year1)\nYear 2: \(self.year2)\nYear 3: \(self.year3)\nYear 4: \(self.year4)")
                        
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
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ToFirstYear" {
                        
            // get a reference to the second view controller
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            let MustDo = tabCtrl.viewControllers![0] as! MustDo
            
            // set a variable in the second view controller with the String to pass
            MustDo.emptytab1 =  year1
            
        }
        
        
        if segue.identifier == "ToSecondYear" {
                        
            // get a reference to the second view controller
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            let MustDo = tabCtrl.viewControllers![0] as! MustDo
            
            // set a variable in the second view controller with the String to pass
            MustDo.emptytab2 =  year2
            
        }
        
        if segue.identifier == "ToThirdYear" {
                        
            // get a reference to the second view controller
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            let MustDo = tabCtrl.viewControllers![0] as! MustDo
            
            // set a variable in the second view controller with the String to pass
            MustDo.emptytab3 =  year3
            
        }
        
        if segue.identifier == "ToFourthYear" {
                        
            // get a reference to the second view controller
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            let MustDo = tabCtrl.viewControllers![0] as! MustDo
            
            // set a variable in the second view controller with the String to pass
            MustDo.emptytab4 =  year4
            
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        if identifier == "ToFirstYear" {

            if Int(yearlevel)! >= 1 {

                //performSegue(withIdentifier: "ToSecondYear", sender: nil)
                return true

            }

            else {

                showToast(controller: self, message: "Not Yet Available", seconds: 3)
                return false

            }
        }

        else if identifier == "ToSecondYear" {

            if Int(yearlevel)! >= 2 {

                return true

            }

            else {

                showToast(controller: self, message: "Not Yet Available", seconds: 3)
                return false

            }

        }

        else if identifier == "ToThirdYear" {

            if Int(yearlevel)! >= 3 {

                return true

            }

            else {

                showToast(controller: self, message: "Not Yet Available", seconds: 3)

            }

        }

        else if identifier == "ToFourthYear" {

            if Int(yearlevel)! >= 4 {

                return true

            }

            else {

                showToast(controller: self, message: "Not Yet Available", seconds: 3)
                return false

            }

        }

        else {

            return false

        }

        return false

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
