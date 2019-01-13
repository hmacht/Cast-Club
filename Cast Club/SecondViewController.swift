//
//  SecondViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 11/20/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var results = [Club]()
    var activityIndicator = UIActivityIndicatorView()
    var viewDidLayoutSubviewsForTheFirstTime = true
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set delagates
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Create the activity indicator
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        self.activityIndicator.frame = CGRect(x: self.view.frame.width/2 - 20, y: self.view.frame.height/2 - 20, width: 40, height: 40)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
        self.view.addSubview(self.activityIndicator)
        
        //self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.keyboardDismissMode = .onDrag
        
    
        // Need to fix resizing
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.estimatedItemSize = CGSize(width: 100, height: 50)
            
        }
        
        
        
        
        
        
        viewDidLayoutSubviewsForTheFirstTime = true
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Only scroll when the view is rendered for the first time
        if viewDidLayoutSubviewsForTheFirstTime {
            
            
            viewDidLayoutSubviewsForTheFirstTime = false
            // Calling collectionViewContentSize forces the UICollectionViewLayout to actually render the layout
            collectionView.collectionViewLayout.collectionViewContentSize
            // Now you can scroll to your desired indexPath or contentOffset
            //collectionView.scrollToItem(at: IndexPath.init(row: 2, section: 0), at: .centeredVertically, animated: false)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testList.count
    }
    
    var testList = ["Everything", "News", "Comedy", "Arts", "Business", "Education", "Games & Hobbies", "Health", "Kids", "Music", "Science", "Sports", "TV & Film", "Technology"]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catagoryCell", for: indexPath) as! CatagoryCollectionViewCell
        
//        cell.catagoryLabel.text = testList[indexPath.row]
//        cell.catagoryLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
//        cell.catagoryLabel.clipsToBounds = true
//        cell.catagoryLabel.layer.cornerRadius = 10
//        cell.catagoryLabel.textColor = .white
//        cell.catagoryLabel.sizeToFit()
//        cell.catagoryLabel.isHidden = true
        
        
        cell.catagoryButton.setTitle(testList[indexPath.row], for: .normal)
        cell.catagoryButton.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        cell.catagoryButton.titleLabel?.textColor = .white
        cell.catagoryButton.clipsToBounds = true
        cell.catagoryButton.layer.cornerRadius = 17.5
        
        cell.catagoryButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 13)
        
        
        
        
        
        return cell
        
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
            imgView.layer.cornerRadius = 25
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFill
        }
        
        if let addButton = cell.viewWithTag(4) as? UIButton {
            addButton.clipsToBounds = true
            addButton.layer.cornerRadius = 15
            addButton.layer.borderWidth = 1
            addButton.layer.borderColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
            addButton.addTarget(self, action: #selector(SecondViewController.addClub), for: .touchUpInside)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        //self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    @objc func addClub(){
        print("ADD")
    }

}

