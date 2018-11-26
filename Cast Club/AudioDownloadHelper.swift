//
//  AudioDownloadHelper.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/24/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import Foundation
import Alamofire

class AudioDownloadHelper {
    
    static let instance = AudioDownloadHelper()
    
    func getAudio(from url: String, completion: @escaping (URL?) -> ()) {
        if let u = URL(string: url) {
            var downloadTask: URLSessionDownloadTask = URLSessionDownloadTask()
            downloadTask = URLSession.shared.downloadTask(with: u, completionHandler: { (link, response, error) in
                completion(link)
            })
            downloadTask.resume()
        } else {
            print("No url")
            completion(nil)
        }
    }
}
