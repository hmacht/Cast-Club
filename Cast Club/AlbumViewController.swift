//
//  AlbumViewController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/23/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import AVFoundation

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
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imgView.image = UIImage(named: "Group 224")
        //self.imgView.image = self.album.getImageData(dimensions: .hundred)
        _ = self.album.getImageData(dimensions: .hundred, completion: { (image) in
            self.imgView.image = image
        })
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
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabController = self.tabBarController as? PodcastTablBarController
        tabController?.audioController?.pushUp()
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
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPodcast = self.podcastResults[indexPath.row]
        //self.performSegue(withIdentifier: "toPlayPodcast", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let tabController = self.tabBarController as? PodcastTablBarController {
            // If controller already there, don't create new one
            if tabController.audioController == nil {
                let miniController = MiniController(frame: CGRect(x: 0, y: screenSize.height, width: 0, height: 0), yposition: CGFloat((tabBarController?.tabBar.frame.minY)! - 90), artwork: self.album.artworkImage, podcast: self.selectedPodcast)
                
                tabController.audioController = miniController
                tabController.view.addSubview(miniController)
                
                // Get audio
                AudioDownloadHelper.instance.getAudio(from: self.selectedPodcast.contentUrl) { (url) in
                    if let u = url {
                        do {
                            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
                            try AVAudioSession.sharedInstance().setActive(true)
                            UIApplication.shared.beginReceivingRemoteControlEvents()
                        } catch {
                            print(error)
                        }
                        
                        if let p = try? AVAudioPlayer(contentsOf: u) {
                            miniController.player = p
                            miniController.player?.prepareToPlay()
                            miniController.player?.volume = 1.0
                            miniController.player?.play()
                            RemoteControlsHelper.instance.currentPodcast = self.selectedPodcast
                            RemoteControlsHelper.instance.player = p
                            RemoteControlsHelper.instance.setupRemoteTransportControls()
                            RemoteControlsHelper.instance.setupNowPlaying(img: self.album.artworkImage)
                        }
                    }
                }
            } else {
                tabController.audioController?.switchToPlay(podcast: self.selectedPodcast, artwork: self.album.artworkImage)
            }
        }
    }
    
    // Change Hard code and put into class
    let subscribedPopUp = UIImageView()
    func createSubPopUp() {
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
    
    var lastContentOffset: CGFloat = 0
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = tableView.contentOffset.y
        print("scrolling")
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tabController = self.tabBarController as? PodcastTablBarController
        if (self.lastContentOffset < tableView.contentOffset.y) {
            print("UP")
            tabController?.audioController?.pushDown()
        } else if (self.lastContentOffset > tableView.contentOffset.y) {
            print("Down")
            tabController?.audioController?.pushUp()
        } else {
            print("Nothing")
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let tabController = self.tabBarController as? PodcastTablBarController
        tabController?.audioController?.pushUp()
        print("Done Scrolling")
    }
    
    @IBAction func subscribe(_ sender: Any) {
        subscriptionAlbum.append(album)
        newSubscriptions += 1
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        createSubPopUp()
    }
    
}
