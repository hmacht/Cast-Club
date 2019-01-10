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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clubTabelView.delegate = self
        self.clubTabelView.dataSource = self
        
        clubTabelView.tableFooterView = UIView()
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
                print("Got ids", self.userIds)
                
                DispatchQueue.main.async {
                    self.clubTabelView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 + self.userIds.count
    }
    
    // Test Material
    var images = [UIImage(named: "Group 439"), UIImage(named: "images-2"), UIImage(named: "images-1"), UIImage(named: "Unknown-1")]
    var header = ["Club Name", "The longest Club Name", "Short", "Long Name"]
    var responces = ["Responce", "Hi", "This is the last thing that someone said in the chat", "Long Responce"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = self.clubTabelView.dequeueReusableCell(withIdentifier: "ClubCell", for:indexPath) as! ClubTableViewCell
        
        if indexPath.row < 4 {
            myCell.clubIMG.image = images[indexPath.row]
            myCell.clubName.text = header[indexPath.row]
            myCell.lastResponce.text = responces[indexPath.row]
        } else {
            /loudKitHelper.instance.getClub(with: self.userIds[indexPath.row - 4 ]) { (club, error) in
                if let e = error {
                    print(e)
                } else {
                    // TODO - set the values of the cell
                }
            }
        }
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
