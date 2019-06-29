//
//  DowloadedPodcastsViewController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 6/24/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit
import AVFoundation

class DowloadedPodcastsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedPodcast = Podcast()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Downloaded Podcasts"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AudioDownloadHelper.instance.downloadedPodcasts.count == 0 {
            self.tabBarController?.showNoResultsLabel(message: "You haven't downloaded any podcasts yet!")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.hideNoResultsLabel()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AudioDownloadHelper.instance.downloadedPodcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DownloadCell") as! UITableViewCell
        
        let podcast = AudioDownloadHelper.instance.downloadedPodcasts[indexPath.row]
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.layer.cornerRadius = 5
            
            if let img = podcast.albumImage {
                imageView.image = podcast.albumImage
            } else {
                imageView.image = UIImage(named: "Group 335")
            }
        }
        
        if let titleLabel = cell.viewWithTag(2) as? UILabel {
            titleLabel.text = podcast.title
        }
        
        if let descriptionLabel = cell.viewWithTag(3) as? UILabel {
            descriptionLabel.text = podcast.podcastDescription
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set the selected podcast
        self.selectedPodcast = AudioDownloadHelper.instance.downloadedPodcasts[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let tabController = self.tabBarController as? PodcastTablBarController {
            // If controller already there, don't create new one
            if tabController.audioController == nil {
                let miniController = MiniController(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: 0, height: 0), yposition: CGFloat((tabBarController?.tabBar.frame.minY)! - 90), artwork: self.selectedPodcast.albumImage, podcast: self.selectedPodcast)
                
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
                
                
                
                var podcastUrlString = self.selectedPodcast.contentUrl
                if self.selectedPodcast.fileUrl != "" {
                    // The podcast is downloaded on device so we can play it from there
                    
                    if let url = AudioDownloadHelper.instance.currentFileDirecory(baseUrl: self.selectedPodcast.fileUrl) {
                        
                        miniController.avPlayer = AVPlayer(url: url)
                        miniController.playButton.setImage(UIImage(named: "Path 74"), for: .normal)
                        miniController.playButton.isUserInteractionEnabled = false
                        miniController.avPlayer.play()
                        
                        if let tab = self.tabBarController as? PodcastTablBarController {
                            tab.setObserverForMinicontroller()
                        }
                        
                        RemoteControlsHelper.instance.currentPodcast = self.selectedPodcast
                        RemoteControlsHelper.instance.player = miniController.avPlayer
                        RemoteControlsHelper.instance.setupRemoteTransportControls()
                        RemoteControlsHelper.instance.setupNowPlaying(img: self.selectedPodcast.albumImage)
                    }
                } else {
                    if let url = URL(string: self.selectedPodcast.contentUrl) {
                        
                        miniController.avPlayer = AVPlayer(url: url)
                        miniController.playButton.setImage(UIImage(named: "Path 74"), for: .normal)
                        miniController.playButton.isUserInteractionEnabled = false
                        miniController.avPlayer.play()
                        
                        if let tab = self.tabBarController as? PodcastTablBarController {
                            tab.setObserverForMinicontroller()
                        }
                        
                        RemoteControlsHelper.instance.currentPodcast = self.selectedPodcast
                        RemoteControlsHelper.instance.player = miniController.avPlayer
                        RemoteControlsHelper.instance.setupRemoteTransportControls()
                        RemoteControlsHelper.instance.setupNowPlaying(img: self.selectedPodcast.albumImage)
                    }
                }
            } else {
                
                tabController.audioController?.switchToPlay(podcast: self.selectedPodcast, artwork: self.selectedPodcast.albumImage)
                if let tab = self.tabBarController as? PodcastTablBarController {
                    tab.setObserverForMinicontroller()
                }
            }
        }
    }
    
    

}
