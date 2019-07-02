//
//  LastStepVC.swift
//  Cast Club
//
//  Created by Henry Macht on 12/31/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import AVFoundation

class LastStepVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var header = UILabel()
    var sub = UILabel()
    let screenSize = UIScreen.main.bounds
    var catagoryInput = UITextField()
    var profileImageView = UIImageView()
    var xVal = CGFloat()
    var inviteButton = UIButton()
    var clubeName = String()
    var createButton = UIButton()
    
    var selectedCategory = ClubCategory.none
    var isPublic = true
    
    let catagories = [" ", "Everything", "News", "Culture", "Comedy", "Education", "Art", "Business", "Politics", "Kids",  "Music", "TV & Film", "Technology", "Sports", "Health", "Games & Hobbies"]
    
    var buttons = [UIButton]()
    
    var hasEditedImage = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = []
        createTextBoxe()
        xVal = catagoryInput.frame.minX
        createHeader()
        createSubHeader(text: "Category", add: 45)
        createSubHeader(text: "Privacy", add: 120)
        let bWidth = (self.view.frame.width - 130) / 2
        createButton(title: "Public", Action: #selector(publicAction), Frame: CGRect(x: xVal, y: catagoryInput.frame.maxY + 35, width: bWidth, height: 40))
        createButton(title: "Private", Action: #selector(privateAction), Frame: CGRect(x: xVal + 80 + bWidth/2, y: catagoryInput.frame.maxY + 35, width: bWidth, height: 40))
        self.selected(index: 1, Sender: self.buttons[0])
        createSubHeader(text: "Clubs Profile Image", add: 195)
        createImageSelectors(frameX: Int(xVal), imgName: "Group 464", Action: #selector(accessCamera))
        createImageSelectors(frameX: Int(xVal + 75), imgName: "Group 465", Action: #selector(accessPhotoLib))
        //createSubHeader(text: "Invite", add: 290)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        catagoryInput.inputView = pickerView
        
        addDoneButtonOnKeyboard()
        
        createProfileImage()
        //createInviteButton()
        
        createCreateButton()

        // Do any additional setup after loading the view.
    }
    
    func createHeader(){
        header = UILabel(frame: CGRect(x: xVal, y: screenSize.height/10, width: 300, height: 30))
        header.textAlignment = .left
        header.font = UIFont(name: "Mont-HeavyDEMO", size: 27)
        header.text = "One Last thing"
        self.view.addSubview(header)
    }
    
    func createSubHeader(text: String, add: CGFloat){
        sub = UILabel(frame: CGRect(x: xVal, y: screenSize.height/10 + add, width: 200, height: 30))
        
        sub.textAlignment = .left
        sub.textColor = UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        sub.font = UIFont(name: "Avenir-Heavy", size: 16)
        sub.text = text
        self.view.addSubview(sub)
    }
    
    func createTextBoxe(){
        catagoryInput = UITextField(frame: CGRect(x: 0, y: screenSize.height/10 + 75, width: self.view.frame.width - 40, height: 40))
        catagoryInput.center.x = screenSize.width/2
        catagoryInput.attributedPlaceholder = NSAttributedString(string: "Select a category",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0)])
        catagoryInput.font = UIFont(name: "Mont-HeavyDEMO", size: 14)
        catagoryInput.textColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        catagoryInput.borderStyle = UITextField.BorderStyle.roundedRect
        catagoryInput.layer.masksToBounds = true
        catagoryInput.layer.borderColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0).cgColor
        catagoryInput.layer.borderWidth = 2.0
        catagoryInput.layer.cornerRadius = 5.0
        catagoryInput.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        catagoryInput.autocorrectionType = UITextAutocorrectionType.no
        catagoryInput.keyboardType = UIKeyboardType.default
        catagoryInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.view.addSubview(catagoryInput)
    }
    
    func createButton(title: String, Action: Selector, Frame: CGRect){
        let button = UIButton(frame: Frame)
        button.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Mont-HeavyDEMO", size: 14)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5.0
        button.setTitleColor(UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: Action, for: .touchUpInside)
        self.view.addSubview(button)
        buttons.append(button)
        
    }
    
    func createCreateButton(){
        //if let tabBarHeight = tabBarController?.tabBar.frame.height{
            createButton = UIButton(frame: CGRect(x: xVal, y: screenSize.height - 240, width: self.view.frame.width - 40, height: 50))
        //}
        createButton.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 0.5)
        createButton.setTitle("Create", for: .normal)
        createButton.titleLabel?.font = UIFont(name: "Mont-HeavyDEMO", size: 14)
        createButton.layer.masksToBounds = true
        createButton.layer.cornerRadius = 5.0
        createButton.setTitleColor(.white, for: .normal)
        createButton.addTarget(self, action: #selector(LastStepVC.create), for: .touchUpInside)
        createButton.isUserInteractionEnabled = false
        self.view.addSubview(createButton)
        //buttons.append(createButton)
    }
    
    func addDoneButtonOnKeyboard() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
        button.setImage(UIImage(named: "Group 463"), for: .normal)
        button.addTarget(self, action: #selector(LastStepVC.done), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        toolbar.setItems([flexSpace, flexSpace, barButton], animated: false)
        toolbar.sizeToFit()
        catagoryInput.inputAccessoryView = toolbar
    }
    
    func selected(index: Int, Sender: UIButton){
        Sender.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        Sender.setTitleColor(.white, for: .normal)
        buttons[index].backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        buttons[index].setTitleColor(UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0), for: .normal)
        
        if Sender.titleLabel?.text == "Public" {
            self.isPublic = true
        } else {
            self.isPublic = false
        }
    }
    
    func createImageSelectors(frameX: Int, imgName: String, Action: Selector){
        let image = UIImage(named: imgName)
        let button = UIButton(frame: CGRect(x: frameX, y: Int(buttons[0].frame.maxY + 35), width: 65, height: 65))
        //button.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 32.5
        button.setImage(image, for: .normal)
        button.addTarget(self, action: Action, for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func createProfileImage(){
        profileImageView = UIImageView(image: UIImage(named: "Group 466"))
        profileImageView.frame = CGRect(x: Int(xVal + 150), y: Int(buttons[0].frame.maxY + 35), width: 65, height: 65)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 32.5
        self.view.addSubview(profileImageView)
    }
    
    func createInviteButton(){
        let image = UIImage(named: "Group 444")
        inviteButton = UIButton(frame: CGRect(x: Int(xVal), y: Int(profileImageView.frame.maxY + 30), width: 65, height: 65))
        //button.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        inviteButton.layer.masksToBounds = true
        inviteButton.layer.cornerRadius = 32.5
        inviteButton.setImage(image, for: .normal)
        inviteButton.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
        self.view.addSubview(inviteButton)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catagories.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catagories[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        catagoryInput.text = catagories[row]
        catagoryInput.textColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        
        if let category = ClubCategory(rawValue: catagories[row]) {
            self.selectedCategory = category
        }
    }
    
    func camera() {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .camera
        self.present(myPickerController, animated: true, completion: nil)
        
        
    }
    
    func photoLibrary() {
        
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImageView.image = image
        self.hasEditedImage = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        print("Done")
        print(catagoryInput.text)
        if catagoryInput.text == " " {
            catagoryInput.text = "Must Enter Club Catagory"
            catagoryInput.textColor = UIColor(red: 253.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
            createButton.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 0.5)
            createButton.isUserInteractionEnabled = false
        } else {
            catagoryInput.textColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0)
            createButton.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
            createButton.isUserInteractionEnabled = true
        }
        self.view.endEditing(true)
        
    }
    
    @objc func create() {
        print("Create")
        
        self.createButton.setTitle("", for: .normal)
        let activity = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 20, y: self.createButton.center.y - 20, width: 40, height: 40))
        activity.color = .white
        
        self.view.addSubview(activity)
        activity.startAnimating()
        
        if let img = profileImageView.image?.resizedImageWithinRect(rectSize: CGSize(width: 250, height: 250)) {
            var imgToUse: UIImage? = img
            if !self.hasEditedImage {
                imgToUse = nil
            } 
            CloudKitHelper.instance.writeClub(name: clubeName, image: imgToUse, isPublic: self.isPublic, category: self.selectedCategory) { (error, club) in
                if let e = error {
                    print(e)
                    DispatchQueue.main.async {
                        self.tabBarController?.showError(with: e.localizedDescription)
                        self.performSegue(withIdentifier: "doneWithCreation", sender: self)
                    }
                } else {
                    print("Good")
                    
                    // Add the club to the table view
                    if let navController = self.tabBarController?.customizableViewControllers?[2] as? UINavigationController {
                        print("1")
                        for vc in navController.viewControllers {
                            if let clubVC = vc as? ClubVC {
                                print("2")
                                if let c = club {
                                    print("3")
                                    clubVC.clubs.append(c)
                                }
                                break
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "doneWithCreation", sender: self)
                    }
                }
            }
            
        
        } else {
            print("Error with image")
        }
 
        
        //self.view.backgroundColor = .black
        
        //createButton.setTitle("", for: .normal)
        //var checkAnimation = DoneView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        //checkAnimation.center = CGPoint(x: 200, y: 550)
        //self.view.addSubview(checkAnimation)
 
        
        //self.performSegue(withIdentifier: "doneWithCreation", sender: self)
 
       
        
        
    }
    
    @objc func publicAction(sender: UIButton!) {
        print("Public")
        selected(index: 1, Sender: sender)
    }
    
    @objc func privateAction(sender: UIButton!) {
        print("Private")
        selected(index: 0, Sender: sender)
    }
    
    @objc func accessCamera(sender: UIButton!) {
        print("Camera")
        
        requestAccess { (success) in
            if success {
                self.camera()
            }
        }
    }
    
    @objc func accessPhotoLib(sender: UIButton!) {
        print("Lib")
        requestAccess { (success) in
            if success {
                self.photoLibrary()
            }
        }
    }
    
    @objc func addFriend(sender: UIButton!) {
        print("add")
    }
    
    func requestAccess(completion: @escaping (Bool) -> ()){
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
                completion(true)
            } else {
                completion(false)
            }
        }
        
        //Photos
        
    }

}
