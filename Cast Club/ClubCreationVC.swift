//
//  ClubCreationVC.swift
//  Cast Club
//
//  Created by Henry Macht on 12/31/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class ClubCreationVC: UIViewController {
    
    let screenSize = UIScreen.main.bounds
    var header = UILabel()
    var clubNameInput = UITextField()
    var doneButton = UIButton()
    var barButton = UIBarButtonItem()
    
    var toolbar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: "textChanged:", name: UITextField.textDidChangeNotification, object: nil)

        // Do any additional setup after loading the view.
        createTextBoxes()
        createHeader()
        addDoneButtonOnKeyboard()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        clubNameInput.becomeFirstResponder()
    }
    
    func addDoneButtonOnKeyboard() {
        doneButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
        doneButton.setImage(UIImage(named: "Group 443"), for: .normal)
        doneButton.addTarget(self, action: #selector(ClubCreationVC.done), for: .touchUpInside)
        barButton = UIBarButtonItem(customView: doneButton)
        barButton.isEnabled = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        toolbar.setItems([flexSpace, flexSpace, barButton], animated: false)
        
        toolbar.sizeToFit()
        clubNameInput.inputAccessoryView = toolbar
    }
    
    func createTextBoxes(){
        clubNameInput = UITextField(frame: CGRect(x: 0, y: screenSize.height/10 + 50, width: 300, height: 40))
        clubNameInput.center.x = screenSize.width/2
        clubNameInput.placeholder = "Clubs Name"
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
        self.view.addSubview(clubNameInput)
    }
    
    func createHeader(){
        header = UILabel(frame: CGRect(x: clubNameInput.frame.minX, y: screenSize.height/10, width: 200, height: 30))
        header.textAlignment = .left
        header.textColor = .black
        header.font = UIFont(name: "Mont-HeavyDEMO", size: 27)
        header.text = "Create a Club"
        self.view.addSubview(header)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is LastStepVC
        {
            let vc = segue.destination as? LastStepVC
            if let input = clubNameInput.text {
                vc?.clubeName = input
            }
            
        }
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
        self.performSegue(withIdentifier: "lastStep", sender: self)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
