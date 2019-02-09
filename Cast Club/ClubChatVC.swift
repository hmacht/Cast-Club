//
//  ClubChatVC.swift
//  Cast Club
//
//  Created by Henry Macht on 1/10/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit
import Social

class ClubChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    let screenSize = UIScreen.main.bounds
    
    var selectedClub = Club()
    var selectedMessage = Message()
    var messages = [Message]()
    
    var moreMessageInd = 0
    
    var bucketView = BucketView(frame: CGRect(), viewHeight: 0, style: 0)
    
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
        CloudKitHelper.instance.getMessagesForClub(self.selectedClub.id, sortOption: .likes) { (results, error) in
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
            headerCell.profileImage.contentMode = .scaleAspectFill
            headerCell.nameLabel.text = self.selectedClub.name
            headerCell.totalMembersLabel.text = "\(self.selectedClub.numFollowers) members"
            
            if clubIds.contains(self.selectedClub.id) {
                // We follow it already
                headerCell.followButton.setTitle("Unfollow", for: .normal)
            } else {
                headerCell.followButton.setTitle("Follow", for: .normal)
            }
            headerCell.followButton.clipsToBounds = true
            headerCell.followButton.layer.cornerRadius = 6.0
            headerCell.followButton.addTarget(self, action: #selector(ClubChatVC.follow(sender:)), for: .touchUpInside)
            
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
            myCell.usersProfileImage.contentMode = .scaleAspectFill
            myCell.usernameLabel.sizeToFit()
            myCell.usernameLabel.text = self.messages[indexPath.row - 1].fromUser
            myCell.responcelabel.text = self.messages[indexPath.row - 1].text
            myCell.responcelabel.sizeToFit()
            myCell.responcelabel.numberOfLines = 50
            
            if let likeButton = myCell.viewWithTag(-1) as? UIButton {
                likeButton.setTitle(String(" \(self.messages[indexPath.row - 1].numLikes)"), for: .normal)
                likeButton.tag = indexPath.row - 1
                
                likeButton.addTarget(self, action: #selector(ClubChatVC.likeMessage(sender:)), for: .touchUpInside)
                
                if self.messages[indexPath.row - 1].likedUsersList.contains(CloudKitHelper.instance.userId.recordName) {
                    // User has already liked message
                    //likeButton.setTitleColor(.red, for: .normal)
                    likeButton.setImage(UIImage(named: "Path 1885"), for: .normal)
                }
            }
            
            if let moreButton = myCell.viewWithTag(2) as? UIButton {
                moreButton.tag = indexPath.row - 1
                moreButton.addTarget(self, action: #selector(ClubChatVC.moreButtonPressed(sender:)), for: .touchUpInside)
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
        
        if tableView.contentOffset.y > 130 {
            if let navController = navigationController {
                navController.navigationBar.topItem?.title = "Longer Club Name"
            }
            let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 734"), style: .done, target: self, action: #selector(ClubChatVC.more))
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
        if let destination = segue.destination as? AlbumViewController {
            if let album = self.selectedClub.currentAlbum {
                destination.album = album
            }
        }
    }
    
    
    @objc func likeMessage(sender: UIButton) {
        
        
        let m = self.messages[sender.tag]
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        sender.setTitle(" \(m.numLikes - 1)", for: .normal)
        sender.setImage(UIImage(named: "Path 1700"), for: .normal)
        
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
                    }
                }
            }
        } else {
            // Like the message
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            sender.setTitle(" \(m.numLikes + 1)", for: .normal)
            sender.setImage(UIImage(named: "Path 1885"), for: .normal)
            
            self.messages[sender.tag].numLikes += 1
            self.messages[sender.tag].likedUsersList.append(CloudKitHelper.instance.userId.recordName)
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
    
    @objc func follow(sender: UIButton){
        if clubIds.contains(self.selectedClub.id) {
            // We are already subscribed so unsubscribe
            if let ind = clubIds.firstIndex(of: self.selectedClub.id) {
                clubIds.remove(at: ind)
            }
            CloudKitHelper.instance.unsubscribeFromClub(id: self.selectedClub.id) { (error) in
                if let e = error {
                    print(e)
                } else {
                    self.selectedClub.numFollowers -= 1
                    DispatchQueue.main.async {
                        sender.setTitle("Follow", for: .normal)
                        
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ChatHeaderTableViewCell {
                            cell.totalMembersLabel.text = "\(self.selectedClub.numFollowers) members"
                        }
                    }
                }
            }
        } else {
            // Subscribe to club
            clubIds.append(self.selectedClub.id)
            CloudKitHelper.instance.subscribeToClub(id: self.selectedClub.id.ckId()) { (error) in
                if let e = error {
                    print(e)
                } else {
                    self.selectedClub.numFollowers += 1
                    
                    // Tell clubvc that we have a new club to display
                    if let navController = self.tabBarController?.customizableViewControllers?[2] as? UINavigationController {
                        if let clubVC = navController.topViewController as? ClubVC {
                            clubVC.clubs.append(self.selectedClub)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        sender.setTitle("Unfollow", for: .normal)
                        
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ChatHeaderTableViewCell {
                            cell.totalMembersLabel.text = "\(self.selectedClub.numFollowers) members"
                        }
                    }
                }
            }
        }
    }
    
    @objc func moreButtonPressed(sender: UIButton) {
        
        self.moreMessageInd = sender.tag
        
        self.bucketView = BucketView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewHeight: 180, style: 1)
        bucketView.frame = UIApplication.shared.keyWindow!.frame
        UIApplication.shared.keyWindow!.addSubview(bucketView)
        
        bucketView.reportButton.addTarget(self, action: #selector(ClubChatVC.report), for: .touchUpInside)
        //bucketView.messageButton.addTarget(self, action: #selector(ClubChatVC.share(sender:)), for: .touchUpInside)
        //bucketView.facebookButton.addTarget(self, action: #selector(ClubChatVC.share(sender:)), for: .touchUpInside)
        //bucketView.twitterButton.addTarget(self, action: #selector(ClubChatVC.share(sender:)), for: .touchUpInside)
        bucketView.shareButton.addTarget(self, action: #selector(ClubChatVC.share(sender:)), for: .touchUpInside)
        
    }
    
    @objc func report(){
        print("REPORT")
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
    
    @objc func share(sender: UIButton) {
        self.bucketView.close()
        let initialText = "Come discuss podcasts on Podtalk. You can chat with \(self.messages[self.moreMessageInd].fromUser)"
        
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
    
    @objc func listeningTo(){
        
        self.bucketView = BucketView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewHeight: 330, style: 4)
        if self.selectedClub.update == "" {
            self.bucketView.updateMessageLabel.text = "The club creator has not sent out an update."
        } else {
            self.bucketView.updateMessageLabel.text = self.selectedClub.update
        }
        self.bucketView.podcastButton.isUserInteractionEnabled = false
        
        if let album = self.selectedClub.currentAlbum {
                // We have already retrieved the album
            if let img = self.selectedClub.currentAlbum?.artworkImage {
                self.bucketView.podcastButton.setImage(img, for: .normal)
            } else {
                DispatchQueue.global(qos: .background).async {
                    _ = album.getImageData(dimensions: .hundred, completion: { (image) in
                        if let img = image {
                            self.selectedClub.currentAlbum?.artworkImage = img
                            DispatchQueue.main.async {
                                self.bucketView.podcastButton.setImage(img, for: .normal)
                            }
                        }
                    })
                }
            }
            
            self.bucketView.podcastButton.isUserInteractionEnabled = true
            self.bucketView.podcastTitle.text = album.title
            self.bucketView.podcastAuthor.text = album.artistName
        } else {
            if self.selectedClub.currentAlbumId != "" {
                // Obtain the album
                CloudKitHelper.instance.getAlbum(id: self.selectedClub.currentAlbumId) { (podcastAlbum, error) in
                    if let e = error {
                        print(e)
                    } else {
                        if let album = podcastAlbum {
                            self.selectedClub.currentAlbum = album
                            if let img = self.selectedClub.currentAlbum?.artworkImage {
                                DispatchQueue.main.async {
                                    self.bucketView.podcastButton.setImage(img, for: .normal)
                                }
                            } else {
                                DispatchQueue.global(qos: .background).async {
                                    _ = album.getImageData(dimensions: .hundred, completion: { (image) in
                                        if let img = image {
                                            self.selectedClub.currentAlbum?.artworkImage = img
                                            DispatchQueue.main.async {
                                                self.bucketView.podcastButton.setImage(img, for: .normal)
                                            }
                                        }
                                    })
                                }
                            }
                            DispatchQueue.main.async {
                                self.bucketView.podcastButton.isUserInteractionEnabled = true
                                self.bucketView.podcastTitle.text = album.title
                                self.bucketView.podcastAuthor.text = album.artistName
                            }
                        }
                    }
                }
            } else {
                self.bucketView.podcastTitle.text = "This club hasn't started listening to any podcasts yet."
                self.bucketView.podcastAuthor.text = ""
            }
        }
        
        bucketView.frame = UIApplication.shared.keyWindow!.frame
        UIApplication.shared.keyWindow!.addSubview(bucketView)
        bucketView.podcastButton.addTarget(self, action: #selector(ClubChatVC.toPodcastDetails), for: .touchUpInside)
        
    }
    
    @objc func more(){
        print("more")
        self.performSegue(withIdentifier: "toPost", sender: self)
    }
    
    @objc func post(){
        //self.performSegue(withIdentifier: "toPost", sender: self)
    }
    
    @objc func filter(){
        print("FILTER")
        self.bucketView = BucketView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewHeight: 230, style: 2)
        bucketView.frame = UIApplication.shared.keyWindow!.frame
        UIApplication.shared.keyWindow!.addSubview(bucketView)
        
        bucketView.latestFilterButton.addTarget(self, action: #selector(ClubChatVC.activateFilter), for: .touchUpInside)
        bucketView.likesFilterButton.addTarget(self, action: #selector(ClubChatVC.activateFilter), for: .touchUpInside)
        bucketView.popularFilterButton.addTarget(self, action: #selector(ClubChatVC.activateFilter), for: .touchUpInside)
        
        
    }
    @objc func activateFilter() {
        print("Filtering")
    }

    @objc func toPodcastDetails() {
        print("To podcast page")
        self.bucketView.close()
        self.performSegue(withIdentifier: "toAlbumDetail", sender: self)
    }


    

    

}
