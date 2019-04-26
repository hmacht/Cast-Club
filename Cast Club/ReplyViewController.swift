//
//  ReplyViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 4/25/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var cellUsername = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Reply to @\(cellUsername)"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        tableView.separatorStyle = .none
        
        self.tableView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.messages.count + 1
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for:indexPath) as! UITableViewCell
        
        if let usersProfileImage = myCell.viewWithTag(1) as? UIImageView {
            usersProfileImage.layer.cornerRadius = 20.0
            usersProfileImage.clipsToBounds = true
            usersProfileImage.contentMode = .scaleAspectFill
        }
        
        if let usernameLabel = myCell.viewWithTag(2) as? UILabel {
            usernameLabel.sizeToFit()
            //usernameLabel.text = self.messages[indexPath.row - 1].fromUsername
            usernameLabel.text = "Username"
        }
        
        if let responcelabel = myCell.viewWithTag(3) as? UILabel {
            //responcelabel.text = self.messages[indexPath.row - 1].text
            responcelabel.text = "Here is my reply comment"
            responcelabel.sizeToFit()
            responcelabel.numberOfLines = 50
        }
        
        return myCell
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
