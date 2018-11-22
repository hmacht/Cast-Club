//
//  FirstViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 11/20/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHeader()
        createSearchButton()
    }
    
    // --- Currently Everything is hard Coded for prototyping. ---
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 125, left: 10, bottom: 20, right: 10)
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
        /*
        let imageView = UIImageView()
        imageView.frame = CGRect(origin: cell.center, size: CGSize(width: cell.frame.width, height: cell.frame.height))
        imageView.center = CGPoint(x: cell.center.x, y: cell.center.y)
        imageView.image = UIImage(named: "Group 224")
        imageView.layer.cornerRadius = 6
        cell.contentView.addSubview(imageView)
        */
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
    }
    
    func createHeader(){
        let customFont = UIFont(name: "Mont-HeavyDEMO", size: 31)
        let header1 = UILabel()
        header1.frame = CGRect(x: 15, y: 30, width: 200, height: 100)
        header1.textAlignment = .left
        header1.font = customFont
        header1.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        header1.text = "Currently"
        header1.layer.zPosition = 1
        self.view.addSubview(header1)
        
        let header2 = UILabel()
        header2.frame = CGRect(x: 15, y: 70, width: 200, height: 100)
        header2.textAlignment = .left
        header2.font = customFont
        header2.textColor = UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        header2.text = "listening to"
        header2.layer.zPosition = 1
        self.view.addSubview(header2)
    }
    
    func createSearchButton(){
        let image = UIImage(named: "Group 135") as UIImage?
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        searchButton.center = CGPoint(x: screenSize.width - 55, y: 90)
        searchButton.setImage(image, for: .normal)
        searchButton.contentMode = .scaleAspectFill
        searchButton.addTarget(self, action: #selector(FirstViewController.search), for: UIControl.Event.touchUpInside)
        searchButton.layer.zPosition = 1
        self.view.addSubview(searchButton)
    }
    
    @objc func search() {
        print("Searching...")
    }


}

