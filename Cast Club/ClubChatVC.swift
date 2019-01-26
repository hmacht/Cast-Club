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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        tableView.separatorStyle = .none
        
        self.tableView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell", for:indexPath) as! ChatHeaderTableViewCell
            headerCell.profileImage.image = UIImage(named: "img1")
            headerCell.profileImage.layer.cornerRadius = 30.0
            headerCell.profileImage.clipsToBounds = true
            headerCell.nameLabel.text = "Clubs Name!"
            headerCell.totalMembersLabel.text = "450 members"
            
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
            myCell.usernameLabel.text = "Username"
            myCell.responcelabel.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt"
            myCell.responcelabel.sizeToFit()
            myCell.responcelabel.numberOfLines = 50
            
            myCell.contentView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 8, width: self.view.frame.size.width, height: 149))
            
            
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
    

    

}
