//
//  ErrorView.swift
//  Cast Club
//
//  Created by Toby Kreiman on 1/22/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

enum ErrorMessage: String {
    case basic = "Oops, something went wrong."
    case internet = "Check your internet and try again."
    case privateClub = "This club is private."
}

class ErrorView: UIView {

    var message = "Oops, something went wrong."
    var messageLabel = UILabel()
    var okButton = UIButton()
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.layer.cornerRadius = 6
        self.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        
        self.messageLabel = UILabel(frame: CGRect(x: 5, y: 5, width: self.frame.width - 10, height: self.frame.height - 30))
        self.messageLabel.font = UIFont(name: "Avenir Black", size: 16)
        self.messageLabel.textAlignment = .center
        self.messageLabel.numberOfLines = 0
        self.addSubview(self.messageLabel)
        
        self.okButton = UIButton(frame: CGRect(x: 0, y: self.frame.height - 25, width: self.frame.width, height: 20))
        self.okButton.setTitle("OK", for: .normal)
        self.okButton.setTitleColor(.blue, for: .normal)
        self.addSubview(self.okButton)
    }
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: 0, y: rect.height - 25))
        
        aPath.addLine(to: CGPoint(x: rect.width, y: rect.height - 25))
        
        aPath.close()
        
        //If you want to stroke it with a red color
        UIColor.blue.set()
        aPath.stroke()
    }
    
    init(frame: CGRect, message: String) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 20
    
        self.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        
        self.messageLabel = UILabel(frame: CGRect(x: 5, y: 5, width: self.frame.width - 10, height: self.frame.height - 35))
        self.messageLabel.font = UIFont(name: "Avenir Black", size: 24)
        self.messageLabel.textAlignment = .center
        self.messageLabel.numberOfLines = 0
        self.messageLabel.text = message
        self.addSubview(self.messageLabel)
        
        self.okButton = UIButton(frame: CGRect(x: 0, y: self.frame.height - 25, width: self.frame.width, height: 20))
        self.okButton.setTitle("OK", for: .normal)
        self.okButton.setTitleColor(.blue, for: .normal)
        self.addSubview(self.okButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 0, y: 0)
        }, completion: nil)
    }
    
    func present() {
        
    }
    
}
