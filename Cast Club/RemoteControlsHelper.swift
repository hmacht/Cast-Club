//
//  RemoteControlsHelper.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/29/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import MediaPlayer
import AVFoundation

class RemoteControlsHelper {
    
    static let instance = RemoteControlsHelper()
    
    var currentPodcast = Podcast()
    var player = AVPlayer()
    var image = UIImage()
    
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.setupNowPlaying(img: self.image)
            self.player.play()
            return .success
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.setupNowPlaying(img: self.image)
            self.player.pause()
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            
            if let e = event as? MPChangePlaybackPositionCommandEvent {
                //self.player.currentTime = e.positionTime
                //self.player.seek(to: CMTime(seconds: e.positionTime, preferredTimescale: 1000))
                self.player.seek(to: CMTime(seconds: e.positionTime, preferredTimescale: 1000), completionHandler: { (s) in
                    self.setupNowPlaying(img: self.image)
                })
                return .success
            }
            return .commandFailed
        }
    }
    
    func setupNowPlaying(img: UIImage?) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.currentPodcast.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = self.currentPodcast.author
        
        if let image = img {
            self.image = image
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(self.player.currentTime())
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTime(seconds: 0, preferredTimescale: 1000))
        //nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
}
