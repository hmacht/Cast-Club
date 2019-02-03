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
    
    let viewHeight: Int

    init(frame: CGRect, viewHeight: Int) {
        self.viewHeight = viewHeight
        super.init(frame: frame)
        
    
        
        
        
        createBgView()
        createView()
        createButton()
        
    }
    
    func createView() {
        view = UIView(frame: CGRect(x: 0, y: Int(screenSize.height), width: Int(screenSize.width), height: viewHeight))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        
        // Reminder: navigation bar is messing things up
        UIView.animate(withDuration: 0.5, animations: {
            self.view.center.y -= self.view.frame.height * 2
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
        self.view.addSubview(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
