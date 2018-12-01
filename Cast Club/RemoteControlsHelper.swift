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
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            return .success
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            return .success
        }
    }
    
    func setupNowPlaying(img: UIImage?) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.currentPodcast.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = self.currentPodcast.author
        print(self.currentPodcast.title)
        
        if let image = img {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player.duration
        //nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
}
