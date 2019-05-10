//
//  PrivateClubRequestViewController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 4/21/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class PrivateClubRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userIdsList = [String]()
    var selectedClub = Club()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Pending Users"
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userIdsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        if let imgView = cell.viewWithTag(1) as? UIImageView {
            // Place holder image
            imgView.image = UIImage(named: "AppIcon")
            imgView.clipsToBounds = true
            imgView.layer.cornerRadius = 40
            imgView.contentMode = .scaleAspectFill
            // Get profile picture
            CloudKitHelper.instance.getProfilePic(for: self.userIdsList[indexPath.row]) { (image) in
                if let img = image {
                    DispatchQueue.main.async {
                        imgView.image = img
                    }
                }
            }
        }
        
        if let usernameLabel = cell.viewWithTag(2) as? UILabel {
            usernameLabel.text = " "
            CloudKitHelper.instance.getUsername(for: self.userIdsList[indexPath.row]) { (username) in
                if let name = username {
                    DispatchQueue.main.async {
                        usernameLabel.text = name
                    }
                }
            }
        }
        
        if let acceptButton = cell.viewWithTag(3) as? UIButton {
            acceptButton.setTitleColor(.white, for: .normal)
            acceptButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14)
            acceptButton.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
            acceptButton.layer.cornerRadius = 6
            
            acceptButton.addTarget(self, action: #selector(PrivateClubRequestViewController.acceptUser(sender:)), for: .touchUpInside)
        }
        
        if let declineButton = cell.viewWithTag(4) as? UIButton {
            declineButton.setTitleColor(UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0), for: .normal)
            declineButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14)
            
            declineButton.backgroundColor = .white
            declineButton.layer.borderColor = UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1.0).cgColor
            declineButton.layer.borderWidth = 1.0
            declineButton.layer.cornerRadius = 6
            
            declineButton.addTarget(self, action: #selector(PrivateClubRequestViewController.declineUser(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func acceptUser(sender: UIButton) {
        
        let pos = sender.convert(CGPoint.zero, to: self.tableView)
        if let row = self.tableView.indexPathForRow(at: pos)?.row {
            CloudKitHelper.instance.updateUserRequestToPrivateClub(accepted: true, clubId: self.selectedClub.id, userId: self.userIdsList[row]) { (error) in
                if let e = error {
                    print(e)
                } else {
                    self.removeUserFromPendingList(self.userIdsList[row])
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("Done accepting")
                }
            }
        }
    }
    
    @objc func declineUser(sender: UIButton) {
        
        let pos = sender.convert(CGPoint.zero, to: self.tableView)
        if let row = self.tableView.indexPathForRow(at: pos)?.row {
            CloudKitHelper.instance.updateUserRequestToPrivateClub(accepted: false, clubId: self.selectedClub.id, userId: self.userIdsList[row]) { (error) in
                if let e = error {
                    print(e)
                } else {
                    self.removeUserFromPendingList(self.userIdsList[row])
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("Done declining")
                }
            }
        }
    }
    
    func removeUserFromPendingList(_ user: String) {
        // Remove from club list
        if let ind = self.selectedClub.pendingUsersList.firstIndex(of: user) {
            self.selectedClub.pendingUsersList.remove(at: ind)
        }
        // Remove from table view list
        if let ind = self.userIdsList.firstIndex(of: user) {
            self.userIdsList.remove(at: ind)
            // Animate dismiss
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [IndexPath(row: ind, section: 0)], with: UITableView.RowAnimation.left)
            }
        }
        
    }
}
