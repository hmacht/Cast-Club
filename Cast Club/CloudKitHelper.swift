//
//  CloudKitHelper.swift
//  Cast Club
//
//  Created by Toby Kreiman on 12/24/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitHelper {
    
    static let instance = CloudKitHelper()
    let containter = CKContainer.default()
    let publicDB = CKContainer.default().publicCloudDatabase
    let ClubType = "Club"
    
    func searchClubsWithName(name: String, completion: @escaping ([CKRecord]?) -> ()) {
        let query = CKQuery(recordType: ClubType, predicate: NSPredicate(format: "name = '\(name)'"))
        
        self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            print("gaddi")
            if let e = error {
                print(e)
                completion(nil)
            } else {
                print(records?.count)
                if let recs = records {
                    for r in recs {
                        print(r.allKeys())
                    }
                    completion(records)
                }
            }
        }
    }
}
