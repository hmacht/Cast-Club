//
//  FirstViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 11/20/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

// The podcast albums the user is subscribed to
var subscriptionAlbum = [PodcastAlbum]()
var newSubscriptions = 0

// The clubs the user is subscribed to
//var clubIds = ["none"]
var clubIds = [String]()


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
        
        //let miniController = MiniController(frame: CGRect(x: 0, y: screenSize.height, width: 0, height: 0), yposition: CGFloat((tabBarController?.tabBar.frame.minY)! - 90))
        //tabBarController?.view.addSubview(miniController)
        tabBarController?.tabBar.layer.zPosition = 1
        
        
        
        errorPopUp = ErrorPopUp(frame: CGRect(x: 0, y: screenSize.height/2 - 55, width: screenSize.width, height: 200), headerText: "Hello!", bodyText: "Podcasts that you subscribe to will show up here. You can search for a podcast or use the discover tab to browse. Don’t forget to join a club and enjoy!!")
        
        if let errorView = errorPopUp {
            discovewrBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            discovewrBtn.center = CGPoint(x: screenSize.width/2, y: errorView.frame.maxY - 50)
            discovewrBtn.backgroundColor = UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 254.0/255.0, alpha: 1.0)
            discovewrBtn.layer.cornerRadius = 20
            discovewrBtn.titleLabel?.font = UIFont(name: "Mont-HeavyDEMO", size: 12)
            discovewrBtn.setTitle("Discover", for: .normal)
            discovewrBtn.addTarget(self, action: #selector(FirstViewController.discover), for: .touchUpInside)
            //self.view.addSubview(discovewrBtn)
            // self.view.addSubview(errorView)
        }
        
        // TODO - very important to handle this if can't "authenticate" user
        // TODO - theoretically this logic should be moved to some sort of loading view
        if !CloudKitHelper.instance.isAuthenticated {
            // Not authenticated
            self.errorPopUp = ErrorPopUp(frame: CGRect(x: 0, y: self.screenSize.height/2 - 55, width: self.screenSize.width, height: 200), headerText: "Hello!", bodyText: "You must login to iCloud in your Settings to enjoy all the features of Pod Talk. Until you do that, you can still listen to podcasts and look at clubs.")
            if let pop = self.errorPopUp {
                self.view.addSubview(pop)
                self.view.addSubview(self.discovewrBtn)
            }
        } else if CloudKitHelper.instance.internetErrorDescription != "" {
            // Some sort of error in launch screen
            self.errorPopUp = ErrorPopUp(frame: CGRect(x: 0, y: self.screenSize.height/2 - 55, width: self.screenSize.width, height: 200), headerText: "Internet Connection", bodyText: CloudKitHelper.instance.internetErrorDescription)
            if let pop = self.errorPopUp {
                self.view.addSubview(pop)
                self.view.addSubview(self.discovewrBtn)
            }
        } else if subscriptionAlbum.count == 0 {
            // No subscribed albums yet
            self.errorPopUp = ErrorPopUp(frame: CGRect(x: 0, y: self.screenSize.height/2 - 55, width: self.screenSize.width, height: 200), headerText: "Welcome to Pod Talk!", bodyText: "Come back to this page when you are subscribed to a podcast")
            if let pop = self.errorPopUp {
                self.view.addSubview(pop)
                self.view.addSubview(self.discovewrBtn)
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: "dowloadedPodcasts") {
            
            if let decodedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast] {
                
                AudioDownloadHelper.instance.downloadedPodcasts = decodedPodcasts
                for p in decodedPodcasts {
                    print(p.title)
                }
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch adad")
    }
    
    var didShow = false
    
    // --- Currently Everything is hard Coded for prototyping. ---
    override func viewDidAppear(_ animated: Bool) {
        myCollectionView.reloadData()
        if subscriptionAlbum.count != 0{
            errorPopUp?.removeFromSuperview()
            discovewrBtn.removeFromSuperview()
        }
        
        //if didShow == false{
          //  performSegue(withIdentifier: "toOB", sender: self)
            //didShow = true
        //}
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let yourBackImage = UIImage(named: "Group 29")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 135"), style: .done, target: self, action: #selector(FirstViewController.search))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 916"), style: .done, target: self, action: #selector(FirstViewController.settings))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        //let whiteAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        //UIBarButtonItem.appearance().setTitleTextAttributes(whiteAttributes , for: .normal)
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
            cell.imgView.image = UIImage(named: "Group 932")
            cell.imgView.imgUrl = subscriptionAlbum[indexPath.row].artworkUrl
            cell.imgView.imgUrl100 = subscriptionAlbum[indexPath.row].artworkUrl100
            DispatchQueue.global(qos: .userInitiated).async {
                _ = subscriptionAlbum[indexPath.row].getImageData(dimensions: .hundred, completion: { (image, url) in
                    if let img = image {
                        // Make sure we are setting the correct image
                        if url == cell.imgView.imgUrl || url == cell.imgView.imgUrl100 {
                            DispatchQueue.main.async {
                                cell.imgView.image = img
                            }
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
        self.performSegue(withIdentifier: "toDownloadedPodcasts", sender: self)
    }
    
    @objc func discover() {
        //print("discover")
        self.performSegue(withIdentifier: "toSearch", sender: self)
        //tabBarController?.selectedIndex = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("olleh")
        if segue.identifier == "viewDetails" {
            let destination = segue.destination as! AlbumViewController
            destination.album = self.homeSelection
        }
        
        if segue.identifier == "toSearch" {
            let destination = segue.destination as! SearchPodcastsViewController
            destination.editingClubPodcast = false
        }
    }

}

