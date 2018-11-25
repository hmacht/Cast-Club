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
        self.titleLabel.text = self.selectedPodcast.title
        self.descriptionLabel.text = self.selectedPodcast.description
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        /*AudioDownloadHelper.instance.getAudioFromUrl(self.selectedPodcast.contentUrl) { (data) in
            if let d = data {
                if let p = try? AVAudioPlayer(data: d) {
                    print("we have data")
                    self.player = p
                    self.player.prepareToPlay()
                    self.player.volume = 1.0
                    self.player.play()
                }
            } else {
                print("Cant find data")
            }
        }*/
        
        AudioDownloadHelper.instance.getAudio(from: self.selectedPodcast.contentUrl) { (url) in
            if let u = url {
                if let p = try? AVAudioPlayer(contentsOf: u) {
                    self.player = p
                    self.player.prepareToPlay()
                    self.player.volume = 1.0
                    self.player.play()
                }
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
    
    @IBAction func playPressed(_ sender: Any) {
        if self.player.isPlaying {
            self.player.pause()
        } else {
            self.player.play()
        }
    }
    
}
