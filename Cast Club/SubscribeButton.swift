//
//  SubscribeButton.swift
//  Cast Club
//
//  Created by Toby Kreiman on 1/3/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class SubscribeButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.setBackgroundImage(UIImage(named: "Rectangle 164"), for: .normal)
    }
    
    func setTextUnsubscribe() {
        //self.titleLabel?.text = "Unsubscribe"
        self.setTitle("Unsubscribe", for: .normal)
    }
    
    func setTextSubscribe() {
        //self.titleLabel?.text = "Subscribe"
        self.setTitle("Subscribe", for: .normal)
    }
 
    

}
