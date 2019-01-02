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
    
    let catagories = ["Everything", "News", "Comedy", "Arts", "Business", "Education", "Games & Hobbies", "Health", "Kids", "Music", "Science", "Sports", "TV & Film", "Technology"]
    
    var buttons = [UIButton]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = []
        createTextBoxe()
        createHeader()
        createSubHeader(text: "Category", add: 45)
        createSubHeader(text: "Privacy", add: 120)
        createButton(title: "Public", Action: #selector(publicAction), Frame: CGRect(x: catagoryInput.frame.minX, y: catagoryInput.frame.maxY + 35, width: 140, height: 40))
        createButton(title: "Private", Action: #selector(privateAction), Frame: CGRect(x: catagoryInput.frame.minX + 160, y: catagoryInput.frame.maxY + 35, width: 140, height: 40))
        createSubHeader(text: "Clubs Profile Image", add: 195)
        createImageSelectors(frameX: Int(catagoryInput.frame.minX), imgName: "Group 464", Action: #selector(accessCamera))
        createImageSelectors(frameX: Int(catagoryInput.frame.minX + 75), imgName: "Group 465", Action: #selector(accessPhotoLib))
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        catagoryInput.inputView = pickerView
        
        addDoneButtonOnKeyboard()
        
        createProfileImage()

        // Do any additional setup after loading the view.
    }
    
    func createHeader(){
        header = UILabel(frame: CGRect(x: catagoryInput.frame.minX, y: screenSize.height/10, width: 300, height: 30))
        header.textAlignment = .left
        header.font = UIFont(name: "Mont-HeavyDEMO", size: 27)
        header.text = "One Last thing"
        self.view.addSubview(header)
    }
    
    func createSubHeader(text: String, add: CGFloat){
        sub = UILabel(frame: CGRect(x: catagoryInput.frame.minX, y: screenSize.height/10 + add, width: 200, height: 30))
        
        sub.textAlignment = .left
        sub.textColor = UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        sub.font = UIFont(name: "Avenir-Heavy", size: 16)
        sub.text = text
        self.view.addSubview(sub)
    }
    
    func createTextBoxe(){
        catagoryInput = UITextField(frame: CGRect(x: 0, y: screenSize.height/10 + 75, width: 300, height: 40))
        catagoryInput.center.x = screenSize.width/2
        catagoryInput.attributedPlaceholder = NSAttributedString(string: "Select a categorie",
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
    
    
    
    func addDoneButtonOnKeyboard() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
        button.setImage(UIImage(named: "Group 463"), for: .normal)
        button.addTarget(self, action: #selector(ClubCreationVC.done), for: .touchUpInside)
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
        profileImageView.frame = CGRect(x: Int(catagoryInput.frame.minX + 150), y: Int(buttons[0].frame.maxY + 35), width: 65, height: 65)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 32.5
        self.view.addSubview(profileImageView)
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
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        print("Done")
        self.view.endEditing(true)
        
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
        requestAccess()
        camera()
    }
    
    @objc func accessPhotoLib(sender: UIButton!) {
        print("Lib")
        requestAccess()
        photoLibrary()
    }
    
    func requestAccess(){
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
            } else {
                
            }
        }
        
        //Photos
        
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
