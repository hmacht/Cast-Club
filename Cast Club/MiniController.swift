//
//  MiniController.swift
//  Cast Club
//
//  Created by Henry Macht on 11/27/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MiniController: UIView {

    let screenSize = UIScreen.main.bounds
    
    let coverArt = UIImageView()
    let podcastTitle = UILabel()
    let playButton = UIButton()
    let skipButton = UIButton()
    let backSkipButton = UIButton()
    let slider = UISlider()
    var activityIndicator = UIActivityIndicatorView()
    var downloadButton = UIButton()
    
    var yposition: CGFloat
    var title: String
    var art: UIImage = UIImage()
    var podcast = Podcast()
    //var podcastSlider: UISlider
    var podSlider: slider?
    
    var hasExpanded = false
    var isDown = false
    
    var player: AVAudioPlayer?
    var avPlayer = AVPlayer()
    
    init (frame: CGRect, yposition: CGFloat, artwork: UIImage?, podcast: Podcast) {
        self.yposition = yposition
        self.title = podcast.title
        if let img = artwork {
            self.art = img
        }
        self.podcast = podcast
        //self.podcastSlider = podcastSlider
        super.init(frame: frame)
        // configure and add textField as subview
        self.backgroundColor = UIColor(red: 38.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        self.frame.size = CGSize(width: screenSize.width - 20, height: 75)
        self.layer.cornerRadius = 12.0
        self.clipsToBounds = true
        self.layer.zPosition = 0
        self.center.x = screenSize.width/2
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(MiniController.expand))
        
        self.addGestureRecognizer(gesture)
        
        
        //let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MiniController.expand))
        //swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        //self.addGestureRecognizer(swipeRight)
        
        
        UIView.animate(withDuration: 0.45, delay: 0.1, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
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
        
        self.activityIndicator = UIActivityIndicatorView(style: .white)
        self.activityIndicator.frame = self.playButton.frame
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
        self.addSubview(self.activityIndicator)
        
        adjustSlider()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set textField size and position
        
    }
    
    func setUpSlider() {
        self.podSlider?.isContinuous = true
        self.podSlider?.addTarget(self, action: #selector(MiniController.changeVlaue), for: .valueChanged)
        //self.podSlider?.addTarget(self, action: #selector(MiniController.beginTouchingSlider), for: .touchDown)
        
        // Timer to keep slider updated
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            self.updateSlider()
        }
    }
    
    @objc func play() {
        if !self.activityIndicator.isAnimating {
            /*if self.player?.isPlaying ?? false {
                self.player?.pause()
                self.avPlayer.pause()
                playButton.setImage(UIImage(named: "Path 74"), for: .normal)
            } else {
                self.player?.play()
                self.avPlayer.play()
                playButton.setImage(UIImage(named: "Group 240"), for: .normal)
            }*/
            
            // rate is 0 when paused
            if avPlayer.rate != 0 {
                self.avPlayer.pause()
                playButton.setImage(UIImage(named: "Path 74"), for: .normal)
            } else {
                self.avPlayer.play()
                playButton.setImage(UIImage(named: "Group 240"), for: .normal)
            }
        }
    }
    
    func showActivity() {
        self.shrinkView()
        self.hasExpanded = false
        self.playButton.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopActivity() {
        self.activityIndicator.stopAnimating()
        self.playButton.isHidden = false
    }
    
    @objc func skip() {
        if !self.activityIndicator.isAnimating {
            /*if let dur = self.player?.duration {
                if let cur = self.player?.currentTime{
                    if Int(cur) < Int(dur) - 15 {
                        self.player?.currentTime += 15
                    } else {
                        self.player?.currentTime = dur
                    }
                    self.podSlider?.setValue(Float(cur / dur), animated: true)
                }
            }*/
            if let durationTime = self.avPlayer.currentItem?.duration {
                let dur = CMTimeGetSeconds(durationTime)
                let current = CMTimeGetSeconds(self.avPlayer.currentTime())
                if current < dur - 15 {
                    self.player?.currentTime += 15
                    self.avPlayer.seek(to: CMTime(seconds: current + 15, preferredTimescale: 1000))
                } else {
                    self.avPlayer.seek(to: CMTime(seconds: dur, preferredTimescale: 1000))
                }
            }
        }
    }
    
    @objc func backSkip() {
        if !self.activityIndicator.isAnimating {
            /*if let cur = self.player?.currentTime{
                if Int(cur) > 15 {
                    self.player?.currentTime -= 15
                } else {
                    self.player?.currentTime = 0
                }
                if let dur = self.player?.duration {
                    self.podSlider?.setValue(Float(cur / dur), animated: true)
                }
            }*/
            
            let current = CMTimeGetSeconds(self.avPlayer.currentTime())
            if current > 15 {
                self.avPlayer.seek(to: CMTime(seconds: current - 15, preferredTimescale: 1000))
            } else {
                self.avPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
            }
            
        }
    }
    
    
    func switchToPlay(podcast: Podcast, artwork: UIImage?) {
        self.player?.stop()
        self.avPlayer.rate = 0
        
        self.podcast = podcast
        if let img = artwork {
            self.coverArt.image = img
        }
        
        self.podcastTitle.text = self.podcast.title
        playButton.setImage(UIImage(named: "Group 240"), for: .normal)
        
        // Show loading
        //self.showActivity()
        
        
        
        if hasExpanded{
            self.coverArt.frame = CGRect(x: self.frame.height/4 - 25, y: 0, width: 50, height: 50)
            self.coverArt.center.y = self.frame.height/4
            UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.coverArt.frame = CGRect(x: self.frame.height/4 - 35, y: 0, width: 70, height: 70)
                self.coverArt.center.y = self.frame.height/4
            })
            
        } else{
            coverArt.frame = CGRect(x: self.frame.height/2 - 15, y: 0, width: 30, height: 30)
            coverArt.center.y = self.frame.height/2
            UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.coverArt.frame = CGRect(x: self.frame.height/2 - 25, y: 0, width: 50, height: 50)
                self.coverArt.center.y = self.frame.height/2
            })
            /*
            if isDown{
                pushUp()
            }
            */
        }
        
        if let url = URL(string: self.podcast.contentUrl) {
            self.avPlayer = AVPlayer(url: url)
            self.avPlayer.play()
            
            RemoteControlsHelper.instance.currentPodcast = self.podcast
            RemoteControlsHelper.instance.player = self.avPlayer
            RemoteControlsHelper.instance.setupRemoteTransportControls()
            RemoteControlsHelper.instance.setupNowPlaying(img: artwork)
        }
        
        /*
        AudioDownloadHelper.instance.getAudio(from: self.podcast.contentUrl) { (url, initialUrl) in
            DispatchQueue.main.async {
                self.stopActivity()
            }
            if let u = url {
                if let p = try? AVAudioPlayer(contentsOf: u) {
                    self.player = p
                    self.player?.prepareToPlay()
                    self.player?.volume = 1.0
                    self.player?.play()
                    
                    DispatchQueue.main.async {
                        RemoteControlsHelper.instance.currentPodcast = self.podcast
                        RemoteControlsHelper.instance.player = p
                        RemoteControlsHelper.instance.setupRemoteTransportControls()
                        RemoteControlsHelper.instance.setupNowPlaying(img: artwork)
                    }
                }
            }
        }*/
        
        
    }
    
    func adjustSlider() {
        
        if let podcastLength = player?.duration{
            podSlider?.maximumValue = Float(podcastLength)
            print("---\(podSlider!.maximumValue)")
        }
        //slider.maximumValue = 300
        //print("---\(slider.maximumValue)")
    }
 
    
    func pushDown(){
        UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.58, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            //self.transform = CGAffineTransform(translationX: 0, y: 100)
            if self.hasExpanded{
                self.shrinkView()
                self.hasExpanded = false
            }
            
        })
        isDown = true
    }
    
    func pushUp(){
        if isDown{
            UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.58, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 5)
            })
            isDown = false
        }
    }
    
    
    
    func expandView(){
        UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.58, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame.size = CGSize(width: self.frame.width, height: self.frame.height * 3)
            self.transform = CGAffineTransform(translationX: 0, y: -140)
            //self.playButton.setImage(UIImage(named: "Large Play"), for: .normal)
            self.playButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.playButton.center = CGPoint(x: self.center.x - self.playButton.frame.width/4, y: self.frame.height - 45)
            
            //self.skipButton.setImage(UIImage(named: "Large forward"), for: .normal)
            self.skipButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.skipButton.center = CGPoint(x: (self.center.x - self.playButton.frame.width/4) + self.frame.width/3, y: self.frame.height - 45)
            
            //self.backSkipButton.setImage(UIImage(named: "Large Back"), for: .normal)
            self.backSkipButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.backSkipButton.center = CGPoint(x: (self.center.x - self.playButton.frame.width/4) - self.frame.width/3, y: self.frame.height - 45)
            
            self.coverArt.frame = CGRect(x: self.frame.height/4 - 35, y: 0, width: 70, height: 70)
            self.coverArt.center.y = self.frame.height/4
            
            self.podcastTitle.frame = CGRect(x: self.coverArt.frame.maxX + 10, y: 0, width: self.frame.width/2.5, height: 40)
            self.podcastTitle.center.y = self.frame.height/4
            
            
        })
        
        //podcastSlider.center.y = playButton.frame.minX - 30
        //podcastSlider.center.x = self.frame.width/2
        //self.addSubview(podcastSlider)
        
        podSlider?.center = CGPoint(x: self.frame.width/2, y: playButton.frame.minX - 30)
        self.addSubview(podSlider!)
        
        downloadButton.frame = CGRect(x: self.frame.width - 70, y: self.frame.height, width: 50, height: 50)
        
        UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.downloadButton.center.y = self.podcastTitle.frame.midY
            
        })
        
        
        
        downloadButton.setImage(UIImage(named: "Group 900"), for: .normal)
        downloadButton.contentMode = .scaleAspectFit
        //downloadButton.addTarget(self, action: #selector(MiniController.download), for: .touchUpInside)
        self.addSubview(downloadButton)
       
    }
    func shrinkView(){
        
      
        
        
            
        UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.58, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.downloadButton.center.y = self.podcastTitle.frame.midY + 50
            
        })
            
            
        
        
        
        UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.58, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame.size = CGSize(width: self.screenSize.width - 20, height: 70)
            self.transform = CGAffineTransform(translationX: 0, y: 5)
            
            self.skipButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.skipButton.frame = CGRect(x: self.frame.width - 50, y: 0, width: 40, height: 30)
            self.skipButton.center.y = self.frame.height/2
            
            self.playButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.playButton.frame = CGRect(x: self.skipButton.frame.minX - 30, y: 0, width: 30, height: 40)
            self.playButton.center.y = self.frame.height/2
            
            self.backSkipButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.backSkipButton.frame = CGRect(x: self.playButton.frame.minX - 43, y: 0, width: 40, height: 30)
            self.backSkipButton.center.y = self.frame.height/2
            
            self.coverArt.frame = CGRect(x: self.frame.height/2 - 25, y: 0, width: 50, height: 50)
            self.coverArt.center.y = self.frame.height/2
            
            self.podcastTitle.frame = CGRect(x: self.coverArt.frame.maxX + 10, y: 0, width: self.frame.width/3, height: 40)
            self.podcastTitle.center.y = self.frame.height/2
            
            
        })

        //podcastSlider.removeFromSuperview()
        
        
    }
    
    
    
    @objc func expand(_ sender:UITapGestureRecognizer){
        // If loading don't change
        if !self.activityIndicator.isAnimating {
            if hasExpanded == false{
                expandView()
                hasExpanded = true
            } else{
                shrinkView()
                hasExpanded = false
            }
        }
    }
    
    @objc func changeVlaue(_ sender: UISlider) {
        /*if let val = TimeInterval(exactly: sender.value) {
            if let dur = self.player?.duration {
                self.player?.currentTime = val * dur
            }
        }*/
        if let val = TimeInterval(exactly: sender.value) {
            if let dur = self.avPlayer.currentItem?.duration {
                let seekTime = val * CMTimeGetSeconds(dur)
                self.avPlayer.seek(to: CMTime(seconds: seekTime, preferredTimescale: 1000))
            }
        }
    }
    
    
    func updateSlider() {
        /*
        if let time = self.player?.currentTime {
            if let dur = self.player?.duration {
                self.podSlider?.setValue(Float(time/dur), animated: true)
            }
        }*/
        if let dur = self.avPlayer.currentItem?.duration {
            self.podSlider?.setValue(Float(CMTimeGetSeconds(self.avPlayer.currentTime()) / CMTimeGetSeconds(dur)), animated: true)
        }
    }


}
