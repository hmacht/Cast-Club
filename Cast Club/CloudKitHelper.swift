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
    let ClubType = "Club"
    
    func searchClubsWithName(_ name: String, completion: @escaping ([Club]?) -> ()) {
        let query = CKQuery(recordType: ClubType, predicate: NSPredicate(format: "name BEGINSWITH %@", name))
        // Should add:
        // CKQueryOperation(query: query).desiredKeys = [blah blah blah without the image]
        // TO make faster then load in the image
        self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            print("gaddi")
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
