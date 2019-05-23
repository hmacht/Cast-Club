//
//  Club.swift
//  Cast Club
//
//  Created by Toby Kreiman on 12/24/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

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
}

