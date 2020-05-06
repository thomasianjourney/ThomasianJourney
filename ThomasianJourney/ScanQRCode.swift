//
//  ScanQRCode.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 4/26/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit
import AVFoundation

struct QRPageData: Decodable {
    let status: String
    let message: String
    let data: QRPageStudentData
}

struct QRPageStudentData: Decodable {
    let studattendId: String
    let eventId: String
    let yearLevel: String
}

class ScanQRCode: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var QRBox: UIImageView!
    
    var activityid = ""
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        
        }
        
        catch {
        
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            
            captureSession.addInput(videoInput)
        
        }
        
        else {
           
            failed()
            return
        
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            
        }
        
        else {
            
            failed()
            return
        
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        self.view.bringSubviewToFront(QRBox)

        captureSession.startRunning()
    }

    func failed() {
        
        showToast(controller: self, message: "You cancelled the scanning.", seconds: 3)
        captureSession = nil
    
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            
            captureSession.startRunning()
        
        }
    
    }

    override func viewWillDisappear(_ animated: Bool) {
    
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            
            captureSession.stopRunning()
            
        }
    
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    
    }

    func found(code: String) {
        
        //print(code)
        let codestring = code.components(separatedBy: ";")
        
        if codestring[0] == activityid {
            
//            print ("Code is correct.")
            
            let preferences = UserDefaults.standard

            if preferences.string(forKey: "mainuserid") == nil || preferences.string(forKey: "yearID") == nil {

                showToastToMain(controller: self, message: "No data", seconds: 3)

            }

            else {
                
                let studregid = preferences.string(forKey: "mainuserid")
                let yearlevel = preferences.string(forKey: "yearID")

                //creating URLRequest
                let url = URL(string: "https://thomasianjourney.website/register/insertAttended")!

                //setting the method to post
                var request = URLRequest(url: url)
                request.httpMethod = "POST"

                //creating the post parameter by concatenating the keys and values from text field
                let postData = "accountId="+studregid!+"&activityId="+activityid+"&yearLevel="+yearlevel!;

                //adding the parameters to request body
                request.httpBody = postData.data(using: String.Encoding.utf8)

                //creating a task to send the post request
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in

                    if error != nil{
                        //print("Connection Error: \(String(describing: error))")
                        self.showToastToMain(controller: self, message: "Connection Error, please try again.", seconds: 3)
                        return;

                    }

                    else {
                        //print ("Checking inside task")
                        guard let data = data else { return }
                        
                        DispatchQueue.main.async {

                            do {

                                let connection = try JSONDecoder().decode(QRPageData.self, from: data)
                                print (connection)
                                //print("Testing from Connection Itself: \(connection)")

                                if connection.message.contains("not found") {
    
                                    //DispatchQueue.main.async {
                                        self.showToastToMain(controller: self, message: "Cannot find Student Details", seconds: 3)
                                    //}
    
                                }
    
                                if connection.message.contains("inserted") {
    
                                    //print ("Testing inside the if's")
    
                                    //DispatchQueue.main.async {
    
                                        self.transitionToScanSuccess()
    
                                    //}
    
                                }
                            }
                                

                            catch {
                                
                                print("Catch Error \(error)")
                                self.showToast(controller: self, message: "Cannot find Student Details", seconds: 3)
                            }
                            
                        }
//
                    }
                }
//
                //executing the task
                task.resume()
//
            }
            
        }
        
        else {
            
            //print ("Wrong QR Code")
            
            //captureSession = nil
            
            let erroralert = UIAlertController(title: "Error QR Code", message: "Please scan the right QR code for the event.", preferredStyle: .alert)
            
            //erroralert.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: nil))

            erroralert.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: { (action) in

                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    self.transitionToScan()
                }

            }))
            
            present (erroralert, animated: true)
            
        }
    }

    override var prefersStatusBarHidden: Bool {
        
        return true
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    
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
    
    func transitionToScan() {
        
        let ScanQRCode =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ScanQRCode) as? ScanQRCode
        ScanQRCode?.activityid = self.activityid
        view.window?.rootViewController = ScanQRCode
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToScanSuccess() {
         
        let ScanSuccess =
        storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ScanSuccess) as? ScanSuccess
        ScanSuccess?.activityid = self.activityid
        view.window?.rootViewController = ScanSuccess
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
