//
//  ProfileViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 1/29/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bucketView = BucketView(frame: CGRect(), viewHeight: 0, style: 0)
    
    
    
    func createEmail(reasoning: String, explanation: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["podtalkdevelopers@gmail.com"])
            mail.setSubject(reasoning)
            mail.setMessageBody("<b>\(explanation)</b> \n <p>Issue: </p>", isHTML: true)
            
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let label = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(4) as? UILabel {
            if CloudKitHelper.instance.username.count > 0 {
                label.text = CloudKitHelper.instance.username
            } else {
                label.text = "Username"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 {
            return 72
        } else {
            return 195
        }
    }
    
    //Notification, group 751, 4
    var sectionIcons = ["Group 749", "Group 750", "Group 752", "Group 843", "Group 754", "Group 755"]
    var sectionTitles = ["Username", "Profile Picture", "Settings", "Report an Issue", "Help", "Terms & conditions"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell", for:indexPath)
            if let profileImg = headerCell.viewWithTag(3) as? UIImageView {
                profileImg.image = UIImage(named: "headshot")
                profileImg.clipsToBounds = true
                profileImg.layer.cornerRadius = 60
                profileImg.contentMode = .scaleAspectFill
                
                CloudKitHelper.instance.getProfilePic(for: CloudKitHelper.instance.userId.recordName) { (image) in
                    if let img = image {
                        DispatchQueue.main.async {
                            if profileImg.image?.size == UIImage(named: "headshot")?.size {
                                profileImg.image = img
                            }
                        }
                    }
                }
            }
            
            if let usernameLabel = headerCell.viewWithTag(4) as? UILabel {
                if CloudKitHelper.instance.username.count > 0 {
                    usernameLabel.text = CloudKitHelper.instance.username
                } else {
                    usernameLabel.text = "Username"
                }
            }
        
            headerCell.selectionStyle = .none
            return headerCell
        } else {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! UITableViewCell
            if let sectionIcon = cell.viewWithTag(5) as? UIImageView {
                sectionIcon.image = UIImage(named: sectionIcons[indexPath.row - 1])
                sectionIcon.clipsToBounds = true
                sectionIcon.layer.cornerRadius = 20
                sectionIcon.contentMode = .scaleAspectFill
            }
            
            if let sectionTitle = cell.viewWithTag(6) as? UILabel {
                sectionTitle.text = sectionTitles[indexPath.row - 1] 
                sectionTitle.sizeToFit()
            }
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            if !CloudKitHelper.instance.isAuthenticated {
                self.tabBarController?.showError(with: "You must be logged in to iCloud to edit your username.")
                return
            } else {
                self.performSegue(withIdentifier: "toUsername", sender: self)
            }
        } else if indexPath.row == 2 {
            if !CloudKitHelper.instance.isAuthenticated {
                self.tabBarController?.showError(with: "You must be logged in to iCloud to edit your profile picture.")
                return
            }
            self.bucketView = BucketView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewHeight: 180, style: 3)
            bucketView.frame = UIApplication.shared.keyWindow!.frame
            UIApplication.shared.keyWindow!.addSubview(bucketView)
            
            bucketView.cameraButton.addTarget(self, action: #selector(ProfileViewController.accessCamera(sender:)), for: .touchUpInside)
            bucketView.libraryButton.addTarget(self, action: #selector(ProfileViewController.accessPhotoLib(sender:)), for: .touchUpInside)
        } else if indexPath.row == 3 {
            let alertController = UIAlertController (title: "Go to Settings", message: "Would you like to view the settings for this app? Doing so will take you out of the app and into your settings.", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else if indexPath.row == 4 {
            createEmail(reasoning: "Report A Problem", explanation: "Tell us anything you think we should know. It could be a bug in the app or a problem with the way it works, we listen to everything")
        }
        else if indexPath.row == 5 {
            performSegue(withIdentifier: "toHelp", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is CreateUsernameVC
        {
            let vc = segue.destination as? CreateUsernameVC
            vc?.fromSettings = true
            
            
        }
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
    
    @objc func accessCamera(sender: UIButton!) {
        bucketView.close()
        requestAccess { (success) in
            if success {
                self.openCamera()
            }
        }
    }
    
    @objc func accessPhotoLib(sender: UIButton!) {
        bucketView.close()
        requestAccess { (success) in
            if success {
                self.openLibrary()
            }
        }
        
    }
    
    @objc func openCamera(){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .camera
        self.present(myPickerController, animated: true, completion: nil)
    }
    @objc func openLibrary(){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageView = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(3) as? UIImageView {
                imageView.image = image
                CloudKitHelper.instance.setProfileImage(img: image.resizedImageWithinRect(rectSize: CGSize(width: 250, height: 250))) { (error) in
                    if let e = error {
                        self.tabBarController?.showError(with: e.localizedDescription)
                        print(e)
                    }
                }
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
