//
//  FeedHelper.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/24/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import Foundation
import FeedKit

class FeedHelper {
    
    static let instance = FeedHelper()
    
    func readFeed(url: String, completion: @escaping ([Podcast]?) -> ()) {
        var podcasts = [Podcast]()
        if let u = URL(string: url) {
            let feedParser = FeedParser(URL: u)
            feedParser.parseAsync { (result) in
                if let rss = result.rssFeed {
                    if let items = rss.items {
                        for item in items {
                            let podcast = Podcast()
                            if let title = item.title {
                                podcast.title = title
                            }
                            if let mediaLink = item.enclosure?.attributes?.url {
                                podcast.contentUrl = mediaLink
                            }
                            if let description = item.description {
                                podcast.description = description
                            }
                            podcasts.append(podcast)
                        }
                        completion(podcasts)
                    } else {
                        print("No items")
                        completion(nil)
                    }
                } else {
                    print("No rss")
                    completion(nil)
                }
            }
        } else {
            print("No url")
            completion(nil)
        }
    }
}
