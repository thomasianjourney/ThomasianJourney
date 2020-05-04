//
//  OnboardsViewController.swift
//  ThomasianJourney
//
//  Created by Josh De Castro on 5/4/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit

class OnboardsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet var pageControl: UIPageControl!
    
    var slides:[Onboards] = [];
        
        func setupSlideScrollView(slides : [Onboards]) {
            scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
            scrollView.isPagingEnabled = true
            
            for i in 0 ..< slides.count {
                slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
                scrollView.addSubview(slides[i])
            }
        }
            
        func createOnboards() -> [Onboards] {
            let onboard1:Onboards = Bundle.main.loadNibNamed("Onboards", owner: self, options: nil)?.first as! Onboards
            onboard1.imageView.image = UIImage(named: "ob")
            onboard1.lblHeading.text = "HELLO THOMASIAN"
            onboard1.lblContent.text = "The Thomasian Journey Event Notification System will keep you updated with all the local and university-wide events."
            onboard1.btnContinue.isHidden = true
            
            let onboard2:Onboards = Bundle.main.loadNibNamed("Onboards", owner: self, options: nil)?.first as! Onboards
            onboard2.imageView.image = UIImage(named: "ob1")
            onboard2.lblHeading.text = "EVENTS"
            onboard2.lblContent.text = "The Thomasian Journey Event Notification System keeps track of all the events you've attended."
            onboard2.btnContinue.isHidden = true
            
            let onboard3:Onboards = Bundle.main.loadNibNamed("Onboards", owner: self, options: nil)?.first as! Onboards
            onboard3.imageView.image = UIImage(named: "ob2")
            onboard3.lblHeading.text = "NOTIFY"
            onboard3.lblContent.text = "Get notified to all campus events and get points each time you will attend."
            onboard3.btnContinue.isHidden = true
            
            let onboard4:Onboards = Bundle.main.loadNibNamed("Onboards", owner: self, options: nil)?.first as! Onboards
            onboard4.imageView.image = UIImage(named: "ob3")
            onboard4.lblHeading.text = "SCAN QR"
            onboard4.lblContent.text = "The Thomasian Journey validates the attendance with the use of QR Technology."
            onboard4.btnContinue.isHidden = true
            
            let onboard5:Onboards = Bundle.main.loadNibNamed("Onboards", owner: self, options: nil)?.first as! Onboards
            onboard5.imageView.image = UIImage(named: "ob4")
            onboard5.lblHeading.text = "GET STARTED"
            onboard5.lblContent.text = "Welcome to your Journey, Thomasian!\n\nClick here to get started: "
            onboard5.btnContinue.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            
            return [onboard1,onboard2,onboard3,onboard4,onboard5]
            
        }
        
        @objc func buttonClicked(_ sender: UIButton!) {
            let viewPolicy =
    storyboard?.instantiateViewController(withIdentifier: "viewPolicy")
            
            view.window?.rootViewController = viewPolicy
            view.window?.makeKeyAndVisible()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = createOnboards()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)

        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
            let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
            
            if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
                
                slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
                slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
                
            } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
                slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
                slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
                
            } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
                slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
                slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
                
            } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
                slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
                slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
            }
        }

}
