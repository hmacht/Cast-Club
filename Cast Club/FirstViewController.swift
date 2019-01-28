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
    var discovewrBtn = UIButton()
    var errorPopUp: ErrorPopUp?
    
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
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 257"), style: .done, target: self, action: #selector(FirstViewController.settings))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        //let miniController = MiniController(frame: CGRect(x: 0, y: screenSize.height, width: 0, height: 0), yposition: CGFloat((tabBarController?.tabBar.frame.minY)! - 90))
        //tabBarController?.view.addSubview(miniController)
        tabBarController?.tabBar.layer.zPosition = 1
        
        
        errorPopUp = ErrorPopUp(frame: CGRect(x: 0, y: screenSize.height/2 - 55, width: screenSize.width, height: 200), headerText: "Hello Henry", bodyText: "Podcast that you subscribe to will show up here. You can search for a podcast or use the discover tab to browse. Don’t forget to join a club and enjoy!!")
        
        if let errorView = errorPopUp{
            self.view.addSubview(errorView)
            
            discovewrBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            discovewrBtn.center = CGPoint(x: screenSize.width/2, y: errorView.frame.maxY - 50)
            discovewrBtn.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
            discovewrBtn.layer.cornerRadius = 20
            discovewrBtn.titleLabel?.font = UIFont(name: "Mont-HeavyDEMO", size: 12)
            discovewrBtn.setTitle("Discover", for: .normal)
            discovewrBtn.addTarget(self, action: #selector(FirstViewController.discover), for: .touchUpInside)
            self.view.addSubview(discovewrBtn)
        }
        
        
        // TODO - very important to handle this if can't "authenticate" user
        CloudKitHelper.instance.setCurrentUserId { (error) in
            if let e = error {
                print(e)
            } else {
                // Get user subscriptions
                CloudKitHelper.instance.getAlbums { (albums, error) in
                    if let e = error {
                        print(e)
                    } else if albums.count > 0 {
                        subscriptionAlbum = albums
                        DispatchQueue.main.async {
                            self.errorPopUp?.removeFromSuperview()
                            self.discovewrBtn.removeFromSuperview()
                            self.myCollectionView.reloadData()
                        }
                    }
                }
            }
        }
        
        
    }
    
    
    
    // --- Currently Everything is hard Coded for prototyping. ---
    override func viewDidAppear(_ animated: Bool) {
        myCollectionView.reloadData()
        if subscriptionAlbum.count != 0{
            errorPopUp?.removeFromSuperview()
            discovewrBtn.removeFromSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptionAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        
        cell.imgView.layer.cornerRadius = 6.0
        cell.imgView.clipsToBounds = true
        
        if let img = subscriptionAlbum[indexPath.row].artworkImage {
            // We already have an img
            cell.imgView.image = img
        } else {
            // We do not have the image yet, download it
            cell.imgView.image = UIImage(named: "Group 224")
            DispatchQueue.global(qos: .background).async {
                _ = subscriptionAlbum[indexPath.row].getImageData(dimensions: .hundred, completion: { (image) in
                    if let img = image {
                        DispatchQueue.main.async {
                            cell.imgView.image = img
                        }
                    }
                })
            }
        }
        
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
        print("Playlist")
    }
    
    @objc func discover() {
        //print("discover")
        tabBarController?.selectedIndex = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("olleh")
        if segue.identifier == "viewDetails" {
            let destination = segue.destination as! AlbumViewController
            destination.album = self.homeSelection
        }
    }

}

