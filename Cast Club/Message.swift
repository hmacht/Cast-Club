//
//  Message.swift
//  Cast Club
//
//  Created by Toby Kreiman on 12/30/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import Foundation

struct Message {
    var fromUser = ""
    var text = ""
    var numLikes = 0
    var flags = 0
    var clubId = ""
    var fromMessageId = ""
    var id = ""
    var likedUsersList = [String]()
    var flaggedUsersList = [String]()
    var fromUsername = ""
}
