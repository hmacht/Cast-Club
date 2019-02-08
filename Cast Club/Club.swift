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
    case comedy = "Comedy"
    case arts = "Arts"
    case business = "Business"
    case education = "Education"
    case gamesAndHobbies = "Games & Hobbies"
    case health = "Health"
    case kids = "Kids"
    case music = "Music"
    case science = "Science"
    case sports = "Sports"
    case tvAndFilm = "TV & Film"
    case technology = "Technology"
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
}

