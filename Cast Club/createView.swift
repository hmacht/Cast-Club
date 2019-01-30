//
//  createView.swift
//  Cast Club
//
//  Created by Henry Macht on 1/29/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class createView: UIView {
    
    let screenSize = UIScreen.main.bounds
    var header = UILabel()
    var clubNameInput = UITextField()
    var doneButton = UIButton()
    var barButton = UIBarButtonItem()
    var toolbar = UIToolbar()
    
    let headerText: String
    let placeholderText: String
    
    init (frame: CGRect, headerText: String, placeholderText: String) {
        self.headerText = headerText
        self.placeholderText = placeholderText
        super.init(frame: frame)
        
        clubNameInput = UITextField(frame: CGRect(x: 0, y: screenSize.height/10 + 50, width: 300, height: 40))
        clubNameInput.center.x = screenSize.width/2
        clubNameInput.placeholder = placeholderText
        clubNameInput.font = UIFont(name: "Avenir-Heavy", size: 16)
        clubNameInput.textColor = UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        //clubNameInput.borderStyle = UITextField.BorderStyle.line
        clubNameInput.setBottomLine(borderColor: UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1.0))
        clubNameInput.autocorrectionType = UITextAutocorrectionType.no
        clubNameInput.keyboardType = UIKeyboardType.default
        //clubNameInput.returnKeyType = UIReturnKeyType.done
        //clubNameInput.clearButtonMode = UITextField.ViewMode.whileEditing;
        clubNameInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        clubNameInput.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControl.Event.editingChanged)
        self.addSubview(clubNameInput)
        
        header = UILabel(frame: CGRect(x: clubNameInput.frame.minX, y: screenSize.height/10, width: 200, height: 30))
        header.textAlignment = .left
        header.textColor = .black
        header.font = UIFont(name: "Mont-HeavyDEMO", size: 27)
        header.text = headerText
        self.addSubview(header)
        
        addDoneButtonOnKeyboard()
        clubNameInput.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addDoneButtonOnKeyboard() {
        doneButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
        doneButton.setImage(UIImage(named: "Group 443"), for: .normal)
        doneButton.addTarget(self, action: #selector(createView.done), for: .touchUpInside)
        barButton = UIBarButtonItem(customView: doneButton)
        barButton.isEnabled = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        toolbar.setItems([flexSpace, flexSpace, barButton], animated: false)
        
        toolbar.sizeToFit()
        clubNameInput.inputAccessoryView = toolbar
    }
    
    
    
    
    
    
    
    @objc func textFieldEditingDidChange() {
        if clubNameInput.hasText{
            barButton.isEnabled = true
        }
        else {
            barButton.isEnabled = false
        }
    }
    
    @objc func done() {
        print("Done")
        //self.performSegue(withIdentifier: "lastStep", sender: self)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
