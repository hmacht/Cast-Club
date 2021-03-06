//
//  PostVC.swift
//  Cast Club
//
//  Created by Henry Macht on 1/26/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class PostVC: UIViewController, UITextViewDelegate {
    
    let screenSize = UIScreen.main.bounds
    var textView = UITextView()
    var postButton = UIButton()
    var closeButton = UIButton()
    var fromClub = Club()
    var fromMessage = Message()
    
    var isUpdate = Bool()
    var currentClub = Club()
    
    var characterCountLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTextView()
        createPostButton()
        createCloseButton()
        attachButtonOnKeyboard()
        
        // Do any additional setup after loading the view.
        textView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isUpdate {
            self.createCharacterCountLabel()
        } else {
            self.characterCountLabel.removeFromSuperview()
        }
    }
    
    func createCharacterCountLabel() {
        characterCountLabel = UILabel(frame: CGRect(x: self.view.frame.width/2 - 125, y: textView.frame.minY - 28, width: 250, height: 20))
        characterCountLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        characterCountLabel.text = "Characters Remaining: 280"
        characterCountLabel.textAlignment = .center
        
        self.view.addSubview(characterCountLabel)
    }
    
    func createCloseButton() {
        closeButton = UIButton(frame: CGRect(x: 20, y: textView.frame.minY - 28, width: 17, height: 17))
        //closeButton.setTitle("", for: .normal)
        closeButton.setBackgroundImage(UIImage(named: "Group 474"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        
        closeButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 15)
        closeButton.addTarget(self, action: #selector(PostVC.close), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    
    func createPostButton(){
        postButton = UIButton(frame: CGRect(x: screenSize.width - 60, y: textView.frame.minY - 28, width: 50, height: 17))
        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 15)
        postButton.addTarget(self, action: #selector(PostVC.post), for: .touchUpInside)
        postButton.isUserInteractionEnabled = false
        postButton.setTitleColor(UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 0.5), for: .normal)
        self.view.addSubview(postButton)
    }
    
    func createTextView() {
        textView = UITextView(frame: CGRect(x: 15, y: screenSize.height/10, width: screenSize.width - 15, height: screenSize.height/2))
        textView.dataDetectorTypes = .link
        if isUpdate {
            textView.text = "Tell your members what's going on"
        } else {
            textView.text = "Share your thoughts"
        }
        textView.textColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        textView.font = UIFont(name: "Avenir-Heavy", size: 16)
        
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        self.view.addSubview(textView)
    }
    
    func attachButtonOnKeyboard() {
        let button1: UIButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
        button1.setImage(UIImage(named: "Group 499"), for: .normal)
        
        let button2: UIButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
        button2.setImage(UIImage(named: "Group 498"), for: .normal)
        
        let button3: UIButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
        button3.setImage(UIImage(named: "Group 497"), for: .normal)
        
        let button4: UIButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
        button4.setImage(UIImage(named: "Group 748"), for: .normal)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let fizedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        
        fizedSpace.width = 20
        
        //button.addTarget(self, action: #selector(ClubCreationVC.done), for: .touchUpInside)
        let bb1 = UIBarButtonItem(customView: button1)
        let bb2 = UIBarButtonItem(customView: button2)
        let bb3 = UIBarButtonItem(customView: button3)
        let bb4 = UIBarButtonItem(customView: button4)
        
    
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        //toolbar.setItems([bb1, bb2, bb3, bb4], animated: false)
        
        toolbar.items = [bb1, fizedSpace, bb2, fizedSpace, bb4, flexSpace]
        
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
    }
    
    // creates placeholder text
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if isUpdate {
            self.characterCountLabel.text = "Characters Remaining: " + String(280 - self.textView.text.count)
        }
        
        if updatedText.isEmpty {
            self.characterCountLabel.text = "Characters Remaining: 280"
            
            if isUpdate {
                textView.text = "Tell your members what going on"
            } else {
                textView.text = "Share your thoughts"
            }
            
            postButton.isUserInteractionEnabled = false
            postButton.titleLabel?.textColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 0.5)
            
            textView.textColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        else if textView.textColor == UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0) && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
            postButton.isUserInteractionEnabled = true
            postButton.titleLabel?.textColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        }
        else {
            return true
        }
        return false
    }
    
    
    // prevents user from moving cursor
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    @objc func post() {
        
        if isUpdate {
            if self.textView.text.count > 280 {
                
                let alert = UIAlertController(title: "Error", message: "Updates cannot be more than 280 characters long!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            if self.textView.text.count > 0 {
                currentClub.update = self.textView.text
                CloudKitHelper.instance.writeClubUpdate(message: self.currentClub.update, clubId: self.currentClub.id) { (error) in
                    if let e = error {
                        print(e)
                    }
                }
            }
        } else {
            if self.textView.text.count > 0 {
                var message = Message()
                message.clubId = self.fromClub.id
                message.flags = 0
                message.fromMessageId = self.fromMessage.id
                message.fromUser = CloudKitHelper.instance.userId.recordName
                message.numLikes = 0
                message.text = self.textView.text
                message.fromUsername = CloudKitHelper.instance.username
                CloudKitHelper.instance.writeMessage(message) { (error) in
                    if let e = error {
                        print(e)
                    } else {
                        print("Done writing")
                        DispatchQueue.main.async {
                            // TODO - add some confirmation
                            
                        }
                    }
                }
                
            }
        }
        
        
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func close(){
        print("CLOSE")
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func camera(){
        print("CAMERA")
    }
    @objc func gallary(){
        print("GALLARY")
    }
    @objc func link(){
        print("LINK")
    }
    @objc func podcast(){
        print("PODCAST")
    }
}
