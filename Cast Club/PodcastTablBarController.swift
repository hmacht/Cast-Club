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
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.audioController?.hasExpanded ?? true {
            return
        }
        if let pos = touches.first?.location(in: self.view) {
            
            print(pos.x - startPos.x)
            if pos.x - startPos.x > 10 {
                
                if pos.x - startPos.x > 100 {
                    // Dismiss right
                    self.audioController?.avPlayer.pause()
                    self.removingView = true
                    self.isDeleted = true
                    UIView.animate(withDuration: 0.5, animations: {
                        self.audioController?.frame.origin.x += self.view.frame.width
                    }) { (_) in
                        self.audioController = nil
                        self.removingView = false
                    }
                } else if pos.x - startPos.x < -100 {
                    // Dismiss left
                    self.audioController?.avPlayer.pause()
                    self.removingView = true
                    UIView.animate(withDuration: 0.5, animations: {
                        self.audioController?.frame.origin.x -= self.view.frame.width
                    }) { (_) in
                        self.audioController = nil
                        self.removingView = false
                    }
                } else if abs(pos.x - startPos.y) > 50 && isDeleted == false{
                    self.audioController?.frame = CGRect(x: pos.x - startPos.x, y: self.tabBar.frame.minY - 90, width: self.audioController?.frame.width ?? 0, height: self.audioController?.frame.height ?? 0)
                    
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
}


