//
//  PlayPodcastViewController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/24/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import AVFoundation

class PlayPodcastViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var selectedPodcast = Podcast()
    var coverImage = UIImage()
    var player = AVAudioPlayer()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.imageView.image = self.coverImage
        self.imageView.layer.cornerRadius = 6.0
        self.imageView.clipsToBounds = true
        self.titleLabel.text = self.selectedPodcast.title
        self.descriptionLabel.text = self.selectedPodcast.description
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Get audio and set up player
        AudioDownloadHelper.instance.getAudio(from: self.selectedPodcast.contentUrl) { (url) in
            if let u = url {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print(error)
                }

                if let p = try? AVAudioPlayer(contentsOf: u) {
                    self.player = p
                    self.player.prepareToPlay()
                    self.player.volume = 1.0
                    self.player.play()
                }
            }
        }
    }
    
    @IBAction func playPressed(_ sender: Any) {
        if self.player.isPlaying {
            self.player.pause()
        } else {
            self.player.play()
        }
    }
    
}
