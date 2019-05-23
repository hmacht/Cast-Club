//
//  CollectionViewCell.swift
//  Cast Club
//
//  Created by Henry Macht on 11/26/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: AlbumImageView!
    
}

class AlbumImageView: UIImageView {
    var imgUrl = ""
    var imgUrl100 = ""
}
