//
//  ViewHelpController.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 5/2/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class ViewHelpController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func closeViewHelp(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    var tableViewData = [cellData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewData = [cellData(opened: false, title: "Registration of Account", sectionData: ["In registering for your account, you must enter your ust.edu.ph email account and mobile number (login credentials). After entering your login credentials, press the Register button.\nYou will then be redirected on the verification page, where you must enter the verification sent to you in your ust.edu.ph email account then, press the Verify button.\nIf you haven’t received your verification code in your email, press the “Didn’t get an email?” link to have another verification code. \n After successfully verifying your account, press Continue."]),
        cellData(opened: false, title: "Viewing the Events", sectionData: ["In the home page, press the View Events button.\nThe view events page consists of (3) three tabs namely, Events, Upcoming, and Attended.\ni. For the events tab, it will show you both the upcoming and attended events.\nii. For the upcoming tab, it will show you only the upcoming events that you may participate in to.\niii. For the attended tab, it will show you the past events that you’ve attended so far.\nIn viewing the event details, press the specific event you want to know more.\nIt will show you the title of the event, date and time, venue, description of the event and the point you will receive."]),
        cellData(opened: false, title: "Viewing the Portfolio", sectionData: ["In the home page, press the View Portfolio button.\nYou will be redirected to the View Portfolio page where you can see the events you’ve attended, sorted by your year level."]),
        cellData(opened: false, title: "Scanning the QR Code", sectionData: ["Press the View Events button in the home page.\nPress the event you wanted to attend to.\nIn the event details page, press the Attend Event button.\nWait for your login credentials to be verified.\nOnce verified, you can already scan the QR code.\nPoint your smartphone’s camera directly to the QR code and press the Scan QR code button.\nIf your scanned QR is unsuccessful, try to scan it again.\nAfter successfully scanning, you can press the Go Back to Home button or View Attended Events button.\n"]),
        cellData(opened: false, title: "Viewing the Help", sectionData: ["In case you need help or guide for this application, just press the question mark logo on the upper right of the page."]),
        cellData(opened: false, title: "Changing the loging credentials", sectionData: ["To change or reset the login credentials, kindly inform your Department Chair’s to be able to change it."])]
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
            cell.textLabel?.text = tableViewData[indexPath.section].title
             
            return cell
        } else {
            guard let content = tableView.dequeueReusableCell(withIdentifier: "content") else { return UITableViewCell() }
            content.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex ]
            return content
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        } else {
            
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
