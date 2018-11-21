//
//  FirstViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 11/20/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 80, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: 110, height: 110)
        let myCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(myCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.white
        cell.layer.shadowColor = UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1.0).cgColor
        cell.layer.shadowOpacity = 0.51
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 23
        cell.layer.cornerRadius = 6
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
    }


}

