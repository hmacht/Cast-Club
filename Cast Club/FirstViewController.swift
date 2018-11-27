//
//  FirstViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 11/20/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

var subscriptionAlbum = [PodcastAlbum]()
var newSubscriptions = 0

class FirstViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let screenSize = UIScreen.main.bounds
    var homeSelection = PodcastAlbum()
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        
        
        self.tabBarController?.tabBar.setValue(true, forKey: "hidesShadow")
        self.navigationItem.title = "Home"
        
        let yourBackImage = UIImage(named: "Group 29")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 135"), style: .done, target: self, action: #selector(FirstViewController.search))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Path 82"), style: .done, target: self, action: #selector(FirstViewController.settings))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    // --- Currently Everything is hard Coded for prototyping. ---
    override func viewDidAppear(_ animated: Bool) {
        myCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptionAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.imgView.layer.cornerRadius = 6.0
        cell.imgView.clipsToBounds = true
        cell.imgView.image = subscriptionAlbum[indexPath.row].artworkImage
        print(newSubscriptions)
        
        if indexPath.row == (subscriptionAlbum.count - newSubscriptions){
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                cell.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: {(_ finished: Bool) -> Void in
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                })
            })
            newSubscriptions -= 1
        }
        
        if indexPath.row == (subscriptionAlbum.count - 1){
            newSubscriptions = 0
            print("NS = 0")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeSelection = subscriptionAlbum[indexPath.row]
        self.performSegue(withIdentifier: "viewDetails", sender: self)
        //print(homeSelection)
    }
    
    
    @objc func search() {
        print("Searching...")
        self.performSegue(withIdentifier: "toSearch", sender: self)
    }
    
    @objc func settings() {
        print("Changing settings")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("olleh")
        if segue.identifier == "viewDetails" {
            let destination = segue.destination as! AlbumViewController
            destination.album = self.homeSelection
        }
    }

}

