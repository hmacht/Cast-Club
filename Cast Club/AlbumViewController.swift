//
//  AlbumViewController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/23/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var numEpisodesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var album = PodcastAlbum()
    var podcastResults = [Podcast]()
    
    var selectedPodcast = Podcast()
    
    let screenSize = UIScreen.main.bounds
    
    
    override func viewDidLoad() {
        // Set delegates
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.title = "Episodes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imgView.image = self.album.getImageData(dimensions: .hundred)
        self.imgView.layer.cornerRadius = 6.0
        self.imgView.clipsToBounds = true
        self.titleLabel.text = self.album.title
        self.artistLabel.text = self.album.artistName
        self.numEpisodesLabel.text = String(self.album.numEpisodes) + " Episodes"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        FeedHelper.instance.readFeed(url: album.feedUrl) { (podcasts) in
            if let podcastList = podcasts {
                self.podcastResults = podcastList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Cant read podcasts")
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayPodcast" {
            let destination = segue.destination as! PlayPodcastViewController
            if let img = self.album.artworkImage {
                destination.coverImage = img
            }
            destination.selectedPodcast = self.selectedPodcast
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PodcastCell") as! UITableViewCell
        
        let podcast = podcastResults[indexPath.row]
        
        if let titleLabel = cell.viewWithTag(1) as? UILabel {
            //titleLabel.text = String(indexPath.row + 1) + ". " + podcast.title
            titleLabel.text = podcast.title
        }
        if let descriptionLabel = cell.viewWithTag(2) as? UILabel {
            descriptionLabel.numberOfLines = 50
            descriptionLabel.text = podcast.description
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.selectedPodcast = self.podcastResults[indexPath.row]
        //self.performSegue(withIdentifier: "toPlayPodcast", sender: self)
        
        let miniController = MiniController(frame: CGRect(x: 0, y: screenSize.height, width: 0, height: 0), yposition: CGFloat((tabBarController?.tabBar.frame.minY)! - 90), title: album.title, art: album.artworkImage!)
        tabBarController?.view.addSubview(miniController)
    }
    
    // Change Hard code and put into class
    let subscribedPopUp = UIImageView()
    func createSubPopUp(){
        subscribedPopUp.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        subscribedPopUp.center.x = self.view.center.x
        subscribedPopUp.center.y = self.view.center.y - 130
        subscribedPopUp.image = UIImage(named: "Group 239")
        subscribedPopUp.alpha = 0
        self.view.addSubview(subscribedPopUp)
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.subscribedPopUp.alpha = 1
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.5, delay: 1.0, animations: {
                self.subscribedPopUp.alpha = 0
            })
            
        })
    }
    
    @IBAction func subscribe(_ sender: Any) {
        subscriptionAlbum.append(album)
        newSubscriptions += 1
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        createSubPopUp()
    }
    
}
