//
//  GPSController.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/4/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit
import CoreLocation

class GPSController: UIViewController {
    
    var locManager = CLLocationManager()
    let defaultcoordinates =  CLLocation(latitude: 14.609882, longitude: 120.989498)
    //let ScopeRadiusMeters = 336
    //let ScopeRadiusMeters = 353

    var activityid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentLocation: CLLocation!
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            
            currentLocation = self.locManager.location
            
            //print ("The current longitutde is: \(currentLocation.coordinate.longitude)")
            //print ("The current latitude is: \(currentLocation.coordinate.latitude)")
            
            let currentcoordinates = CLLocation(latitude: currentLocation.coordinate.latitude,
                                                longitude: currentLocation.coordinate.longitude)
            
            let distanceInMeters = defaultcoordinates.distance(from: currentcoordinates) // result is in meters
            //print ("Current Distance is: \(distanceInMeters)")
            
            if distanceInMeters <= 353 {
                //print ("Proceed to Scan")
                self.showToastVerify(controller: self, message: "GPS Searching", seconds: 3)
            }
            
            else {
                //print ("Location not in UST")
                
                showToastError(controller: self, message: "GPS Searching", seconds: 3)
            }
            
        }
            
        else if CLLocationManager.authorizationStatus() == .notDetermined {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            
                if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways {
                 
                    currentLocation = self.locManager.location
                 
                    //print ("The current longitutde is: \(currentLocation.coordinate.longitude)")
                    //print ("The current latitude is: \(currentLocation.coordinate.latitude)")
                 
                    let currentcoordinates = CLLocation(latitude: currentLocation.coordinate.latitude,
                     longitude: currentLocation.coordinate.longitude)
                 
                    let distanceInMeters = self.defaultcoordinates.distance(from: currentcoordinates) // result is in meters
                    //print ("Current Distance is: \(distanceInMeters)")
                 
                    if distanceInMeters <= 353 {
                        
                        //print ("Proceed to Scan")
                        self.showToastVerify(controller: self, message: "GPS Searching", seconds: 3)
                    }
                        
                    else {
                        //print ("Location not in UST")
                        
                        self.showToastError(controller: self, message: "GPS Searching", seconds: 3)
                    }
                    
                }
                
                else {
                    
                    //print ("Location Services Denied.")
                 
                    self.showToastErrorLocation(controller: self, message: "GPS Searching", seconds: 3)
                            
                }
            
            }
            
        }
        
        else {
            
            print ("Location Services Denied.")
         
            self.showToastErrorLocation(controller: self, message: "GPS Searching", seconds: 3)
                    
        }
    
    }
        
    func transitionToVerify() {
                
        let VerifyLoginCred =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.VerifyLoginCred) as? VerifyLoginCred
        VerifyLoginCred?.activityid = self.activityid
//        view.window?.rootViewController = VerifyLoginCred
//        view.window?.makeKeyAndVisible()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = VerifyLoginCred
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func transitionToCurrent() {
        
        let GPSController =
               storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.GPSController) as? GPSController
               GPSController?.activityid = self.activityid
               view.window?.rootViewController = GPSController
               view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToEvents() {
        
        let mainPage =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainPage) as? MainPage
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
        
    }
    
    func showToastVerify (controller: UIViewController, message : String, seconds: Double) {
        
        DispatchQueue.main.async {
       
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            controller.present(alert, animated: true)
                    
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
                self.transitionToVerify()
            }
        }
    }
    
    func showToastError (controller: UIViewController, message : String, seconds: Double) {
        
        DispatchQueue.main.async {
       
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            controller.present(alert, animated: true)
                    
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
                
                
                let erroralert = UIAlertController(title: "Error Location", message: "Please scan within the location of the event only.", preferredStyle: .alert)

                erroralert.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: { (action) in

                    self.transitionToCurrent()

                }))
                
                controller.present(erroralert, animated: true)
            }
        }
    }
    
    func showToastErrorLocation (controller: UIViewController, message : String, seconds: Double) {
        
        DispatchQueue.main.async {
       
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            controller.present(alert, animated: true)
                    
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
                
                
                let erroralert = UIAlertController(title: nil, message: "Cannot find location", preferredStyle: .alert)
                erroralert.view.backgroundColor = .black
                erroralert.view.alpha = 0.5
                erroralert.view.layer.cornerRadius = 15
                controller.present(erroralert, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                    
                    self.transitionToEvents()
                    
                }
                
            }
        }
    }
        
    @IBAction func refreshPage (_ sender: Any) {
        
        transitionToCurrent()
        
    }
    
}
