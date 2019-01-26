//
//  ClubVC.swift
//  Cast Club
//
//  Created by Henry Macht on 12/30/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class ClubVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var clubTabelView: UITableView!
    
    var userIds = [String]()
    var clubs = [Club?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clubTabelView.delegate = self
        self.clubTabelView.dataSource = self
        
        clubTabelView.tableFooterView = UIView()
        //self.clubTabelView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //clubTabelView.layoutMargins = UIEdgeInsets.zero
        //clubTabelView.separatorInset = UIEdgeInsets.zero
        
        self.clubTabelView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        //self.view.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Podcast Clubs"
        let yourBackImage = UIImage(named: "Group 29")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 32"), style: .done, target: self, action: #selector(ClubVC.add))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 257"), style: .done, target: self, action: #selector(ClubVC.playlist))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        CloudKitHelper.instance.getClubIdsForCurrentUser { (ids, error) in
            if let e = error {
                print(e)
            } else {
                self.userIds = ids
                for _ in 1...self.userIds.count {
                    self.clubs.append(nil)
                }
                print("Got ids", self.userIds)
                
                DispatchQueue.main.async {
                    self.clubTabelView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userIds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    // Test Material
    var images = [UIImage(named: "Group 439"), UIImage(named: "img1"), UIImage(named: "img3"), UIImage(named: "img2")]
    var header = ["Club Name", "The longest Club Name", "Short", "Long Name"]
    var responces = ["News", "Everything", "Kids", "Science"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.clubTabelView.dequeueReusableCell(withIdentifier: "ClubCell", for:indexPath) as! ClubTableViewCell
        
        if self.clubs[indexPath.row] == nil {
            // Retrieve club data
            CloudKitHelper.instance.getClub(with: self.userIds[indexPath.row]) { (club, error) in
                if let e = error {
                    print("error getting club")
                } else {
                    self.clubs[indexPath.row] = club
                    DispatchQueue.main.async {
                        print(club.coverImage.size, club.name, club.category.rawValue)
                        // TODO - Doesnt actually change labels for some reason just goes blank
                        cell.clubIMG.image = club.coverImage
                        cell.clubName.text = club.name
                        cell.catagoryLabel.text = club.category.rawValue
                    }
                }
            }
        } else {
            if let club = self.clubs[indexPath.row] {
                cell.clubIMG.image = club.coverImage
                cell.clubName.text = club.name
                cell.catagoryLabel.text = club.category.rawValue
            }
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "toChat", sender: self)
        
    }
    
    
    
    
    
    
    
    @objc func playlist() {
        print("playlist")
    }
    
    @objc func add() {
        print("add something")
        self.performSegue(withIdentifier: "create", sender: self)
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
