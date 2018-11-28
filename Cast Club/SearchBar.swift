//
//  SearchBar.swift
//  Cast Club
//
//  Created by Henry Macht on 11/26/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let screenSize = UIScreen.main.bounds
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let textField = self.value(forKey: "searchField") as? UITextField {
            if let textFieldInsideSearchBarLabel = textField.value(forKey: "placeholderLabel") as? UILabel {
                textFieldInsideSearchBarLabel.textColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0)
                textField.font = UIFont(name: "Mont-HeavyDEMO", size: 16)
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        if let textField = self.value(forKey: "searchField") as? UITextField {
            if let textFieldInsideSearchBarLabel = textField.value(forKey: "placeholderLabel") as? UILabel {
                textFieldInsideSearchBarLabel.textColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0)
                textField.font = UIFont(name: "Mont-HeavyDEMO", size: 16)
            }
        }
        
        for subView in self.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.bounds
                    bounds.size.height = 50 //(set height whatever you want)
                    bounds.size.width = screenSize.width - 30
                    textField.bounds = bounds
                    textField.borderStyle = UITextField.BorderStyle.roundedRect
                }
                
                
            }
        }
        
        
        
        var textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
    
        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        
        
        self.layer.borderColor = UIColor.white.cgColor;
        self.layer.borderWidth = 1;
        
        //self.keyboardAppearance = UIKeyboardAppearance.dark
       
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
