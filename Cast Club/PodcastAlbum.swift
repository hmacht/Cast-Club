//
//  PodcastAlbum.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/23/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import Foundation
import UIKit

class PodcastAlbum {
    
    var artistName = ""
    var title = ""
    var numEpisodes = 0
    var artworkUrl = ""
    var feedUrl = ""
    var artworkImage = UIImage()
    
    convenience init(artist: String, title: String, numEpisodes: Int, url: String, feedUrl: String) {
        self.init()
        self.artistName = artist
        self.title = title
        self.numEpisodes = numEpisodes
        self.artworkUrl = url
        self.feedUrl = feedUrl
    }
    
    
    // Not currently working
    func getImageData() {
        if let url = URL(string: artworkUrl) {
            if let data = try? Data(contentsOf: url) {
                if let img = UIImage(data: data) {
                    self.artworkImage = img
                }
            }
        }
    }
}
