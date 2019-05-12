//
//  ErrorPopUp.swift
//  Cast Club
//
//  Created by Henry Macht on 12/16/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class ErrorPopUp: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let headerText: String
    let bodyText: String
    
    init (frame: CGRect, headerText: String, bodyText: String) {
        self.headerText = headerText
        self.bodyText = bodyText
        super.init(frame: frame)
        
        let screenSize = UIScreen.main.bounds
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        headerLabel.center = CGPoint(x: self.frame.width/2, y: 0)
        headerLabel.numberOfLines = 1
        headerLabel.font = UIFont(name: "Mont-HeavyDEMO", size: 22)
        headerLabel.text = headerText
        headerLabel.textAlignment = .center
        //headerLabel.sizeToFit()
        headerLabel.textColor = .black
        self.addSubview(headerLabel)
        
        let bodyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width - screenSize.width/5, height: 50))
        bodyLabel.center = CGPoint(x: self.frame.width/2, y: 45)
        bodyLabel.numberOfLines = 0
        bodyLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        bodyLabel.text = bodyText
        bodyLabel.textAlignment = .center
        bodyLabel.sizeToFit()
        bodyLabel.textColor = UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.addSubview(bodyLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
