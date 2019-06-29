//
//  AudioDownloadHelper.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/24/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import Foundation
import Alamofire

class AudioDownloadHelper: NSObject, URLSessionDownloadDelegate {
    
    static let instance = AudioDownloadHelper()
    
    var downloadedPodcasts = [Podcast]()
    
    // The path on the phone where the file will be saved
    var fileSavePath = URL(string: "")
    // The podcast being downloaded
    var podcast = Podcast()
    
    var loadingWheel = LoadingView()
    
    
    func getAudio(from url: String, completion: @escaping (URL?, String) -> ()) {
        if let u = URL(string: url) {
            var downloadTask: URLSessionDownloadTask = URLSessionDownloadTask()
            downloadTask = URLSession.shared.downloadTask(with: u, completionHandler: { (link, response, error) in
                completion(link, url)
            })
            downloadTask.resume()
        } else {
            print("No url")
            completion(nil, url)
        }
    }
    
    func downLoadFileWithProgress(withUrl url: URL, andFilePath filePath: URL, loadingView: LoadingView, podcast: Podcast) {
        print("Downloading with progress")
        
        self.fileSavePath = filePath
        self.loadingWheel = loadingView
        self.podcast = podcast
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = session.downloadTask(with: url)
        
        downloadTask.resume()
        
        
    }
    
    func currentFileDirecory(baseUrl: String) -> URL? {
        
        // Get the documents directory
        if let url = URL(string: baseUrl) {
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false) {
                
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)
                
                do {
                    if try filePath.checkResourceIsReachable() {
                        print("file exist")
                        return filePath
                        
                    } else {
                        print("file doesnt exist 1")
                        return nil
                    }
                } catch {
                    print("file doesnt exist 2")
                    return nil
                }
            } else {
                print("file doesnt exist 3")
                return nil
            }
        } else {
            print("file doesnt exist 4")
            return nil
        }
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Done downloading to", location.absoluteString)
        
        
        do {
            if let savePath = self.fileSavePath {
                let data = try Data.init(contentsOf: location)
                try data.write(to: savePath, options: .atomic)
                print("saved at \(savePath.absoluteString)")
                
                self.podcast.fileUrl = savePath.absoluteString
                
                self.downloadedPodcasts.append(podcast)
                // Encode the downloaded podcasts array into data
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.downloadedPodcasts)
                UserDefaults.standard.set(encodedData, forKey: "dowloadedPodcasts")
                
            }
        } catch {
            print("an error happened while downloading or saving the file")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        print(percentage)
        
        DispatchQueue.main.async {
            self.loadingWheel.animateCircle(percent: percentage)
        }
    }
}


