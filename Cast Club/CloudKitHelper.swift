//
//  CloudKitHelper.swift
//  Cast Club
//
//  Created by Toby Kreiman on 12/24/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit
import CloudKit

class CloudKitHelper {
    
    static let instance = CloudKitHelper()
    let publicDB = CKContainer.default().publicCloudDatabase
    let privateDB = CKContainer.default().privateCloudDatabase
    
    var userId = CKRecord.ID()
    
    // Types of records
    let ClubType = "Club"
    let AlbumType = "Album"
    let MessageType = "Message"
    let ClubHolderType = "ClubHolder"
    
    // Club stuff
    func searchClubsWithName(_ name: String, category: ClubCategory = ClubCategory.everything, completion: @escaping ([Club]?) -> ()) {
        var predicate = NSPredicate(format: "name BEGINSWITH %@", name)
        if category != .everything {
            predicate = NSPredicate(format: "name BEGINSWITH %@ AND category = %@", name, category.rawValue)
        }
        let query = CKQuery(recordType: ClubType, predicate: predicate)
        // Should add:
        // CKQueryOperation(query: query).desiredKeys = [blah blah blah without the image]
        // TO make faster then load in the image
        self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let e = error {
                print(e)
                completion(nil)
            } else {
                if let recs = records {
                    var results = [Club]()
                    for r in recs {
                        let c = Club()
                        // Get data from club
                        c.id = r.recordID.recordName
                        if let n = r["name"] as? String {
                            c.name = n
                        }
                        if let f = r["numFollowers"] as? Int {
                            c.numFollowers = f
                        }
                        if let id = r["recordName"] as? String {
                            c.id = id
                        }
                        if let category = r["category"] as? String {
                            if let cat = ClubCategory(rawValue: category) {
                                c.category = cat
                            } else {
                                c.category = ClubCategory.none
                            }
                        }
                        if let asset = r["coverPhoto"] as? CKAsset {
                            c.imgUrl = asset.fileURL
                        }
                        if let isPublic = r["isPublic"] as? Int {
                            if isPublic == 1 {
                                c.isPublic = true
                            } else {
                                c.isPublic = false
                            }
                        }
                        results.append(c)
                    }
                    completion(results)
                }
            }
        }
    }
    
    func writeClub(name: String, img: UIImage, isPublic: Bool, category: ClubCategory, completion: @escaping (Error?) -> ()) {
        let record = CKRecord(recordType: ClubType)
        record["numFollowers"] = 0
        record["name"] = name
        
        if isPublic {
            record["isPublic"] = 1
        } else {
            record["isPublic"] = 0
        }
        record["category"] = category.rawValue
        
        // Save image
        let url = ImageHelper.saveToDisk(image: img)
        let asset = CKAsset(fileURL: url)
        record["coverPhoto"] = asset
        
        
        
        publicDB.save(record) { (record, error) in
            completion(error)
        }
    }
    
    
    func getClubIdsForCurrentUser(completion: @escaping ([String], Error?) -> ()) {
        let query = CKQuery(recordType: ClubHolderType, predicate: NSPredicate(format: "fromUser BEGINSWITH %@", self.userId.recordName))
        
        self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let recs = records {
                if let firstRec = recs.first {
                    if let clubIds = firstRec["clubIds"] as? [String] {
                        completion(clubIds, error)
                    } else {
                        completion([String](), error)
                    }
                } else {
                    completion([String](), error)
                }
            } else {
                completion([String](), error)
            }
        }
    }
    
    func subscribeToClub(id: CKRecord.ID, completion: @escaping (Error?) -> ()) {
        
        let query = CKQuery(recordType: ClubHolderType, predicate: NSPredicate(format: "fromUser BEGINSWITH %@", self.userId.recordName))
        
        // Get the ClubHolder for user
        self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let recs = records {
                if let firstRec = recs.first {
                    var clubHolder = firstRec
                    if let ids = firstRec["clubIds"] as? [String] {
                        var userIds = ids
                        if !userIds.contains(id.recordName) {
                            userIds.append(id.recordName)
                        }
                        // Update the clubholder
                        clubHolder["clubIds"] = userIds
                        self.publicDB.save(clubHolder, completionHandler: { (_, e) in
                            completion(e)
                        })
                    } else {
                        completion(error)
                    }
                } else {
                    let record = CKRecord(recordType: self.ClubHolderType)
                    record["fromUser"] = self.userId.recordName
                    record["clubIds"] = [id.recordName]
                    self.publicDB.save(record, completionHandler: { (_, error) in
                        completion(error)
                    })
                }
            } else {
                completion(error)
            }
        }
    }
    
    func getClub(with id: String, completion: @escaping (Club, Error?) -> ()) {
        
        self.publicDB.fetch(withRecordID: CKRecord.ID(recordName: id)) { (record, error) in
            if let r = record {
                let c = Club()
                // Get data from club
                c.id = r.recordID.recordName
                if let n = r["name"] as? String {
                    c.name = n
                }
                if let f = r["numFollowers"] as? Int {
                    c.numFollowers = f
                }
                if let id = r["recordName"] as? String {
                    c.id = id
                }
                if let category = r["category"] as? String {
                    if let cat = ClubCategory(rawValue: category) {
                        c.category = cat
                    } else {
                        c.category = ClubCategory.none
                    }
                }
                if let asset = r["coverPhoto"] as? CKAsset {
                    c.imgUrl = asset.fileURL
                    if let img = c.imgUrl?.image() {
                        c.coverImage = img
                    }
                }
                completion(c, error)
            } else {
                completion(Club(), error)
            }
        }
    }
    
    func getClubQuickly(id: String, completion: @escaping (Club, Error?) -> ()) {
        //let query = CKQuery(recordType: ClubType, predicate: NSPredicate(format: "recordName BEGINSWITH %@", id))
        //let operation = CKQueryOperation(query: query)
        let operation = CKFetchRecordsOperation(recordIDs: [CKRecord.ID(recordName: id)])
        operation.qualityOfService = .userInteractive
        let time = Date.timeIntervalSinceReferenceDate
        operation.perRecordCompletionBlock = { record, _, error in
            if let rec = record {
                print(rec["name"], Date.timeIntervalSinceReferenceDate - time)
            }
        }
        
        publicDB.add(operation)
        
        completion(Club(), nil)
    }
    
    func getTopClubs(n: Int, completion: @escaping (Club) -> ()) {
        let query = CKQuery(recordType: ClubType, predicate: NSPredicate(value: true))
        // Sort so that you get the biggest first
        query.sortDescriptors = [NSSortDescriptor(key: "numFollowers", ascending: false)]
        let operation = CKQueryOperation(query: query)
        // Limit on num results
        operation.resultsLimit = n
        
        // Gets called once for each record
        operation.recordFetchedBlock = { r in
            let c = Club()
            // Get data from club
            if let n = r["name"] as? String {
                c.name = n
            }
            if let f = r["numFollowers"] as? Int {
                c.numFollowers = f
            }
            if let id = r["recordName"] as? String {
                c.id = id
            }
            if let category = r["category"] as? String {
                if let cat = ClubCategory(rawValue: category) {
                    c.category = cat
                } else {
                    c.category = ClubCategory.none
                }
            }
            if let isPublic = r["isPublic"] as? Int {
                if isPublic == 1 {
                    c.isPublic = true
                } else {
                    c.isPublic = false
                }
            }
            if let asset = r["coverPhoto"] as? CKAsset {
                c.imgUrl = asset.fileURL
                if let img  = c.imgUrl?.image() {
                    c.coverImage = img
                }
            }
            completion(c)
        }
        
        self.publicDB.add(operation)
    }
    
    // Get the user's id
    func setCurrentUserId(completion: @escaping (Error?) -> ()) {
        CKContainer.default().fetchUserRecordID { (id, error) in
            if let idenctification = id {
                print("The ID", id)
                self.userId = idenctification
            } else {
                print("NO ID")
            }
            completion(error)
        }
    }
    
    // Album stuff
    func saveAlbumToPrivate(_ album: PodcastAlbum, completion: @escaping (Error?) -> ()) {
        // Search to see if it already exists
        let query = CKQuery(recordType: AlbumType, predicate: NSPredicate(format: "feedUrl BEGINSWITH %@ AND title = %@", album.feedUrl, album.title))
        
        self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let e = error {
                completion(e)
            } else {
                if let rec = records?.first {
                    // We have found the record
                    if var subscribedUsers = rec["subscribedUsers"] as? [String] {
                        subscribedUsers.append(self.userId.recordName)
                        rec["subscribedUsers"] = subscribedUsers
                        self.publicDB.save(rec, completionHandler: { (_, error3) in
                            completion(error3)
                        })
                    }
                } else {
                    // That record does not exist yet
                    // Create record for album
                    let record = CKRecord(recordType: self.AlbumType)
                    record["title"] = album.title
                    record["artistName"] = album.artistName
                    record["feedUrl"] = album.feedUrl
                    record["numEpisodes"] = album.numEpisodes
                    record["artworkUrl"] = album.artworkUrl100
                    record["subscribedUsers"] = [self.userId.recordName]
                    
                    // Save it
                    self.publicDB.save(record) { (record, e2) in
                        completion(e2)
                    }
                }
            }
        }
        
        
    }
    
    func getAlbums(completion: @escaping ([PodcastAlbum], Error?) -> ()) {
        // Get all albums from private data base
        let query = CKQuery(recordType: AlbumType, predicate: NSPredicate(format: "subscribedUsers CONTAINS %@", self.userId.recordName))
        self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let recs = records {
                var results = [PodcastAlbum]()
                // Create new PodcastAlbum instance for each record returned
                for r in recs {
                    let album = PodcastAlbum()
                    if let title = r["title"] as? String {
                        album.title = title
                    }
                    if let artistName = r["artistName"] as? String {
                        album.artistName = artistName
                    }
                    if let numEpisodes = r["numEpisodes"] as? Int {
                        album.numEpisodes = numEpisodes
                    }
                    if let feedUrl = r["feedUrl"] as? String {
                        album.feedUrl = feedUrl
                    }
                    if let artworkUrl = r["artworkUrl"] as? String {
                        album.artworkUrl100 = artworkUrl
                    }
                    album.recordId = r.recordID
                    results.append(album)
                }
                completion(results, error)
            } else {
                completion([PodcastAlbum](), error)
            }
        }
    }
    
    func unsubsribe(from album: PodcastAlbum, completion: @escaping (Error?) -> ()) {
        // Delete the album from the users database
        // Fetch the album
        self.publicDB.fetch(withRecordID: album.recordId) { (record, error) in
            if let e = error {
                completion(e)
            } else {
                if let rec = record {
                    // Get list of users
                    if var subscribedUsers = rec["subscribedUsers"] as? [String] {
                        if let ind = subscribedUsers.firstIndex(of: self.userId.recordName) {
                            // Remove user from list
                            subscribedUsers.remove(at: ind)
                            rec["subscribedUsers"] = subscribedUsers
                            self.publicDB.save(rec, completionHandler: { (_, error2) in
                                completion(error2)
                            })
                        }
                    }
                } else {
                    completion(error)
                }
            }
        }
    }
    
    // Message stuff
    func writeMessage(_ message: Message, completion: @escaping (Error?) -> ()) {
        let record = CKRecord(recordType: MessageType)
        record["clubId"] = message.clubId
        record["flags"] = message.flags
        record["fromUser"] = message.fromUser
        record["numLikes"] = message.numLikes
        record["text"] = message.text
        record["fromMessageId"] = message.fromMessageId
        record["likedUsersList"] = message.likedUsersList
        
        publicDB.save(record) { (record, error) in
            completion(error)
        }
    }
    
    func getMessagesForClub(_ clubId: String, completion: @escaping ([Message], Error?) -> ()) {
        let query = CKQuery(recordType: MessageType, predicate: NSPredicate(format: "clubId = %@", clubId))
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let recs = records {
                var results = [Message]()
                
                for r in recs {
                    var message = Message()
                    message.id = r.recordID.recordName
                    if let text = r["text"] as? String {
                        message.text = text
                    }
                    if let clubId = r["clubId"] as? String {
                        message.clubId = clubId
                    }
                    if let flags = r["flags"] as? Int {
                        message.flags = flags
                    }
                    if let numLikes = r["numLikes"] as? Int {
                        message.numLikes = numLikes
                    }
                    if let fromUser = r["fromUser"] as? String {
                        message.fromUser = fromUser
                    }
                    if let fromMessageId = r["fromMessageId"] as? String {
                        message.fromMessageId = fromMessageId
                    }
                    if let likedUsersList = r["likedUsersList"] as? [String] {
                        message.likedUsersList = likedUsersList
                    }
                    results.append(message)
                }
                completion(results, error)
            } else {
                completion([Message](), error)
            }
        }
    }
    
    func getMessagesInReply(to messageId: String, completion: @escaping ([Message], Error?) -> ()) {
        let query = CKQuery(recordType: MessageType, predicate: NSPredicate(format: "fromMessageId = %@", messageId))
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let recs = records {
                var results = [Message]()
                
                for r in recs {
                    var message = Message()
                    message.id = r.recordID.recordName
                    if let text = r["text"] as? String {
                        message.text = text
                    }
                    if let clubId = r["clubId"] as? String {
                        message.clubId = clubId
                    }
                    if let flags = r["flags"] as? Int {
                        message.flags = flags
                    }
                    if let numLikes = r["numLikes"] as? Int {
                        message.numLikes = numLikes
                    }
                    if let fromUser = r["fromUser"] as? String {
                        message.fromUser = fromUser
                    }
                    if let fromMessageId = r["fromMessageId"] as? String {
                        message.fromMessageId = fromMessageId
                    }
                    if let likedUsersList = r["likedUsersList"] as? [String] {
                        message.likedUsersList = likedUsersList
                    }
                    results.append(message)
                }
                completion(results, error)
            } else {
                completion([Message](), error)
            }
        }
    }
    
    func flagMessageWithId(_ id: CKRecord.ID, completion: @escaping (Error?) -> ()) {
        // Obtain message
        self.publicDB.fetch(withRecordID: id) { (record, error) in
            if let e = error {
                completion(e)
            } else {
                if let rec = record {
                    // Read current flags
                    if let currentFlags = rec["flags"] as? Int {
                        // Update flags and save
                        rec["flags"] = currentFlags + 1
                        self.publicDB.save(rec, completionHandler: { (_, e2) in
                            completion(e2)
                        })
                    }
                }
            }
        }
    }
    
    func likeMessageWithId(_ id: CKRecord.ID, completion: @escaping (Error?) -> ()) {
        // Obtain message
        self.publicDB.fetch(withRecordID: id) { (record, error) in
            if let e = error {
                completion(e)
            } else {
                if let rec = record {
                    // Read current likes
                    if let currentLikes = rec["numLikes"] as? Int {
                        // Update flags and save
                        rec["numLikes"] = currentLikes + 1
                        if var likedUsersList = rec["likedUsersList"] as? [String] {
                            likedUsersList.append(self.userId.recordName)
                            rec["likedUsersList"] = likedUsersList
                        } else {
                            rec["likedUsersList"] = [self.userId.recordName]
                        }
                        self.publicDB.save(rec, completionHandler: { (_, e2) in
                            completion(e2)
                        })
                    }
                }
            }
        }
    }
    
    func unlikeMessageWithId(_ id: CKRecord.ID, completion: @escaping (Error?) -> ()) {
        // Obtain message
        self.publicDB.fetch(withRecordID: id) { (record, error) in
            if let e = error {
                completion(e)
            } else {
                if let rec = record {
                    // Read current likes
                    if let currentLikes = rec["numLikes"] as? Int {
                        // Update flags and save
                        rec["numLikes"] = max(currentLikes - 1, 0)
                        if var likedUsersList = rec["likedUsersList"] as? [String] {
                            if let ind = likedUsersList.firstIndex(of: self.userId.recordName) {
                                likedUsersList.remove(at: ind)
                            }
                            rec["likedUsersList"] = likedUsersList
                        }
                        self.publicDB.save(rec, completionHandler: { (_, e2) in
                            completion(e2)
                        })
                    }
                }
            }
        }
    }
    
    
    
}

extension URL {
    func image() -> UIImage? {
        if let data = try? Data(contentsOf: self) {
            return UIImage(data: data)
        }
        
        return nil
    }
}

struct ImageHelper {
    static func saveToDisk(image: UIImage, compression: CGFloat = 1.0) -> URL {
        var fileURL = FileManager.default.temporaryDirectory
        let filename = UUID().uuidString
        fileURL.appendPathComponent(filename)
        let data = image.jpegData(compressionQuality: compression)
        if let d = data {
            do {
                try d.write(to: fileURL)
            } catch {
                print("erorr writting url")
            }
        }
        return fileURL
    }
}


extension String {
    func ckId() -> CKRecord.ID {
        return CKRecord.ID(recordName: self)
    }
}
