//
//  MainPageViewController.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 12/3/19.
//  Copyright © 2019 Capstone Project. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jeremyGif = UIImage.gifImageWithName("tjmov")
        let gifImage = UIImageView(image: jeremyGif)
        gifImage.frame = CGRect(x: 0.0, y: 20.0, width: self.view.frame.size.width, height: 250)
        view.addSubview(gifImage)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
