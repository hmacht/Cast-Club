//
//  SecondViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 11/20/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import CloudKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    

    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var catagoryTableView: UITableView!
    
    var results = [Club]()
    var topClubs = [Club]()
    var activityIndicator = UIActivityIndicatorView()
    var viewDidLayoutSubviewsForTheFirstTime = true
    let screenSize = UIScreen.main.bounds
    
    var selectedCategoryIndex = 0
    
    var headTitle = ""
    
    var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var selectedClub = Club()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set delagates
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.catagoryTableView.delegate = self
        self.catagoryTableView.dataSource = self
        
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
        
        // Create the activity indicator
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        self.activityIndicator.frame = CGRect(x: self.view.frame.width/2 - 20, y: self.view.frame.height/2 - 20, width: 40, height: 40)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
        self.view.addSubview(self.activityIndicator)
        
        //self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        catagoryTableView.keyboardDismissMode = .onDrag
        
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search for a club"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        searchBar.tintColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        self.navigationItem.titleView = searchBar
    
        // Need to fix resizing
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
//            flowLayout.estimatedItemSize = CGSize(width: 100, height: 50)
//
//        }

        
        viewDidLayoutSubviewsForTheFirstTime = true
        
        //self.retrieveTopClubs()
        
        extendedLayoutIncludesOpaqueBars = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let yourBackImage = UIImage(named: "Group 29")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        
        self.tabBarController?.hideNoResultsLabel()
    }
    func retrieveTopClubs() {
        // Gets called one by one for each club
        // Can reload after each club comes in
        // And perform animation to each new cell
        //CloudKitHelper.instance.getTopClubs(n: 3) { (club) in
       //     self.topClubs.append(club)
        //}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Only scroll when the view is rendered for the first time
        if viewDidLayoutSubviewsForTheFirstTime {
            
            
            viewDidLayoutSubviewsForTheFirstTime = false
            // Calling collectionViewContentSize forces the UICollectionViewLayout to actually render the layout
            //collectionView.collectionViewLayout.collectionViewContentSize
            // Now you can scroll to your desired indexPath or contentOffset
            //collectionView.scrollToItem(at: IndexPath.init(row: 2, section: 0), at: .centeredVertically, animated: false)
            
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return testList.count
//    }
    
    var testList = ["Most Popular", "Everything", "News", "Culture", "Comedy", "Education", "Art", "Business", "Politics", "Kids", "Music", "TV & Film", "Technology", "Sports", "Health", "Games & Hobbies"]
    
    var catagoryIcons: [UIImage] = [UIImage(named: "Path 1914")!, UIImage(named: "Path 1954")!, UIImage(named: "Path 1907")!, UIImage(named: "Path 1930")!, UIImage(named: "Group 661")!, UIImage(named: "Path 1945")!, UIImage(named: "Path 1935")!, UIImage(named: "Group 660")!, UIImage(named: "Path 1955")!, UIImage(named: "Group 663")!, UIImage(named: "Path 1943")!, UIImage(named: "Path 1927")!, UIImage(named: "Group 662")!, UIImage(named: "Group 658")!, UIImage(named: "Path 1932")!, UIImage(named: "Path 1950")!]
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catagoryCell", for: indexPath) as! CatagoryCollectionViewCell
//
//
//        cell.catagoryButton.setTitle(testList[indexPath.row], for: .normal)
//
//        cell.catagoryButton.clipsToBounds = true
//        cell.catagoryButton.layer.cornerRadius = 17.5
//
//        cell.catagoryButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 13)
//
//        if indexPath.row == self.selectedCategoryIndex {
//            cell.catagoryButton.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
//            cell.catagoryButton.setTitleColor(.white, for: .normal)
//            cell.catagoryButton.isUserInteractionEnabled = false
//        } else {
//            cell.catagoryButton.setTitleColor(UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0), for: .normal)
//            cell.catagoryButton.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
//            cell.catagoryButton.isUserInteractionEnabled = false
//        }
//
//
//
//
//
//        return cell
//
//    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell0 = UITableViewCell()
        if tableView.tag == 2 {
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
                            club.coverImage = img
                            imgView.image = img
                        }
                    }
                }
                imgView.layer.cornerRadius = 25
                imgView.clipsToBounds = true
                imgView.contentMode = .scaleAspectFill
            }
            
            if let addButton = cell.viewWithTag(4) as? UIButton {
                if club.subscribedUsers.contains(CloudKitHelper.instance.userId.recordName) {
                    // We are already subscribed to club
                    addButton.setImage(UIImage(named: "Group 463"), for: .normal)
                } else if club.isPublic {
                    addButton.clipsToBounds = true
                    addButton.layer.cornerRadius = 15
                    addButton.layer.borderWidth = 1
                    addButton.layer.borderColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
                } else {
                    addButton.setImage(UIImage(named: "Group 845"), for: .normal)
                }
                
                addButton.tag = indexPath.row
                addButton.addTarget(self, action: #selector(SecondViewController.addClub), for: .touchUpInside)
            }
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            cell.selectedBackgroundView = backgroundView
            
            cell0 = cell
            
        } else if tableView.tag == 1{
            if indexPath.row == 0 {
                let headerCell = self.catagoryTableView.dequeueReusableCell(withIdentifier: "headerCell", for:indexPath) as! UITableViewCell
                
                if let clubsNamelab = headerCell.viewWithTag(1) as? UILabel {
                    clubsNamelab.text = "Most Popular"
                    clubsNamelab.font = UIFont(name: "Avenir-Black", size: 20)
                    clubsNamelab.textColor = UIColor(red: 252.0/255.0, green: 240.0/255.0, blue: 228.0/255.0, alpha: 1.0)
                }
                
                if let headerImage = headerCell.viewWithTag(2) as? UIImageView {
                    headerImage.image = UIImage(named: "pablo-upgrade")
                    headerImage.layer.cornerRadius = 6.0
                    headerImage.clipsToBounds = true
                    headerImage.contentMode = .scaleAspectFill
                    
                }
                
                headerCell.selectionStyle = .none
                
                cell0 = headerCell
                
            } else {
                let cell2 = self.catagoryTableView.dequeueReusableCell(withIdentifier: "catagoryCell") as! UITableViewCell
                
                if let catagoryLabel = cell2.viewWithTag(2) as? UILabel {
                    catagoryLabel.text = testList[indexPath.row]
                }
                
                if let catagoryImage = cell2.viewWithTag(1) as? UIImageView {
                    catagoryImage.image = catagoryIcons[indexPath.row]
                }
                
                
                cell0 = cell2
            }
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        cell0.selectedBackgroundView = backgroundView
        
        return cell0
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 2{
            return results.count
        } else if tableView.tag == 1{
            return testList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 2{
            return 70
        } else if tableView.tag == 1{
            if indexPath.row > 0{
                return 50
            } else {
                return 220
            }
            
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 2 {
            tableView.deselectRow(at: indexPath, animated: true)
            if self.results[indexPath.row].isPublic || clubIds.contains(self.results[indexPath.row].id) || self.results[indexPath.row].subscribedUsers.contains(CloudKitHelper.instance.userId.recordName) {
                self.selectedClub = self.results[indexPath.row]
                self.performSegue(withIdentifier: "fromSecondVCToChat", sender: self)
            } else if !CloudKitHelper.instance.isAuthenticated {
                // User not logged in
                self.tabBarController?.showError(with: "This club is private. Once you log in you can request to join this club.")
            } else if self.results[indexPath.row].pendingUsersList.contains(CloudKitHelper.instance.userId.recordName) {
                self.tabBarController?.showError(with: "You have already sent a request to join this club.")
            } else {
                // Club is private
                let alert = UIAlertController(title: "Private Club", message: "This is a private club. Do you want to request to join this club?", preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                    self.results[indexPath.row].pendingUsersList.append(CloudKitHelper.instance.userId.recordName)
                    CloudKitHelper.instance.requestPrivateClubJoin(clubId: self.results[indexPath.row].id, completion: { (error) in
                        if let e = error {
                            print(e)
                            self.tabBarController?.showError(with: e.localizedDescription)
                        }
                    })
                }
                
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                self.present(alert, animated: true)
            }
        } else if tableView.tag == 1 {
            catagoryTableView.deselectRow(at: indexPath, animated: true)
            print(testList[indexPath.row])
            headTitle = testList[indexPath.row]
            self.performSegue(withIdentifier: "toCatagoryList", sender: self)
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
        self.results = []
        self.tableView.reloadData()
        
        // Show activity
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        if let searchText = self.searchBar.text {
            if let category = ClubCategory(rawValue: self.testList[self.selectedCategoryIndex]) {
                CloudKitHelper.instance.searchClubsWithName(searchText, category: category) { (recs) in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    if let records = recs {
                        self.results = records
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            if self.results.count == 0 {
                                self.tabBarController?.showNoResultsLabel(message: "No clubs matched your search. Check your spelling and try again.")
                            }
                        }
                    }
                }
            } else {
                CloudKitHelper.instance.searchClubsWithName(searchText) { (recs) in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    if let records = recs {
                        self.results = records
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            if self.results.count == 0 {
                                self.tabBarController?.showNoResultsLabel(message: "No clubs matched your search. Check your spelling and try again.")
                            }
                        }
                    }
                }
            }
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if let cell = self.collectionView.cellForItem(at: indexPath) as? CatagoryCollectionViewCell {
//            cell.catagoryButton.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
//            cell.catagoryButton.setTitleColor(.white, for: .normal)
//        }
//        if let currentCell = self.collectionView.cellForItem(at: IndexPath(row: self.selectedCategoryIndex, section: 0)) as? CatagoryCollectionViewCell {
//            currentCell.catagoryButton.setTitleColor(UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0), for: .normal)
//            currentCell.catagoryButton.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
//        }
//
//        self.selectedCategoryIndex = indexPath.row
//    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
        
        catagoryTableView.isHidden = true
        tableView.isHidden = false
        
        self.tabBarController?.hideNoResultsLabel()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.searchBar.setShowsCancelButton(false, animated: true)
        
        catagoryTableView.isHidden = false
        tableView.isHidden = true
        
        self.tabBarController?.hideNoResultsLabel()
    }
    
    
    @objc func addClub(sender: UIButton){
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let tag = sender.tag
        // If private
        if !self.results[sender.tag].isPublic {
            /*if let tabController = self.tabBarController as? PodcastTablBarController {
                tabController.showError(with: ErrorMessage.privateClub.rawValue)
            }*/
        } else {
            if clubIds.contains(self.results[sender.tag].id) || self.results[sender.tag].subscribedUsers.contains(CloudKitHelper.instance.userId.recordName){
                // Already subscribed
                self.tabBarController?.showError(with: "You are already subscribed to this club.")
            } else {

                sender.setImage(UIImage(named: "Group 463"), for: .normal)
                sender.backgroundColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 240.0/255.0, alpha: 1.0)
                
                CloudKitHelper.instance.subscribeToClub(id: CKRecord.ID(recordName: self.results[sender.tag].id)) { (error) in
                    if let e = error {
                        if let tabController = self.tabBarController as? PodcastTablBarController {
                            tabController.showError(with: e.localizedDescription)
                        }
                    } else {
                        
                        clubIds.append(self.results[tag].id)
                        self.results[tag].subscribedUsers.append(CloudKitHelper.instance.userId.recordName)
                        // Tell clubvc that we have a new club to display
                        if let navController = self.tabBarController?.customizableViewControllers?[2] as? UINavigationController {
                            if let clubVC = navController.topViewController as? ClubVC {
                                clubVC.clubs.append(self.results[tag])
                            }
                        }
                        print("successfully saved")
                        
                        
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is catagoryVC
        {
            let vc = segue.destination as? catagoryVC
            vc?.newCat = true
            vc?.headerTitleText = headTitle
            
        }
        
        if let dest = segue.destination as? ClubChatVC {
            dest.selectedClub = self.selectedClub
        }
    }

}


