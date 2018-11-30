//
//  MiniController.swift
//  Cast Club
//
//  Created by Henry Macht on 11/27/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import AVFoundation

class MiniController: UIView {

    let screenSize = UIScreen.main.bounds
    
    let coverArt = UIImageView()
    let podcastTitle = UILabel()
    let playButton = UIButton()
    let skipButton = UIButton()
    let backSkipButton = UIButton()
    
    var yposition: CGFloat
    var title: String
    var art: UIImage = UIImage()
    var podcast = Podcast()
    
    var player: AVAudioPlayer?
    
    init (frame: CGRect, yposition: CGFloat, artwork: UIImage?, podcast: Podcast) {
        self.yposition = yposition
        self.title = podcast.title
        if let img = artwork {
            self.art = img
        }
        self.podcast = podcast
        super.init(frame: frame)
        // configure and add textField as subview
        self.backgroundColor = UIColor(red: 38.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        self.frame.size = CGSize(width: screenSize.width - 20, height: 75)
        self.layer.cornerRadius = 12.0
        self.clipsToBounds = true
        self.layer.zPosition = 0
        self.center.x = screenSize.width/2
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: 0, y: self.yposition, width: self.screenSize.width - 20, height: 75)
            self.center.x = self.screenSize.width/2
        })
        
        // frame.x is margin on top and bottom of coverArt
        coverArt.frame = CGRect(x: self.frame.height/2 - 25, y: 0, width: 50, height: 50)
        coverArt.center.y = self.frame.height/2
        coverArt.image = art
        coverArt.layer.cornerRadius = 4.0
        coverArt.clipsToBounds = true
        self.addSubview(coverArt)
        
        podcastTitle.frame = CGRect(x: coverArt.frame.maxX + 10, y: 0, width: self.frame.width/3, height: 40)
        podcastTitle.center.y = self.frame.height/2
        podcastTitle.numberOfLines = 2
        podcastTitle.font = UIFont(name: "Mont-HeavyDEMO", size: 16)
        podcastTitle.text = title
        podcastTitle.textColor = .white
        self.addSubview(podcastTitle)
        
        skipButton.frame = CGRect(x: self.frame.width - 50, y: 0, width: 40, height: 30)
        skipButton.center.y = self.frame.height/2
        skipButton.setImage(UIImage(named: "Group 174"), for: .normal)
        skipButton.contentMode = .scaleAspectFit
        skipButton.addTarget(self, action: #selector(MiniController.skip), for: .touchUpInside)
        self.addSubview(skipButton)
        
        playButton.frame = CGRect(x: skipButton.frame.minX - 30, y: 0, width: 30, height: 40)
        playButton.center.y = self.frame.height/2
        playButton.setImage(UIImage(named: "Group 240"), for: .normal)
        playButton.contentMode = .scaleAspectFit
        playButton.addTarget(self, action: #selector(MiniController.play), for: .touchUpInside)
        self.addSubview(playButton)
        
        backSkipButton.frame = CGRect(x: playButton.frame.minX - 43, y: 0, width: 40, height: 30)
        backSkipButton.center.y = self.frame.height/2
        backSkipButton.setImage(UIImage(named: "Group 222"), for: .normal)
        backSkipButton.contentMode = .scaleAspectFit
        backSkipButton.addTarget(self, action: #selector(MiniController.backSkip), for: .touchUpInside)
        self.addSubview(backSkipButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set textField size and position
        
    }
    
   
    
    @objc func play() {
        print("play/pause music")
        if self.player?.isPlaying ?? false {
            self.player?.pause()
            playButton.setImage(UIImage(named: "Path 74"), for: .normal)
        } else {
            self.player?.play()
            playButton.setImage(UIImage(named: "Group 240"), for: .normal)
        }
    }
    
    @objc func skip() {
        print("skip")
    }
    
    @objc func backSkip() {
        print("back skip")
    }
    
    var isDown = false
    
    func switchToPlay(podcast: Podcast, artwork: UIImage?) {
        self.player?.stop()
        
        self.podcast = podcast
        if let img = artwork {
            self.coverArt.image = img
        }
        
        self.podcastTitle.text = self.podcast.title
        
        coverArt.frame = CGRect(x: self.frame.height/2 - 15, y: 0, width: 30, height: 30)
        coverArt.center.y = self.frame.height/2
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.coverArt.frame = CGRect(x: self.frame.height/2 - 25, y: 0, width: 50, height: 50)
            self.coverArt.center.y = self.frame.height/2
        })
        
        if isDown{
            pushUp()
        }
        
        AudioDownloadHelper.instance.getAudio(from: self.podcast.contentUrl) { (url) in
            if let u = url {
                if let p = try? AVAudioPlayer(contentsOf: u) {
                    self.player = p
                    self.player?.prepareToPlay()
                    self.player?.volume = 1.0
                    self.player?.play()
                    
                    RemoteControlsHelper.instance.currentPodcast = self.podcast
                    RemoteControlsHelper.instance.player = p
                    RemoteControlsHelper.instance.setupRemoteTransportControls()
                    RemoteControlsHelper.instance.setupNowPlaying(img: artwork)
                }
            }
        }
    }
    
    func pushDown(){
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 100)
        })
        isDown = true
    }
    
    func pushUp(){
        if isDown{
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 5)
            })
            isDown = false
        }
    }


}
