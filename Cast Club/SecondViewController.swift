//
//  SecondViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 11/20/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var results = [Club]()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set delagates
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Create the activity indicator
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        self.activityIndicator.frame = CGRect(x: self.view.frame.width/2 - 20, y: self.view.frame.height/2 - 20, width: 40, height: 40)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
        self.view.addSubview(self.activityIndicator)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BasicCell") as! UITableViewCell
        let club = self.results[indexPath.row]
        
        if let titleLabel = cell.viewWithTag(1) as? UILabel {
            titleLabel.text = club.name
        }
        
        if let followersLabel = cell.viewWithTag(2) as? UILabel {
            followersLabel.text = "\(club.numFollowers) followers"
        }
        
        if let imgView = cell.viewWithTag(3) as? UIImageView {
            imgView.image = UIImage(named: "Group 224")
            DispatchQueue.global(qos: .background).async {
                if let img = club.imgUrl?.image() {
                    DispatchQueue.main.async {
                        imgView.image = img
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.results = []
        self.tableView.reloadData()
        
        // Show activity
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        if let searchText = self.searchBar.text {
            CloudKitHelper.instance.searchClubsWithName(searchText) { (recs) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                if let records = recs {
                    self.results = records
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            self.activityIndicator.stopAnimating()
        }
    }

}

