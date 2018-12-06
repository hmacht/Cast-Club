//
//  TunesHelper.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/23/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import Foundation
import Alamofire

class TunesHelper {
    
    static let instance = TunesHelper()
    // Final url looks something like "https://itunes.apple.com/search?term=Ted+Talk&media=podcast"
    let baseUrl = "https://itunes.apple.com/search?term="
    
    // Completion is success if true error if false
    func searchiTunes(term: String, completion: @escaping (Bool, [PodcastAlbum]?) -> ()) {
        let termNoSpaces = term.replacingOccurrences(of: " ", with: "+")
        let fullSearch = baseUrl + termNoSpaces + "&media=podcast&limit=25"
        // Search api for podcasts that match search term
        if let url = URL(string: fullSearch) {
            print("searching ", fullSearch)
            Alamofire.request(url).validate().responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("error in response")
                    completion(false, nil)
                    return
                }
                if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [String : Any] {
                    
                    //print(json)
                    if let j = json {
                        completion(true, self.parseJSON(j))
                    } else {
                        print("error with json")
                        completion(false, nil)
                    }
                } else {
                    print("Cant convert json")
                    completion(false, nil)
                }
                
                
            }
        } else {
            print("Error with url")
            completion(false, nil)
        }
    }
    
    func parseJSON(_ json: [String : Any]) -> [PodcastAlbum] {
        var albums = [PodcastAlbum]()
        if let results: NSArray = json["results"] as? NSArray {
            for item in results {
                if let album: NSDictionary = item as! NSDictionary {
                    let newAlbum = PodcastAlbum()
                    
                    if let artist = album["artistName"] as? String {
                        newAlbum.artistName = artist
                    }
                    if let title = album["collectionCensoredName"] as? String {
                        newAlbum.title = title
                    }
                    if let numEpisodes = album["trackCount"] as? Int {
                        newAlbum.numEpisodes = numEpisodes
                    }
                    if let artworkUrl = album["artworkUrl60"] as? String {
                        newAlbum.artworkUrl = artworkUrl
                    }
                    if let artworkUrl600 = album["artworkUrl600"] as? String {
                        newAlbum.artworkUrl100 = artworkUrl600
                    } else {
                        if let artworkUrl100 = album["artworkUrl100"] as? String {
                            newAlbum.artworkUrl100 = artworkUrl100
                        }
                    }
                    if let feedUrl = album["feedUrl"] as? String {
                        newAlbum.feedUrl = feedUrl
                    }
                    /*self.getImage(url: newAlbum.artworkUrl) { (img) in
                        if let image = img {
                            newAlbum.artworkImage = image
                        }
                    }*/
                    albums.append(newAlbum)
                }
            }
        } else {
            print("Cant convert to array")
        }
        
        return albums
    }
    
}
