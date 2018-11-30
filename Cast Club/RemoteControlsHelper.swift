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
    var player = AVAudioPlayer()
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.player.play()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.player.pause()
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
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
}
