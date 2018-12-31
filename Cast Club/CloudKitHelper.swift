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
    
    // Types of records
    let ClubType = "Club"
    let AlbumType = "Album"
    let MessageType = "Message"
    
    func searchClubsWithName(_ name: String, completion: @escaping ([Club]?) -> ()) {
        let query = CKQuery(recordType: ClubType, predicate: NSPredicate(format: "name BEGINSWITH %@", name))
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
                        var c = Club()
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
                        if let messageId = r["messageBoardId"] as? String {
                            c.messageBoardId = messageId
                        }
                        if let asset = r["coverPhoto"] as? CKAsset {
                            c.imgUrl = asset.fileURL
                        }
                        results.append(c)
                    }
                    completion(results)
                }
            }
        }
    }
    
    func writeClub(name: String, img: UIImage, completion: @escaping (Error?) -> ()) {
        let record = CKRecord(recordType: ClubType)
        record["numFollowers"] = 0
        record["name"] = name
        
        // Save image
        let url = ImageHelper.saveToDisk(image: img)
        let asset = CKAsset(fileURL: url)
        record["coverPhoto"] = asset
        
        // TODO - find way to do random id
        record["messageBoardId"] = "someMBID"
        
        
        publicDB.save(record) { (record, error) in
            completion(error)
        }
    }
    
    func saveAlbumToPrivate(_ album: PodcastAlbum, completion: @escaping (Error?) -> ()) {
        // Create record for album
        let record = CKRecord(recordType: AlbumType)
        record["title"] = album.title
        record["artistName"] = album.artistName
        record["feedUrl"] = album.feedUrl
        record["numEpisodes"] = album.numEpisodes
        record["artworkUrl"] = album.artworkUrl100
        
        // Save it
        privateDB.save(record) { (record, error) in
            completion(error)
        }
    }
    
    func getAlbums(completion: @escaping ([PodcastAlbum], Error?) -> ()) {
        // Get all albums from private data base
        let query = CKQuery(recordType: AlbumType, predicate: NSPredicate(value: true))
        self.privateDB.perform(query, inZoneWith: nil) { (records, error) in
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
                    results.append(album)
                }
                completion(results, error)
            } else {
                completion([PodcastAlbum](), error)
            }
        }
    }
    
    func writeMessage(_ message: Message, completion: @escaping (Error?) -> ()) {
        let record = CKRecord(recordType: MessageType)
        record["clubId"] = message.clubId
        record["flags"] = message.flags
        record["fromUser"] = message.fromUser
        record["numLikes"] = message.numLikes
        record["text"] = message.text
        
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
                    results.append(message)
                }
                completion(results, error)
            } else {
                completion([Message](), error)
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
