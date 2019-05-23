//
//  PodcastTablBarController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/28/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import AVFoundation

class PodcastTablBarController: UITabBarController {
    
    var audioController: MiniController?
    
    var errorPopUp = ErrorView()
    var blockerView = UIView()
    var clubIds = [String]()
    
    var startPos = CGPoint()
    var audioSourcePos = CGPoint()
    var removingView = false
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.blockerView.frame = self.view.frame
        self.blockerView.backgroundColor = .clear
        self.blockerView.isUserInteractionEnabled = false
        self.view.addSubview(blockerView)
        
        self.errorPopUp = ErrorView(frame: CGRect(x: self.view.frame.width/2 - 125, y: self.view.frame.height/2 - 100, width: 250, height: 200), message: ErrorMessage.basic.rawValue)
        self.errorPopUp.okButton.addTarget(self, action: #selector(PodcastTablBarController.hide), for: .touchUpInside)
        self.errorPopUp.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.view.addSubview(errorPopUp)
        
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        self.activityIndicator.frame = CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 25, width: 50, height: 50)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.tag = 10
        self.view.addSubview(self.activityIndicator)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePauseButton), name: Notification.Name("updatePause"), object: nil)
        
    }
    
    @objc func updatePauseButton() {
        if self.audioController?.avPlayer.rate == 0 {
            self.audioController?.playButton.setImage(UIImage(named: "Path 74"), for: .normal)
        }
    }
    
    func setObserverForMinicontroller() {
        //self.audioController?.avPlayer.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        //self.audioController?.avPlayer.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        //self.audioController?.avPlayer.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
        
        self.audioController?.avPlayer.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.audioController?.avPlayer.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        self.audioController?.avPlayer.currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
        
        self.audioController?.avPlayer.addObserver(self, forKeyPath: "status", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object is AVPlayerItem {
            switch keyPath {
            case "playbackBufferEmpty":
                // Show loader
                self.audioController?.showActivity()
                break
            case "playbackLikelyToKeepUp":
                // Hide loader
                self.audioController?.stopActivity()
                // Update remote controls
                RemoteControlsHelper.instance.setupNowPlaying(img: RemoteControlsHelper.instance.image)
                break
            case "playbackBufferFull":
                // Hide loader
                self.audioController?.stopActivity()
                // Update remote controls
                RemoteControlsHelper.instance.setupNowPlaying(img: RemoteControlsHelper.instance.image)
                break
            default:
                break
            }
        } else if object is AVPlayer && keyPath == "status" {
            if self.audioController?.avPlayer.status == AVPlayer.Status.readyToPlay {
                self.audioController?.playButton.isUserInteractionEnabled = true
                self.audioController?.playButton.setImage(UIImage(named: "Group 240"), for: .normal)
                
            } else if self.audioController?.avPlayer.status == AVPlayer.Status.failed {
                print("failed")
            }
        }
    }
    
    
    
    /*func showError(with message: String) {
        
        /*self.blockerView.isUserInteractionEnabled = true
        self.errorPopUp.message = message
        self.errorPopUp.messageLabel.text = self.errorPopUp.message
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: [], animations: {
            self.errorPopUp.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)*/
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }*/
    
    @objc func hide() {
        /*self.blockerView.isUserInteractionEnabled = false
    
        UIView.animate(withDuration: 0.4, animations: {
            self.errorPopUp.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (success) in
            self.errorPopUp.transform = CGAffineTransform(scaleX: 0, y: 0)
        }*/
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // Touch handling
    var isDeleted = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isDeleted = false
        
        if let pos = touches.first?.location(in: self.view) {
            if self.audioController?.frame.contains(pos) ?? false && (self.audioController?.hasExpanded ?? true) == false{
                self.startPos = pos
                self.audioSourcePos = CGPoint(x: self.audioController?.frame.origin.x ?? 0, y: self.audioController?.frame.origin.y ?? 0)
                
                
            }
        }
    }
    
    
    var delete = false
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.audioController?.hasExpanded ?? true {
            return
        }
        if let pos = touches.first?.location(in: self.view) {
            
            print(abs(pos.x - startPos.x))
            if pos.x - startPos.x > 10 {
                
                if pos.x - startPos.x > 100 {
                    
                    delete = true
                    self.audioController?.alpha = 0.8
                    
                    
                    // Dismiss right
                    
                } else if abs(pos.x - startPos.y) > 50 && isDeleted == false{
                    delete = false
                    self.audioController?.alpha = 1.0
                    
                    
                }
                self.audioController?.frame = CGRect(x: pos.x - startPos.x, y: self.tabBar.frame.minY - 90, width: self.audioController?.frame.width ?? 0, height: self.audioController?.frame.height ?? 0)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if delete == true {
            self.audioController?.avPlayer.pause()
            self.removingView = true
            self.isDeleted = true
            UIView.animate(withDuration: 0.5, animations: {
                self.audioController?.frame.origin.x += self.view.frame.width
            }) { (_) in
                self.audioController = nil
                self.removingView = false
            }
        }
        
        if self.audioController != nil  && !self.removingView && !(self.audioController?.hasExpanded ?? true) {
            UIView.animate(withDuration: 0.25) {
                self.audioController?.frame.origin.x = 10
                self.audioController?.frame.origin.y = self.audioSourcePos.y
            }
        }
    }
    
}


extension UITabBarController {
    
    func showError(with message: String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showActivity() {
        if let indicator = self.view.viewWithTag(10) as? UIActivityIndicatorView {
            indicator.isHidden = false
            indicator.startAnimating()
        }
    }
    
    func stopActivity() {
        if let indicator = self.view.viewWithTag(10) as? UIActivityIndicatorView {
            indicator.stopAnimating()
        }
    }
    
    func showNoResultsLabel(message: String) {
        DispatchQueue.main.async {
            if let _ = self.view.viewWithTag(-43) {
                return
            }
            let label = UILabel(frame: CGRect(x: 15, y: self.view.frame.height/2 - 125, width: self.view.frame.width - 30, height: 250))
            label.numberOfLines = 0
            label.font = UIFont(name: "Avenir-Black", size: 20)
            label.text = message
            label.textAlignment = NSTextAlignment.center
            label.textColor = .lightGray
            label.tag = -43
            
            self.view.addSubview(label)
        }
    }
    
    func hideNoResultsLabel() {
        DispatchQueue.main.async {
            if let label = self.view.viewWithTag(-43) {
                label.removeFromSuperview()
                
            }
        }
    }
}


