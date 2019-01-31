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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
