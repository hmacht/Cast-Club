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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTextView()
        createPostButton()
        createCloseButton()
        attachButtonOnKeyboard()
        
        // Do any additional setup after loading the view.
        textView.delegate = self
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
        postButton.setTitleColor(UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0), for: .normal)
        self.view.addSubview(postButton)
    }
    
    func createTextView() {
        textView = UITextView(frame: CGRect(x: 15, y: screenSize.height/10, width: screenSize.width - 15, height: screenSize.height/2))
        textView.dataDetectorTypes = .link
        textView.text = "Share your thoughts"
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
        button4.setImage(UIImage(named: "Group 335"), for: .normal)
        //button.addTarget(self, action: #selector(ClubCreationVC.done), for: .touchUpInside)
        let bb1 = UIBarButtonItem(customView: button1)
        let bb2 = UIBarButtonItem(customView: button2)
        let bb3 = UIBarButtonItem(customView: button3)
        let bb4 = UIBarButtonItem(customView: button4)
        
    
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        //toolbar.setItems([bb1, bb2, bb3, bb4], animated: false)
        
        toolbar.items = [bb1, bb2, bb3, bb4]
        
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
    }
    
    // creates placeholder text
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = "Share your thoughts"
            textView.textColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        else if textView.textColor == UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0) && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
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
    
    @objc func post(){
        print("POST")
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
