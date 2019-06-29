//
//  Podcast.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/24/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import Foundation
import UIKit

class Podcast: NSObject, NSCoding {
    var title = ""
    var author = ""
    var length: TimeInterval = 0
    var podcastDescription = ""
    var contentUrl = ""
    // The url of the file saved on the phone (if the user downloads the podcast)
    var fileUrl = ""
    
    var albumImage: UIImage?
    
    
    
    init(title: String, author: String, description: String, contentUrl: String, fileUrl: String, image: UIImage?) {
        self.title = title
        self.author = author
        self.podcastDescription = description
        self.contentUrl = contentUrl
        self.fileUrl = fileUrl
        
        if let img = image {
            self.albumImage = img
        }
    }
    
    convenience override init() {
        self.init(title: "", author: "", description: "", contentUrl: "", fileUrl: "", image: UIImage())
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let author = aDecoder.decodeObject(forKey: "author") as! String
        let description = aDecoder.decodeObject(forKey: "description") as! String
        let contentUrl = aDecoder.decodeObject(forKey: "contentUrl") as! String
        let fileUrl = aDecoder.decodeObject(forKey: "fileUrl") as! String
        let image = aDecoder.decodeObject(forKey: "image") as? UIImage
        
        self.init(title: title, author: author, description: description, contentUrl: contentUrl, fileUrl: fileUrl, image: image)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.author, forKey: "author")
        aCoder.encode(self.podcastDescription, forKey: "description")
        aCoder.encode(self.contentUrl, forKey: "contentUrl")
        aCoder.encode(self.fileUrl, forKey: "fileUrl")
        aCoder.encode(self.albumImage, forKey: "image")
    }
}
