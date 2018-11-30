//
//  slider.swift
//  Cast Club
//
//  Created by Henry Macht on 11/29/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class slider: UISlider {

    @IBInspectable var trackHeight: CGFloat = 15
    let screenSize = UIScreen.main.bounds
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        
        
        let sliderWidth: CGFloat = screenSize.width - 55
        self.frame = CGRect(x: screenSize.width/2 - sliderWidth/2, y: 10, width: sliderWidth, height: 35)
        //self.center = self.center
        
        self.minimumTrackTintColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        self.maximumTrackTintColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        self.thumbTintColor = .white
        
        
        
        self.maximumValue = 100
        self.minimumValue = 0
        self.setValue(50, animated: false)
        
        self.addTarget(self, action: #selector(slider.changeVlaue), for: .valueChanged)
        
        let image: UIImage? = UIImage(named: "Ellipse 75")
        self.setThumbImage(image, for: .normal)
        self.setThumbImage(image, for: .highlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        //set your bounds here
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
    @objc func changeVlaue(_ sender: UISlider) {
        print("value is" , Int(sender.value));
    }

}
