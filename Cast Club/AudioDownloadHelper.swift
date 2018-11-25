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
    
    func getAudioFromUrl(_ url: String, completion: @escaping (Data?) -> ()) {
        if let u = URL(string: url) {
            Alamofire.download(u).responseData { (data) in
                print("in alamo")
                if let value = data.value {
                    completion(value)
                } else {
                    print("cant retrieve data")
                    completion(nil)
                }
            }
        } else {
            print("Error with url")
            completion(nil)
        }
    }
    
    func getAudio(from url: String, completion: @escaping (URL?) -> ()) {
        print(url)
        if let u = URL(string: url) {
            var downloadTask: URLSessionDownloadTask = URLSessionDownloadTask()
            downloadTask = URLSession.shared.downloadTask(with: u, completionHandler: { (link, response, error) in
                if link == nil {
                    print("nilly nilly")
                }
                completion(link)
            })
            downloadTask.resume()
        } else {
            print("No url")
            completion(nil)
        }
    }
}
