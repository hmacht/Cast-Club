//
//  ReplyViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 4/25/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var cellUsername = ""
    var selectedMessage = Message()
    var messages = [Message]()
    var bucketView = BucketView(frame: CGRect(), viewHeight: 0, style: 0)
    var moreMessageInd = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Reply to @\(cellUsername)"
        
        //let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(ReplyViewController.writeMessage))
        let addButton = UIBarButtonItem(image: UIImage(named: "Group 734"), style: .plain, target: self, action: #selector(ReplyViewController.writeMessage))
        self.navigationItem.rightBarButtonItem = addButton
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        tableView.separatorStyle = .none
        
        self.tableView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        // Do any additional setup after loading the view.
        
        CloudKitHelper.instance.getMessagesInReply(to: self.selectedMessage.id, sortOption: .newest) { (results, error) in
            if let e = error {
                print(e)
            } else {
                self.messages = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.messages.count + 1
        return self.messages.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for:indexPath) as! UITableViewCell
        
        if let usersProfileImage = myCell.viewWithTag(1) as? UIImageView {
            usersProfileImage.layer.cornerRadius = 20.0
            usersProfileImage.clipsToBounds = true
            usersProfileImage.contentMode = .scaleAspectFill
            usersProfileImage.image = UIImage(named: "img1")
            CloudKitHelper.instance.getProfilePic(for: self.messages[indexPath.row].fromUser) { (image) in
                if let img = image {
                    DispatchQueue.main.async {
                         usersProfileImage.image = img
                    }
                }
            }
        }
        
        if let usernameLabel = myCell.viewWithTag(2) as? UILabel {
            usernameLabel.sizeToFit()
            //usernameLabel.text = self.messages[indexPath.row - 1].fromUsername
            usernameLabel.text = self.messages[indexPath.row].fromUsername
        }
        
        if let responcelabel = myCell.viewWithTag(3) as? UILabel {
            //responcelabel.text = self.messages[indexPath.row - 1].text
            responcelabel.text = self.messages[indexPath.row].text
            responcelabel.sizeToFit()
            responcelabel.numberOfLines = 50
        }
        
        if let likeButton = myCell.viewWithTag(-1) as? UIButton {
            likeButton.setTitle(String(" \(self.messages[indexPath.row].numLikes)"), for: .normal)
            
            likeButton.addTarget(self, action: #selector(ReplyViewController.likeMessage(sender:)), for: .touchUpInside)
            
            if self.messages[indexPath.row].likedUsersList.contains(CloudKitHelper.instance.userId.recordName) {
                // User has already liked message
                likeButton.setImage(UIImage(named: "Path 1885"), for: .normal)
            } else {
                likeButton.setImage(UIImage(named: "Path 1700"), for: .normal)
            }
        }
        
        if let moreButton = myCell.viewWithTag(27) as? UIButton {
            print("In here")
            moreButton.addTarget(self, action: #selector(ReplyViewController.moreButtonPressed(sender:)), for: .touchUpInside)
        }
        
        if let timeLabel = myCell.viewWithTag(-2) as? UILabel {
            let date = self.messages[indexPath.row].creationDate
            let secondsSinceNow = abs(date.timeIntervalSinceNow)
            // More than a year ago
            if secondsSinceNow > 60 * 60 * 24 * 30 {
                // More than a month ago
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                
                timeLabel.text = formatter.string(from: date)
            } else if secondsSinceNow > 60 * 60 * 24 {
                // More than a day ago
                let value = Int(secondsSinceNow) / (60 * 60 * 24)
                var units = "days"
                if value == 1 {
                    units = "day"
                }
                timeLabel.text = "\(value) \(units) ago"
            } else if secondsSinceNow > 60 * 60 {
                // More than an hour ago
                let value = Int(secondsSinceNow) / (60 * 60)
                var units = "hours"
                if value == 1 {
                    units = "hour"
                }
                timeLabel.text = "\(value) \(units) ago"
            } else if secondsSinceNow > 60 {
                // More than a minute ago
                let value = Int(secondsSinceNow) / 60
                var units = "minutes"
                if value == 1 {
                    units = "minute"
                }
                timeLabel.text = "\(value) \(units) ago"
            } else {
                timeLabel.text = "\(Int(secondsSinceNow)) seconds ago"
            }
        }
        
        myCell.selectionStyle = .none
        
        return myCell
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PostVC {
            destination.fromMessage = self.selectedMessage
        }
    }
    
    @objc func writeMessage() {
        if !CloudKitHelper.instance.isAuthenticated {
            self.tabBarController?.showError(with: "You must be logged in to post a message.")
            return
        }
        if CloudKitHelper.instance.username == "" {
            self.tabBarController?.showError(with: "You must set your username to post a message.")
            return
        }
        self.performSegue(withIdentifier: "toPost2", sender: self)
    }
    
    @objc func likeMessage(sender: UIButton) {
        
        if !CloudKitHelper.instance.isAuthenticated {
            self.tabBarController?.showError(with: "You must be logged in to iCloud in your settings to like a message")
            return
        }
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        
        if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
            let m = self.messages[indexPath.row]
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            sender.setTitle(" \(m.numLikes - 1)", for: .normal)
            sender.setImage(UIImage(named: "Path 1700"), for: .normal)
            
            if m.likedUsersList.contains(CloudKitHelper.instance.userId.recordName) {
                self.messages[indexPath.row].numLikes -= 1
                if let ind = self.messages[indexPath.row].likedUsersList.firstIndex(of: CloudKitHelper.instance.userId.recordName) {
                    self.messages[indexPath.row].likedUsersList.remove(at: ind)
                }
                // User has already liked the message
                CloudKitHelper.instance.unlikeMessageWithId(m.id.ckId()) { (error) in
                    if let e = error {
                        print(e)
                    } else {
                        DispatchQueue.main.async {
                            //sender.setTitleColor(.black, for: .normal)
                        }
                    }
                }
            } else {
                // Like the message
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                sender.setTitle(" \(m.numLikes + 1)", for: .normal)
                sender.setImage(UIImage(named: "Path 1885"), for: .normal)
                
                self.messages[indexPath.row].numLikes += 1
                self.messages[indexPath.row].likedUsersList.append(CloudKitHelper.instance.userId.recordName)
                CloudKitHelper.instance.likeMessageWithId(m.id.ckId()) { (error) in
                    if let e = error {
                        print(e)
                    } else {
                        DispatchQueue.main.async {
                            //sender.setTitleColor(.red, for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    @objc func moreButtonPressed(sender: UIButton) {
        print("now")
        if let indexPath = self.tableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: self.tableView)) {
            self.moreMessageInd = indexPath.row
            print("yo")
            self.bucketView = BucketView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewHeight: 180, style: 1)
            bucketView.frame = UIApplication.shared.keyWindow!.frame
            UIApplication.shared.keyWindow!.addSubview(bucketView)
            
            bucketView.reportButton.addTarget(self, action: #selector(ReplyViewController.report), for: .touchUpInside)
            bucketView.shareButton.addTarget(self, action: #selector(ReplyViewController.share(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func share(sender: UIButton) {
        self.bucketView.close()
        let initialText = "Come discuss podcasts on Pod Talk. You can chat with \(self.messages[self.moreMessageInd].fromUser)"
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [initialText], applicationActivities: nil)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.copyToPasteboard
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func report() {
        
        if !CloudKitHelper.instance.isAuthenticated {
            self.tabBarController?.showError(with: "You must be logged in to iCloud in your settings to report a message")
            self.bucketView.close()
            return
        }

        if self.messages[self.moreMessageInd].flaggedUsersList.contains(CloudKitHelper.instance.userId.recordName) {
            // We have already flagged the message
            self.tabBarController?.showError(with: "You have already flagged this message.")
            self.bucketView.close()
        } else {
            self.messages[self.moreMessageInd].flaggedUsersList.append(CloudKitHelper.instance.userId.recordName)
            self.messages[self.moreMessageInd].flags += 1
            CloudKitHelper.instance.flagMessageWithId(self.messages[self.moreMessageInd].id.ckId(), completion: { (error) in
                if let e = error {
                    print(e)
                } else {
                    print("Done flagging")
                }
                DispatchQueue.main.async {
                    self.bucketView.close()
                }
            })
        }
        
    }
}
