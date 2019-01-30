//
//  ClubChatVC.swift
//  Cast Club
//
//  Created by Henry Macht on 1/10/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class ClubChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var selectedClub = Club()
    var selectedMessage = Message()
    var messages = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        tableView.separatorStyle = .none
        
        self.tableView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 654"), style: .done, target: self, action: #selector(ClubChatVC.filter))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CloudKitHelper.instance.getMessagesForClub(self.selectedClub.id) { (results, error) in
            if let e = error {
                print(e)
            } else {
                self.messages = results
                // TODO - actually display them, ie. reload table view
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.topItem?.title = "Longer Club Name"
//        //navigationController?.navigationBar.topItem?.titleView?.alpha = 0.4
//        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 0.0)]
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell", for:indexPath) as! ChatHeaderTableViewCell
            headerCell.profileImage.image = self.selectedClub.coverImage
            headerCell.profileImage.layer.cornerRadius = 30.0
            headerCell.profileImage.clipsToBounds = true
            headerCell.nameLabel.text = self.selectedClub.name
            headerCell.totalMembersLabel.text = "\(self.selectedClub.numFollowers) members"
            
            headerCell.followButton.setTitle("Follow", for: .normal)
            headerCell.followButton.clipsToBounds = true
            headerCell.followButton.layer.cornerRadius = 6.0
            headerCell.followButton.addTarget(self, action: #selector(ClubChatVC.follow), for: .touchUpInside)
            
            headerCell.listeningToButton.addTarget(self, action: #selector(ClubChatVC.listeningTo), for: .touchUpInside)
            headerCell.moreButton.addTarget(self, action: #selector(ClubChatVC.more), for: .touchUpInside)
            headerCell.postButton.addTarget(self, action: #selector(ClubChatVC.post), for: .touchUpInside)
            
            headerCell.selectionStyle = .none
            
            return headerCell
        } else {
            let myCell = self.tableView.dequeueReusableCell(withIdentifier: "responceCell", for:indexPath) as! ResponceTableViewCell
            myCell.usersProfileImage.image = UIImage(named: "img1")
            myCell.usersProfileImage.layer.cornerRadius = 20.0
            myCell.usersProfileImage.clipsToBounds = true
            myCell.usernameLabel.sizeToFit()
            myCell.usernameLabel.text = self.messages[indexPath.row - 1].fromUser
            myCell.responcelabel.text = self.messages[indexPath.row - 1].text
            myCell.responcelabel.sizeToFit()
            myCell.responcelabel.numberOfLines = 50
            
            if let likeButton = myCell.viewWithTag(1) as? UIButton {
                likeButton.setTitle(String(" \(self.messages[indexPath.row - 1].numLikes)"), for: .normal)
                likeButton.tag = indexPath.row - 1
                
                likeButton.addTarget(self, action: #selector(ClubChatVC.likeMessage(sender:)), for: .touchUpInside)
                
                if self.messages[indexPath.row - 1].likedUsersList.contains(CloudKitHelper.instance.userId.recordName) {
                    // User has already liked message
                    //likeButton.setTitleColor(.red, for: .normal)
                    likeButton.setImage(UIImage(named: "Path 1885"), for: .normal)
                }
            }
            
            myCell.contentView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
            
            
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 8, width: self.view.frame.size.width, height: myCell.contentView.frame.height))
            
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [255.0, 255.0, 255.0, 1.0])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 2.0
            
            
            myCell.contentView.addSubview(whiteRoundedView)
            myCell.contentView.sendSubviewToBack(whiteRoundedView)
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            myCell.selectedBackgroundView = backgroundView
            
            return myCell
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tableView.contentOffset.y > 60 {
            if let navController = navigationController {
                navController.navigationBar.topItem?.title = "Longer Club Name"
            }
            let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 653"), style: .done, target: self, action: #selector(ClubChatVC.post))
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        } else {
            if let navController = navigationController {
                navController.navigationBar.topItem?.title = ""
            }
            let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 654"), style: .done, target: self, action: #selector(ClubChatVC.filter))
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
            
        }
//        if tableView.contentOffset.y < 100 && tableView.contentOffset.y > 0 {
//            if let navController = navigationController {
//                print(tableView.contentOffset.y / 100)
//                //navController.navigationBar.topItem?.titleView?.alpha = tableView.contentOffset.y / 100
//                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: tableView.contentOffset.y / 100)]
//            }
//
//            if tableView.contentOffset.y < 0{
//                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 0.0)]
//            }
//        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPost" {
            if let destination = segue.destination as? PostVC {
                destination.fromClub = self.selectedClub
                destination.fromMessage = self.selectedMessage
            }
        }
    }
    
    
    @objc func likeMessage(sender: UIButton) {
        let m = self.messages[sender.tag]
        
        
        if m.likedUsersList.contains(CloudKitHelper.instance.userId.recordName) {
            self.messages[sender.tag].numLikes -= 1
            if let ind = self.messages[sender.tag].likedUsersList.firstIndex(of: CloudKitHelper.instance.userId.recordName) {
                self.messages[sender.tag].likedUsersList.remove(at: ind)
            }
            // User has already liked the message
            CloudKitHelper.instance.unlikeMessageWithId(m.id.ckId()) { (error) in
                if let e = error {
                    print(e)
                } else {
                    DispatchQueue.main.async {
                        //sender.setTitleColor(.black, for: .normal)
                        sender.setImage(UIImage(named: "Path 1700"), for: .normal)
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        sender.setTitle(" \(m.numLikes - 1)", for: .normal)
                    }
                }
            }
        } else {
            // Like the message
            self.messages[sender.tag].numLikes += 1
            self.messages[sender.tag].likedUsersList.append(CloudKitHelper.instance.userId.recordName)
            CloudKitHelper.instance.likeMessageWithId(m.id.ckId()) { (error) in
                if let e = error {
                    print(e)
                } else {
                    DispatchQueue.main.async {
                        //sender.setTitleColor(.red, for: .normal)
                        sender.setImage(UIImage(named: "Path 1885"), for: .normal)
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        sender.setTitle(" \(m.numLikes + 1)", for: .normal)
                    }
                }
            }
        }
    }
    
    @objc func follow(){
        print("Now folowing")
    }
    
    @objc func listeningTo(){
        print("listening to")
    }
    
    @objc func more(){
        print("more")
    }
    
    @objc func post(){
        self.performSegue(withIdentifier: "toPost", sender: self)
    }
    
    @objc func filter(){
        print("FILTER")
    }
    

    

}
