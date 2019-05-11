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
    var currentSortOption = SortOption.newest
    
    var moreMessageInd = 0
    
    var bucketView = BucketView(frame: CGRect(), viewHeight: 0, style: 0)
    
    var isUpdate = false
    
    var sortLatest = true
    
    var replyUsername = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        tableView.separatorStyle = .none
        
        self.tableView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 654"), style: .done, target: self, action: #selector(ClubChatVC.filter))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        self.tableView.addRefreshCapability(target: self, selector: #selector(ClubChatVC.refresh))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        CloudKitHelper.instance.getMessagesForClub(self.selectedClub.id, sortOption: self.currentSortOption) { (results, error) in
            if let e = error {
                print(e)
            } else {
                self.messages = results.filter({ !CloudKitHelper.instance.blockedUsers.contains($0.fromUser) })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func refresh() {
        CloudKitHelper.instance.getMessagesForClub(self.selectedClub.id, sortOption: self.currentSortOption) { (results, error) in
            if let e = error {
                print(e)
            } else {
                self.messages = results.filter({ !CloudKitHelper.instance.blockedUsers.contains($0.fromUser) })
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getMessagesSorted(by sortOption: SortOption) {
        if sortOption == .likes && self.currentSortOption != .likes {
            self.currentSortOption = .likes
            CloudKitHelper.instance.getMessagesForClub(self.selectedClub.id, sortOption: .likes) { (results, error) in
                if let e = error {
                    print(e)
                } else {
                    self.messages = results.filter({ !CloudKitHelper.instance.blockedUsers.contains($0.fromUser) })
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        } else if sortOption == .newest && self.currentSortOption != .newest {
            self.currentSortOption = .newest
            CloudKitHelper.instance.getMessagesForClub(self.selectedClub.id, sortOption: .newest) { (results, error) in
                if let e = error {
                    print(e)
                } else {
                    self.messages = results.filter({ !CloudKitHelper.instance.blockedUsers.contains($0.fromUser) })
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let selectedCell = tableView.cellForRow(at: indexPath) as! ResponceTableViewCell
            if let UN = selectedCell.usernameLabel.text {
                replyUsername = UN
            }
            self.selectedMessage = self.messages[indexPath.row - 1]
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "toReply", sender: self)
        }
        //self.selectedMessage = self.messages[indexPath.row - 1]
        //tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "toReply", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell", for:indexPath) as! ChatHeaderTableViewCell
            if let _ = self.selectedClub.imgUrl {
                headerCell.profileImage.image = self.selectedClub.coverImage
            } else {
                headerCell.profileImage.image = UIImage(named: "Group 466")
                
                CloudKitHelper.instance.getClubCoverPhoto(id: self.selectedClub.id) { (image, url, error) in
                    if error == nil {
                        if let img = image {
                            self.selectedClub.coverImage = img
                            DispatchQueue.main.async {
                                headerCell.profileImage.image = img
                            }
                        }
                        if let link = url {
                            self.selectedClub.imgUrl = link
                        }
                    }
                }
            }
            headerCell.profileImage.layer.cornerRadius = 30.0
            headerCell.profileImage.clipsToBounds = true
            headerCell.profileImage.contentMode = .scaleAspectFill
            headerCell.nameLabel.text = self.selectedClub.name
            headerCell.totalMembersLabel.text = "\(self.selectedClub.numFollowers) members"
            
            
            if selectedClub.creatorId == CloudKitHelper.instance.userId.recordName {
                headerCell.followButton.setTitle("Edit Club", for: .normal)
                headerCell.followButton.addTarget(self, action: #selector(ClubChatVC.edit), for: .touchUpInside)
            } else {
                headerCell.followButton.addTarget(self, action: #selector(ClubChatVC.follow(sender:)), for: .touchUpInside)
                if clubIds.contains(self.selectedClub.id) || self.selectedClub.subscribedUsers.contains(CloudKitHelper.instance.userId.recordName){
                    // We follow it already
                    headerCell.followButton.setTitle("Unfollow", for: .normal)
                } else {
                    headerCell.followButton.setTitle("Follow", for: .normal)
                }
            }
            
            headerCell.followButton.clipsToBounds = true
            headerCell.followButton.layer.cornerRadius = 6.0
            
            
            headerCell.listeningToButton.addTarget(self, action: #selector(ClubChatVC.listeningTo), for: .touchUpInside)
            headerCell.moreButton.addTarget(self, action: #selector(ClubChatVC.more), for: .touchUpInside)
            //headerCell.postButton.addTarget(self, action: #selector(ClubChatVC.post), for: .touchUpInside)
            
            headerCell.selectionStyle = .none
            
            return headerCell
        } else {
            let myCell = self.tableView.dequeueReusableCell(withIdentifier: "responceCell", for:indexPath) as! ResponceTableViewCell
            myCell.usersProfileImage.image = UIImage(named: "img1")
            // Get the profile picture
            CloudKitHelper.instance.getProfilePic(for: self.messages[indexPath.row - 1].fromUser) { (img) in
                if let image = img {
                    DispatchQueue.main.async {
                        myCell.usersProfileImage.image = image
                    }
                }
            }
            myCell.usersProfileImage.layer.cornerRadius = 20.0
            myCell.usersProfileImage.clipsToBounds = true
            myCell.usersProfileImage.contentMode = .scaleAspectFill
            myCell.usernameLabel.sizeToFit()
            myCell.usernameLabel.text = self.messages[indexPath.row - 1].fromUsername
            myCell.responcelabel.text = self.messages[indexPath.row - 1].text
            myCell.responcelabel.sizeToFit()
            myCell.responcelabel.numberOfLines = 50
            
            if let likeButton = myCell.viewWithTag(-1) as? UIButton {
                likeButton.setTitle(String(" \(self.messages[indexPath.row - 1].numLikes)"), for: .normal)
                //likeButton.tag = indexPath.row - 1
                
                likeButton.addTarget(self, action: #selector(ClubChatVC.likeMessage(sender:)), for: .touchUpInside)
                
                if self.messages[indexPath.row - 1].likedUsersList.contains(CloudKitHelper.instance.userId.recordName) {
                    // User has already liked message
                    //likeButton.setTitleColor(.red, for: .normal)
                    likeButton.setImage(UIImage(named: "Path 1885"), for: .normal)
                } else {
                    likeButton.setImage(UIImage(named: "Path 1700"), for: .normal)
                }
            }
            
            if let timeLabel = myCell.viewWithTag(-2) as? UILabel {
                let date = self.messages[indexPath.row - 1].creationDate
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
            
            if let moreButton = myCell.viewWithTag(2) as? UIButton {
                moreButton.tag = indexPath.row - 1
                moreButton.addTarget(self, action: #selector(ClubChatVC.moreButtonPressed(sender:)), for: .touchUpInside)
            }
            
//            myCell.contentView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
//            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 8, width: self.view.frame.size.width, height: myCell.contentView.frame.height))
//            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [255.0, 255.0, 255.0, 1.0])
//            whiteRoundedView.layer.masksToBounds = false
//            whiteRoundedView.layer.cornerRadius = 2.0
//            myCell.contentView.addSubview(whiteRoundedView)
//            myCell.contentView.sendSubviewToBack(whiteRoundedView)
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            myCell.selectedBackgroundView = backgroundView
            
            return myCell
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tableView.contentOffset.y > 130 {
            if let navController = navigationController {
                navController.navigationBar.topItem?.title = self.selectedClub.name
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
        
        if let destination = segue.destination as? PrivateClubRequestViewController {
            destination.selectedClub = self.selectedClub
            destination.userIdsList = self.selectedClub.pendingUsersList
        }
        
        
        if segue.identifier == "toSearchPodcast" {
            if let destination = segue.destination as? SearchPodcastsViewController {
                print("to search")
                destination.editingClubPodcast = true
                destination.currentClub = selectedClub
            }
        }
        
        if segue.identifier == "toPost" {
            if let destination = segue.destination as? PostVC {
                destination.isUpdate = isUpdate
                destination.currentClub = selectedClub
            }
        }
        
        if segue.identifier == "toReply" {
            if let destination = segue.destination as? ReplyViewController {
                destination.cellUsername = replyUsername
                destination.selectedMessage = self.selectedMessage
            }
        }
        
    }
    
    
    @objc func likeMessage(sender: UIButton) {
        
        if !CloudKitHelper.instance.isAuthenticated {
            self.tabBarController?.showError(with: "You must be logged in to iCloud in your settings to like a message")
            return
        }
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        if let path = tableView.indexPathForRow(at: buttonPosition) {
            let indexPath = IndexPath(row: path.row - 1, section: path.section)
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
    
    @objc func follow(sender: UIButton){
        
        if !CloudKitHelper.instance.isAuthenticated {
            self.tabBarController?.showError(with: "You must be logged in to iCloud to follow a Club.")
            return
        }
        
        if clubIds.contains(self.selectedClub.id) || self.selectedClub.subscribedUsers.contains(CloudKitHelper.instance.userId.recordName) {
            // We are already subscribed so unsubscribe
            if let ind = clubIds.firstIndex(of: self.selectedClub.id) {
                clubIds.remove(at: ind)
            }
            if let ind = self.selectedClub.subscribedUsers.firstIndex(of: CloudKitHelper.instance.userId.recordName) {
                self.selectedClub.subscribedUsers.remove(at: ind)
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
            self.selectedClub.subscribedUsers.append(CloudKitHelper.instance.userId.recordName)
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
        
        self.bucketView = BucketView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewHeight: 230, style: 1)
        bucketView.frame = UIApplication.shared.keyWindow!.frame
        UIApplication.shared.keyWindow!.addSubview(bucketView)
        
        bucketView.reportButton.addTarget(self, action: #selector(ClubChatVC.report), for: .touchUpInside)
        //bucketView.messageButton.addTarget(self, action: #selector(ClubChatVC.share(sender:)), for: .touchUpInside)
        //bucketView.facebookButton.addTarget(self, action: #selector(ClubChatVC.share(sender:)), for: .touchUpInside)
        //bucketView.twitterButton.addTarget(self, action: #selector(ClubChatVC.share(sender:)), for: .touchUpInside)
        bucketView.shareButton.addTarget(self, action: #selector(ClubChatVC.share(sender:)), for: .touchUpInside)
        bucketView.blockButton.addTarget(self, action: #selector(ClubChatVC.blockUser), for: .touchUpInside)
        
    }
    
    @objc func report(){
        
        if !CloudKitHelper.instance.isAuthenticated {
            self.bucketView.close()
            self.tabBarController?.showError(with: "You must be logged in to iCloud in your settings to report a message")
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
    
    @objc func share(sender: UIButton) {
        self.bucketView.close()
        let initialText = "Come discuss podcasts on Pod Talk. You can chat with \(self.messages[self.moreMessageInd].fromUsername)"
        
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
                self.bucketView.podcastTitle.text = "No Podcast Yet"
                self.bucketView.podcastAuthor.text = "Tell the creator to add one"
            }
        }
        
        bucketView.frame = UIApplication.shared.keyWindow!.frame
        UIApplication.shared.keyWindow!.addSubview(bucketView)
        bucketView.podcastButton.addTarget(self, action: #selector(ClubChatVC.toPodcastDetails), for: .touchUpInside)
        
    }
    
    @objc func more() {
        
        if !CloudKitHelper.instance.isAuthenticated {
            self.tabBarController?.showError(with: "You must be logged in to iCloud to write a post.")
            return
        } else if CloudKitHelper.instance.username == "" {
            self.tabBarController?.showError(with: "You must set your username in the Profile Tab to write a post.")
            return
        }
        
        if selectedClub.creatorId == CloudKitHelper.instance.userId.recordName {
            self.bucketView = BucketView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewHeight: 180, style: 7)
            bucketView.frame = UIApplication.shared.keyWindow!.frame
            UIApplication.shared.keyWindow!.addSubview(bucketView)
            bucketView.postClubButton.addTarget(self, action: #selector(ClubChatVC.postToClub), for: .touchUpInside)
            bucketView.postUpdateButton.addTarget(self, action: #selector(ClubChatVC.postUpdate), for: .touchUpInside)
        } else {
            isUpdate = false
            self.performSegue(withIdentifier: "toPost", sender: self)
        }
        
        
    }
    
    
    @objc func postUpdate(){
        bucketView.close()
        isUpdate = true
        print("POST UPDATE")
        self.performSegue(withIdentifier: "toPost", sender: self)
    }
    
    @objc func postToClub() {
        bucketView.close()
        isUpdate = false
        self.performSegue(withIdentifier: "toPost", sender: self)
    }
    
    @objc func filter(){
        print("FILTER")
        self.bucketView = BucketView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewHeight: 180, style: 2)
        self.bucketView.setCurrentFilterImg(latest: self.sortLatest)
        bucketView.frame = UIApplication.shared.keyWindow!.frame
        UIApplication.shared.keyWindow!.addSubview(bucketView)
        
        bucketView.latestFilterButton.addTarget(self, action: #selector(ClubChatVC.activateFilterNewest), for: .touchUpInside)
        bucketView.likesFilterButton.addTarget(self, action: #selector(ClubChatVC.activateFilterLikes), for: .touchUpInside)
        //bucketView.popularFilterButton.addTarget(self, action: #selector(ClubChatVC.activateFilter), for: .touchUpInside)
        
        
    }
    @objc func activateFilterLikes() {
        self.getMessagesSorted(by: .likes)
        self.sortLatest = false
        self.bucketView.setCurrentFilterImg(latest: false)
        self.bucketView.close()
    }
    
    @objc func activateFilterNewest() {
        self.getMessagesSorted(by: .newest)
        self.sortLatest = true
        self.bucketView.setCurrentFilterImg(latest: true)
        self.bucketView.close()
    }

    @objc func toPodcastDetails() {
        print("To podcast page")
        self.bucketView.close()
        self.performSegue(withIdentifier: "toAlbumDetail", sender: self)
    }
    
    @objc func edit() {
        print("EDIT")
        
        self.bucketView = BucketView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), viewHeight: 280, style: 5)
        bucketView.frame = UIApplication.shared.keyWindow!.frame
        UIApplication.shared.keyWindow!.addSubview(bucketView)
        
        bucketView.changePodcastButton.addTarget(self, action: #selector(ClubChatVC.editPodcast), for: .touchUpInside)
        bucketView.changeImageButton.addTarget(self, action: #selector(ClubChatVC.editImage), for: .touchUpInside)
        bucketView.changeNameButton.addTarget(self, action: #selector(ClubChatVC.editName), for: .touchUpInside)
        bucketView.deleteClubButton.addTarget(self, action: #selector(ClubChatVC.deleteClub), for: .touchUpInside)
    }
    
    @objc func editPodcast() {
        print("editPodcast")
        bucketView.close()
        self.performSegue(withIdentifier: "toSearchPodcast", sender: self)
    }
    
    @objc func editImage() {
        print("editImage")
        self.bucketView.close()
        self.performSegue(withIdentifier: "toClubRequestVC", sender: self)
        
    }
    
    @objc func editName() {
        print("editName")
    }
    
    @objc func deleteClub() {
        
        self.bucketView.close()
        
        let alert = UIAlertController(title: "Delete Club", message: "Are you sure you want to delete this club? This action cannot be undone.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            CloudKitHelper.instance.deleteClub(id: self.selectedClub.id, completion: { (error) in
                if let e = error {
                    print(e)
                }
            })
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func blockUser() {
        
        self.bucketView.close()
        
        if !CloudKitHelper.instance.isAuthenticated {
            self.tabBarController?.showError(with: "You must be logged in to block users!")
            return
        }
        
        if self.messages[self.moreMessageInd].fromUser == CloudKitHelper.instance.userId.recordName {
            self.tabBarController?.showError(with: "You cannot block yourself!")
            return
        }
        
        let alert = UIAlertController(title: "Block user", message: "Are you sure you want to block user '\(self.messages[self.moreMessageInd].fromUsername)'? This action cannot be undone.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (_) in
            CloudKitHelper.instance.blockedUsers.append(self.messages[self.moreMessageInd].fromUser)
            self.messages = self.messages.filter({ !CloudKitHelper.instance.blockedUsers.contains($0.fromUser) })
            self.tableView.reloadData()
            CloudKitHelper.instance.blockUser(id: self.messages[self.moreMessageInd].fromUser, completion: { (error) in
                if let e = error {
                    print(e)
                }
            })
        }
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }

    

    

}
