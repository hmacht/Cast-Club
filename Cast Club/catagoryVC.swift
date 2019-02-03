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
    var selectedCategory = ClubCategory.everything
    
    var results = [Club]()
    
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
        
        self.retrieveTopClubs()
        
    }
    
    func retrieveTopClubs() {
        CloudKitHelper.instance.getTopClubs(n: 5, category: self.selectedCategory) { (club) in
            self.results.append(club)
            DispatchQueue.main.async {
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
            
            return headerCell
            
            
        } else {
            let myCell = self.tableView.dequeueReusableCell(withIdentifier: "clubCells", for:indexPath) as! UITableViewCell
            
            if let imgView = myCell.viewWithTag(3) as? UIImageView {
                imgView.image = self.results[indexPath.row - 1].coverImage
            }
            
            if let nameLabel = myCell.viewWithTag(4) as? UILabel {
                nameLabel.text = self.results[indexPath.row - 1].name
            }
            
            if let numFollowersLabel = myCell.viewWithTag(5) as? UILabel {
                numFollowersLabel.text = "\(self.results[indexPath.row - 1].numFollowers) members"
            }
            
            return myCell
        }
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
