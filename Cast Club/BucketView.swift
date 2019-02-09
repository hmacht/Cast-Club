//
//  bucketView.swift
//  Cast Club
//
//  Created by Henry Macht on 2/2/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class BucketView: UIView {
    
    let screenSize = UIScreen.main.bounds
    
    var view = UIView()
    var bgView = UIView()
    var closeButton = UIButton()
    
    var reportButton = UIButton()
    var shareButton = UIButton()
    
    var latestFilterButton = UIButton()
    var likesFilterButton = UIButton()
    var popularFilterButton = UIButton()
    
    var cameraButton = UIButton()
    var libraryButton = UIButton()
    
    var podcastButton = UIButton()
    
    
    
    
    let viewHeight: Int
    let style: Int

    init(frame: CGRect, viewHeight: Int, style: Int) {
        self.viewHeight = viewHeight
        self.style = style
        super.init(frame: frame)
        
    
        createBgView()
        createView()
        createButton()
        
        if style == 1{
            createShareBucket()
        } else if style == 2 {
            createFilterBucket()
        } else if style == 3 {
            createCameraBucket()
        } else if style == 4 {
            createUpdateBucket()
        }
        
    }
    
    func createView() {
        view = UIView(frame: CGRect(x: 0, y: Int(screenSize.height), width: Int(screenSize.width), height: viewHeight))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        
        // Reminder: navigation bar is messing things up
        UIView.animate(withDuration: 0.25, animations: {
            self.view.center.y -= self.view.frame.height
        }, completion: {finished in
            self.view.isUserInteractionEnabled = true
        })
    }
    
    func createBgView() {
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: Int(screenSize.width), height: Int(screenSize.height)))
        bgView.backgroundColor = .black
        bgView.alpha = 0.0
        self.addSubview(bgView)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.alpha = 0.3
        }, completion: nil)
    }
    
    func createButton(){
        closeButton = UIButton(frame: CGRect(x: 0, y: viewHeight - 75, width: Int(screenSize.width - screenSize.width/15), height: 50))
        closeButton.center.x = screenSize.width/2
        closeButton.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247/255.0, alpha: 1.0)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        closeButton.setTitleColor(UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64/255.0, alpha: 1.0), for: .normal)
        closeButton.layer.cornerRadius = 5.0
        closeButton.addTarget(self, action: #selector(BucketView.close), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    
    
    
    // Share Bucket ---
    
    //var buttonImages = ["Group 301", "Group 302", "Group 737"]
    var buttonTitles = ["     Share", "     Report"]
    var yPos = 0
    
    func createShareBucket(){
//        let title1 = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 50))
//        title1.text = "Share"
//        title1.font = UIFont(name: "Avenir-Heavy", size: 14)
//        title1.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64/255.0, alpha: 1.0)
//        self.view.addSubview(title1)
        
        for i in 0...1 {
            var button = UIButton(frame: CGRect(x: 0, y: yPos, width: Int(screenSize.width - screenSize.width/15), height: 50))
            //button.setImage(UIImage(named: buttonImages[i]), for: .normal)
            //button.layer.cornerRadius = screenSize.width/12
            button.addTarget(self, action: #selector(BucketView.share), for: .touchUpInside)
            button.center.x = screenSize.width/2
            button.backgroundColor = .white
            button.setTitle(buttonTitles[i], for: .normal)
            button.contentHorizontalAlignment = .left
            button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
            button.setTitleColor(UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64/255.0, alpha: 1.0), for: .normal)
            button.tag = i
            
            if i == 0 {
                self.shareButton = button
                print("B1")
            } else {
                self.reportButton = button
                print("B2")
            }
            self.view.addSubview(button)
            print(button.frame.midY)
            yPos += 50
            
            
        }
        
//        let title2 = UILabel(frame: CGRect(x: 20, y: screenSize.width/6 + 25, width: 100, height: 50))
//        title2.text = "Report"
//        title2.font = UIFont(name: "Avenir-Heavy", size: 14)
//        title2.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64/255.0, alpha: 1.0)
//        self.view.addSubview(title2)
//        
//        reportButton = UIButton(frame: CGRect(x: 20, y: Int(title2.frame.minY + 40), width: Int(screenSize.width/6), height: Int(screenSize.width/6)))
//        reportButton.setImage(UIImage(named: "Group 304"), for: .normal)
//        reportButton.layer.cornerRadius = screenSize.width/12
//        self.view.addSubview(reportButton)
        
    }
    
    @objc func share(sender: UIButton){
        
        if sender.tag == 0{
            print("MESSAGE")
        } else if sender.tag == 1{
            print("TWITTER")
        } else {
            print("FACEBOOK")
        }
        
    }
    
    // Filter Bucket ---
    var filterButtonTitles = ["     Latest", "     Likes", "     Popular"]
    func createFilterBucket(){
        for i in 0...2 {
            var button = UIButton(frame: CGRect(x: 0, y: yPos, width: Int(screenSize.width - screenSize.width/15), height: 50))
            button.center.x = screenSize.width/2
            button.backgroundColor = .white
            button.setTitle(filterButtonTitles[i], for: .normal)
            button.contentHorizontalAlignment = .left
            button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
            button.setTitleColor(UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64/255.0, alpha: 1.0), for: .normal)
            button.tag = i
            
            if i == 0 {
                self.latestFilterButton = button
                print("B1")
            } else if i == 1 {
                self.likesFilterButton = button
                print("B2")
            } else {
                self.popularFilterButton = button
            }
            
            self.view.addSubview(button)
            print(button.frame.midY)
            yPos += 50
            
            
        }
        
    }
    
    // photo selection Bucket ---
    var cameraButtonTitles = ["     Camera", "     Library"]
    func createCameraBucket(){
        for i in 0...1 {
            var button = UIButton(frame: CGRect(x: 0, y: yPos, width: Int(screenSize.width - screenSize.width/15), height: 50))
            button.center.x = screenSize.width/2
            button.backgroundColor = .white
            button.setTitle(cameraButtonTitles[i], for: .normal)
            button.contentHorizontalAlignment = .left
            button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
            button.setTitleColor(UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64/255.0, alpha: 1.0), for: .normal)
            button.tag = i
            
            if i == 0 {
                self.cameraButton = button
                print("B1")
            } else {
                self.libraryButton = button
            }
            
            self.view.addSubview(button)
            yPos += 50
            
            
        }
        
    }
    
    // Update Bucket ---
    
    func createUpdateBucket(){
        
        var button = UIButton(frame: CGRect(x: closeButton.frame.minX, y: closeButton.frame.minY - 90, width: 70, height: 70))
        button.setImage(UIImage(named: "Group 439"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6.0
        self.podcastButton = button
        self.view.addSubview(button)
        
        var podcastTitle = UILabel(frame: CGRect(x: button.frame.maxX + 20, y: button.frame.midY - 20, width: 100, height: 25))
        podcastTitle.text = "Podcast Title"
        podcastTitle.font = UIFont(name: "Avenir-Heavy", size: 12)
        podcastTitle.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        self.view.addSubview(podcastTitle)
        
        var podcastAuthor = UILabel(frame: CGRect(x: button.frame.maxX + 20, y: button.frame.midY - 5, width: 100, height: 25))
        podcastAuthor.text = "Author"
        podcastAuthor.font = UIFont(name: "Avenir-Heavy", size: 12)
        podcastAuthor.textColor = UIColor(red: 178.0/255.0, green: 178.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        self.view.addSubview(podcastAuthor)
        
        var subheader2 = UILabel(frame: CGRect(x: button.frame.minX, y: button.frame.minY - 30, width: 200, height: 25))
        subheader2.text = "Currently listening to"
        subheader2.font = UIFont(name: "Avenir-Black", size: 14)
        subheader2.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        self.view.addSubview(subheader2)
        
        var updateMessageLabel = UILabel(frame: CGRect(x: button.frame.minX, y: 35, width: closeButton.frame.width, height: 90))
        updateMessageLabel.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus."
        updateMessageLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        updateMessageLabel.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        updateMessageLabel.numberOfLines = 6
        self.view.addSubview(updateMessageLabel)
        
        var subheader1 = UILabel(frame: CGRect(x: button.frame.minX, y: 10, width: 200, height: 25))
        subheader1.text = "Update from Club Creator"
        subheader1.font = UIFont(name: "Avenir-Black", size: 14)
        subheader1.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        self.view.addSubview(subheader1)
        
            
            
        
        
    }
    
    
    
    @objc func close(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.alpha = 0.0
            self.view.center.y += self.view.frame.height
        }, completion: {finished in
            self.removeFromSuperview()
        })
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
