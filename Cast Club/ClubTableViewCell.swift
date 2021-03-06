//
//  ClubTableViewCell.swift
//  Cast Club
//
//  Created by Henry Macht on 12/30/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class ClubTableViewCell: UITableViewCell {
    @IBOutlet weak var clubIMG: UIImageView!
    @IBOutlet weak var catagoryLabel: UILabel!
    @IBOutlet weak var clubName: UILabel!
    
    override func draw(_ rect: CGRect) {
        self.clubIMG.tag = 1
        self.clubName.tag = 2
        //self.lastResponce.tag = 3
        
        
        self.clubIMG.layer.cornerRadius = 23.5
        self.clubIMG.clipsToBounds = true
        self.clubName.font = UIFont(name: "Avenir-Black", size: 16)
        //self.lastResponce.textColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        //self.lastResponce.font = UIFont(name: "Avenir-Medium", size: 15)
        
        
        
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.selectedBackgroundView = backgroundView
    }
}
