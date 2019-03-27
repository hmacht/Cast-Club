//
//  catagoryVC.swift
//  Cast Club
//
//  Created by Henry Macht on 1/30/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class catagoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var headerTitleText = String()
    var newCat = false
    var selectedCategory = ClubCategory.none
    
    var results = [Club]()
    var selectedClub = Club()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        extendedLayoutIncludesOpaqueBars = true
        
        

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -(screenSize.height/45)).isActive = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.headerTitleText != "Most Popular" {
            if let cat = ClubCategory(rawValue: self.headerTitleText) {
                self.selectedCategory = cat
            }
        }
        if self.newCat {
            self.retrieveTopClubs()
        }
        
    }
    
    func retrieveTopClubs() {
        self.newCat = false
        self.tabBarController?.showActivity()
        CloudKitHelper.instance.getTopClubs(n: 20, category: self.selectedCategory) { (club) in
            self.results.append(club)
            DispatchQueue.main.async {
                self.tabBarController?.stopActivity()
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell", for:indexPath) as! UITableViewCell
            
            if let headerTitle = headerCell.viewWithTag(1) as? UILabel {
                headerTitle.text = headerTitleText
            }
            headerCell.selectionStyle = .none
            headerCell.isUserInteractionEnabled = false
            return headerCell
            
            
        } else {
            let myCell = self.tableView.dequeueReusableCell(withIdentifier: "clubCells", for:indexPath) as! UITableViewCell
            
            if let imgView = myCell.viewWithTag(3) as? UIImageView {
                imgView.image = self.results[indexPath.row - 1].coverImage
                imgView.clipsToBounds = true
                imgView.layer.cornerRadius = 37.0/2.0
                imgView.contentMode = .scaleAspectFill
            }
            
            if let nameLabel = myCell.viewWithTag(4) as? UILabel {
                nameLabel.text = self.results[indexPath.row - 1].name
            }
            
            if let numFollowersLabel = myCell.viewWithTag(5) as? UILabel {
                numFollowersLabel.text = "\(self.results[indexPath.row - 1].numFollowers) members"
            }
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            myCell.selectedBackgroundView = backgroundView
            
            return myCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if !self.results[indexPath.row - 1].isPublic && !clubIds.contains(self.results[indexPath.row - 1].id) {
            if !CloudKitHelper.instance.isAuthenticated {
                // User not logged in
                self.tabBarController?.showError(with: "This club is private. Once you log in you can request to join this club.")
            } else if self.results[indexPath.row - 1].pendingUsersList.contains(CloudKitHelper.instance.userId.recordName) {
                self.tabBarController?.showError(with: "You have already sent a request to join this club.")
            } else {
                // Club is private
                let alert = UIAlertController(title: "Private Club", message: "This is a private club. Do you want to request to join this club?", preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                    self.results[indexPath.row - 1].pendingUsersList.append(CloudKitHelper.instance.userId.recordName)
                    CloudKitHelper.instance.requestPrivateClubJoin(clubId: self.results[indexPath.row - 1].id, completion: { (error) in
                        if let e = error {
                            print(e)
                        }
                    })
                }
                
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                self.present(alert, animated: true)
            }
        } else {
            self.selectedClub = self.results[indexPath.row - 1]
            self.performSegue(withIdentifier: "fromCatagoryToChat", sender: self)
        }
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let dest = segue.destination as? ClubChatVC {
            dest.selectedClub = self.selectedClub
        }
    }
 

}
