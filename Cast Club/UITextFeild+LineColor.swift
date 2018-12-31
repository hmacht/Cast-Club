//
//  UITextFeild+LineColor.swift
//  Cast Club
//
//  Created by Henry Macht on 12/31/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
}
