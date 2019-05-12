//
//  PodcastAlbum.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/23/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

enum ArtworkDimension {
    case thrity, hundred
}

class PodcastAlbum {
    
    var artistName = ""
    var title = ""
    var numEpisodes = 0
    var artworkUrl = ""
    var artworkUrl100 = ""
    var feedUrl = ""
    var artworkImage: UIImage?
    var recordId = CKRecord.ID()
    
    convenience init(artist: String, title: String, numEpisodes: Int, url: String, feedUrl: String) {
        self.init()
        self.artistName = artist
        self.title = title
        self.numEpisodes = numEpisodes
        self.artworkUrl = url
        self.feedUrl = feedUrl
    }
    
    func getImageData(dimensions: ArtworkDimension = ArtworkDimension.thrity, completion: @escaping (UIImage?, String) -> ()) -> UIImage? {
        var aUrl = self.artworkUrl
        // To get higher resolution img
        if dimensions == ArtworkDimension.hundred {
            aUrl = self.artworkUrl100
        }
        if let url = URL(string: aUrl) {
            if let data = try? Data(contentsOf: url) {
                if let img = UIImage(data: data) {
                    self.artworkImage = img
                    completion(img, aUrl)
                    return img
                } else {
                    completion(nil, aUrl)
                    return nil
                }
            } else {
                completion(nil, aUrl)
                return nil
            }
        }
        completion(nil, aUrl)
        return nil
    }
}
