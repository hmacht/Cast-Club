//
//  Club.swift
//  Cast Club
//
//  Created by Toby Kreiman on 12/24/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import CloudKit
import UIKit

enum ClubCategory: String {
    case none = " "
    case everything = "Everything"
    case news = "News"
    case culture = "Culture"
    case comedy = "Comedy"
    case education = "Education"
    case art = "Art"
    case business = "Business"
    case politics = "Politics"
    case kids = "Kids"
    case music = "Music"
    case tvAndFilm = "TV & Film"
    case technology = "Technology"
    case sports = "Sports"
    case health = "Health"
    case gamesAndHobbies = "Games & Hobbies"
    
    
    
    case science = "Science"
    case other = "Other"
}

class Club {
    var numFollowers = 0
    var name = ""
    var id = ""
    var messageBoardId = ""
    var coverImage = UIImage()
    var imgUrl: URL?
    var isPublic = true
    var category = ClubCategory.none
    var update = ""
    var currentAlbumId = ""
    var currentAlbum: PodcastAlbum?
    var creatorId = ""
    var pendingUsersList = [String]()
    var subscribedUsers = [String]()
    
    
    init() {
        
    }
    
    init(record: CKRecord) {
        if let n = record["name"] as? String {
            self.name = n
        }
        if let f = record["numFollowers"] as? Int {
            self.numFollowers = f
        }
        if let category = record["category"] as? String {
            if let cat = ClubCategory(rawValue: category) {
                self.category = cat
            } else {
                self.category = ClubCategory.none
            }
        }
        if let isPublic = record["isPublic"] as? Int {
            if isPublic == 1 {
                self.isPublic = true
            } else {
                self.isPublic = false
            }
        }
        if let update = record["update"] as? String {
            self.update = update
        }
        if let albumId = record["currentAlbum"] as? String {
            self.currentAlbumId = albumId
        }
        if let creator = record["creator"] as? String {
            self.creatorId = creator
        }
        if let pendingUsers = record["pendingUsersList"] as? [String] {
            self.pendingUsersList = pendingUsers
        }
        if let subscribedUsers = record["subscribedUsers"] as? [String] {
            self.subscribedUsers = subscribedUsers
        }
        self.id = record.recordID.recordName

    }
}

