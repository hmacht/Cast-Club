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
        }
        
    }
    
    func createView() {
        view = UIView(frame: CGRect(x: 0, y: Int(screenSize.height), width: Int(screenSize.width), height: viewHeight))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        
        // Reminder: navigation bar is messing things up
        UIView.animate(withDuration: 0.5, animations: {
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
        
        UIView.animate(withDuration: 0.5, animations: {
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
    
    
    var sharButtons = [UIButton]()
    var buttonImages = ["Group 301", "Group 302", "Group 737"]
    var xPos = 20
    
    func createShareBucket(){
        let title1 = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 50))
        title1.text = "Share"
        title1.font = UIFont(name: "Avenir-Heavy", size: 14)
        title1.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64/255.0, alpha: 1.0)
        self.view.addSubview(title1)
        
        for i in 0...2 {
            print("Hello")
            var shareButton = UIButton(frame: CGRect(x: xPos, y: 40, width: Int(screenSize.width/6), height: Int(screenSize.width/6)))
            shareButton.setImage(UIImage(named: buttonImages[i]), for: .normal)
            shareButton.layer.cornerRadius = screenSize.width/12
            shareButton.addTarget(self, action: #selector(BucketView.share), for: .touchUpInside)
            shareButton.tag = i
            self.view.addSubview(shareButton)
            xPos += Int(screenSize.width/6 + 10)
        }
        
        let title2 = UILabel(frame: CGRect(x: 20, y: screenSize.width/6 + 25, width: 100, height: 50))
        title2.text = "Report"
        title2.font = UIFont(name: "Avenir-Heavy", size: 14)
        title2.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64/255.0, alpha: 1.0)
        self.view.addSubview(title2)
        
        reportButton = UIButton(frame: CGRect(x: 20, y: Int(title2.frame.minY + 40), width: Int(screenSize.width/6), height: Int(screenSize.width/6)))
        reportButton.setImage(UIImage(named: "Group 304"), for: .normal)
        reportButton.layer.cornerRadius = screenSize.width/12
        self.view.addSubview(reportButton)
        
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
    
    
    @objc func close(){
        UIView.animate(withDuration: 0.5, animations: {
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
