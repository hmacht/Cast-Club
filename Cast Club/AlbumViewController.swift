//
//  AlbumViewController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/23/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //@IBOutlet weak var imgView: UIImageView!
    //@IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var artistLabel: UILabel!
    //@IBOutlet weak var numEpisodesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var album = PodcastAlbum()
    var podcastResults = [Podcast]()
    
    var selectedPodcast = Podcast()
    
    let screenSize = UIScreen.main.bounds
    
    var activityIndicator = UIActivityIndicatorView()
    var subscribeButton = SubscribeButton()
    
    
    override func viewDidLoad() {
        // Set delegates
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.title = "Episodes"
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        self.createActivityIndicator()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        print("Feed", album.feedUrl)
        FeedHelper.instance.readFeed(url: album.feedUrl) { (podcasts) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if let podcastList = podcasts {
                self.podcastResults = podcastList
                DispatchQueue.main.async {
                    self.tableView.reloadWithAnimation()
                }
            } else {
                print("Cant read podcasts")
            }
        }
    }
    
    func createActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        self.activityIndicator.frame = CGRect(x: self.view.frame.width/2 - 20, y: self.view.frame.height/2 - 20, width: 40, height: 40)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
        self.view.addSubview(self.activityIndicator)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabController = self.tabBarController as? PodcastTablBarController
        tabController?.audioController?.pushDown()
    }
    

    /*AudioDownloadHelper
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
        
        if indexPath.row == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "cellHeader") as! TableViewCell
            
            
            headerCell.imgView.image = UIImage(named: "Group 224")
            //self.imgView.image = self.album.getImageData(dimensions: .hundred)
            _ = self.album.getImageData(dimensions: .hundred, completion: { (image) in
                headerCell.imgView.image = image
            })
            headerCell.imgView.layer.cornerRadius = 6.0
            headerCell.imgView.clipsToBounds = true
            headerCell.titleLabel.text = self.album.title
            headerCell.artistLabel.text = self.album.artistName
            headerCell.numEpisodesLabel.text = String(self.album.numEpisodes) + " Episodes"
            
            headerCell.selectionStyle = .none
            
            
            if let b = headerCell.viewWithTag(1) as? SubscribeButton {
                self.subscribeButton = b
                if subscriptionAlbum.contains(where: {$0.title == self.album.title && $0.artistName == self.album.artistName && $0.feedUrl == self.album.feedUrl}) {
                    // We are already subscribed
                    self.subscribeButton.setTextUnsubscribe()
                } else {
                    self.subscribeButton.setTextSubscribe()
                }
            }
            
            return headerCell
            
        } else {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PodcastCell") as! UITableViewCell
            let podcast = podcastResults[indexPath.row - 1]
            
            if let titleLabel = cell.viewWithTag(1) as? UILabel {
                //titleLabel.text = String(indexPath.row + 1) + ". " + podcast.title
                titleLabel.text = podcast.title
            }
            if let descriptionLabel = cell.viewWithTag(2) as? UILabel {
                descriptionLabel.numberOfLines = 50
                let trimmedDescription = podcast.description.trimmingCharacters(in: .whitespacesAndNewlines)
                descriptionLabel.text = trimmedDescription.deleteHTMLTags(tags: ["p", "a", "br", "em"])
            }
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0{
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 150.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // add 1 because of header
        return podcastResults.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set the selected podcast
        self.selectedPodcast = self.podcastResults[indexPath.row - 1]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let tabController = self.tabBarController as? PodcastTablBarController {
            // If controller already there, don't create new one
            if tabController.audioController == nil {
                let miniController = MiniController(frame: CGRect(x: 0, y: screenSize.height, width: 0, height: 0), yposition: CGFloat((tabBarController?.tabBar.frame.minY)! - 90), artwork: self.album.artworkImage, podcast: self.selectedPodcast)
                
                tabController.audioController = miniController
                tabController.view.addSubview(miniController)
                
                let podcastSlider = slider(frame: CGRect.zero)
                miniController.podSlider = podcastSlider
                miniController.setUpSlider()
                
                do {
                    //try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: AVAudioSession.Mode.default, options: .defaultToSpeaker)
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("Error", error)
                }
                
                if let url = URL(string: self.selectedPodcast.contentUrl) {
                    miniController.avPlayer = AVPlayer(url: url)
                    miniController.avPlayer.play()
                    
                    if let tab = self.tabBarController as? PodcastTablBarController {
                        tab.setObserverForMinicontroller()
                    }
                    
                    RemoteControlsHelper.instance.currentPodcast = self.selectedPodcast
                    RemoteControlsHelper.instance.player = miniController.avPlayer
                    RemoteControlsHelper.instance.setupRemoteTransportControls()
                    RemoteControlsHelper.instance.setupNowPlaying(img: self.album.artworkImage)
                }
                
                /*
                // Get audio
                miniController.showActivity()
                AudioDownloadHelper.instance.getAudio(from: self.selectedPodcast.contentUrl) { (url, initialUrl) in
                    DispatchQueue.main.async {
                        miniController.stopActivity()
                    }
                    if initialUrl == miniController.podcast.contentUrl {
                        if let u = url {
                            do {
                                //try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
                                try AVAudioSession.sharedInstance().setCategory(.playback, mode: AVAudioSession.Mode.default, options: .defaultToSpeaker)
                                try AVAudioSession.sharedInstance().setActive(true)
                            } catch {
                                print("Error", error)
                            }
                            
                            if let p = try? AVAudioPlayer(contentsOf: u) {
                                miniController.player = p
                                miniController.player?.prepareToPlay()
                                miniController.player?.volume = 1.0
                                miniController.player?.play()
                                
                                DispatchQueue.main.async {
                                    RemoteControlsHelper.instance.currentPodcast = self.selectedPodcast
                                    RemoteControlsHelper.instance.player = p
                                    RemoteControlsHelper.instance.setupRemoteTransportControls()
                                    RemoteControlsHelper.instance.setupNowPlaying(img: self.album.artworkImage)
                                }
                            }
                        }
                    }
                }*/
            } else {
                tabController.audioController?.switchToPlay(podcast: self.selectedPodcast, artwork: self.album.artworkImage)
                if let tab = self.tabBarController as? PodcastTablBarController {
                    tab.setObserverForMinicontroller()
                }
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
        let tabController = self.tabBarController as? PodcastTablBarController
        tabController?.audioController?.pushDown()
    }
    
    /*
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tabController = self.tabBarController as? PodcastTablBarController
        if (self.lastContentOffset < tableView.contentOffset.y) {
            print("UP")
            //tabController?.audioController?.pushDown()
        } else if (self.lastContentOffset > tableView.contentOffset.y) {
            print("Down")
            //tabController?.audioController?.pushUp()
        } else {
            print("Nothing")
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let tabController = self.tabBarController as? PodcastTablBarController
        //tabController?.audioController?.pushUp()
        print("Done Scrolling")
    }
 */
    
    @IBAction func subscribe(_ sender: Any) {
        
        if !CloudKitHelper.instance.isAuthenticated {
            self.tabBarController?.showError(with: "You must be logged in to iCloud to subscribe to a podcast.")
            return
        }
        
        var alreadySubscribed = false
        if subscriptionAlbum.count > 0 {
            for i in 0...subscriptionAlbum.count - 1 {
                let a = subscriptionAlbum[i]
                // We are already subscribed to this album
                // So we must unsubscribe
                if a.title == self.album.title && a.artistName == self.album.artistName && a.feedUrl == self.album.feedUrl {
                    alreadySubscribed = true
                    CloudKitHelper.instance.unsubsribe(from: a) { (error) in
                        if let e = error {
                            print(e)
                        } else {
                            subscriptionAlbum.remove(at: i)
                            // TODO - add some sort of ui feedback
                            print("Done unsubscribing")
                            DispatchQueue.main.async {
                                self.subscribeButton.setTextSubscribe()
                            }
                        }
                    }
                    break
                }
            }
        }
        
        // Dont subcribe again if already subscribed
        if alreadySubscribed {
            return
        }
        // We are not subscribed to this yet
        CloudKitHelper.instance.saveAlbumToPrivate(self.album) { (error) in
            if let e = error {
                print(e)
            } else {
                print("Done saving")
            }
        }
            
        subscriptionAlbum.append(album)
        newSubscriptions += 1
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        createSubPopUp()
        self.subscribeButton.setTextUnsubscribe()
        
    }
    
}

