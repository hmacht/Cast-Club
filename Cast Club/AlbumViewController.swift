//
//  AlbumViewController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/23/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var numEpisodesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var album = PodcastAlbum()
    var podcastResults = [Podcast]()
    
    var selectedPodcast = Podcast()
    
    
    override func viewDidLoad() {
        // Set delegates
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imgView.image = self.album.artworkImage
        self.titleLabel.text = self.album.title
        self.artistLabel.text = self.album.artistName
        self.numEpisodesLabel.text = String(self.album.numEpisodes) + " Episodes"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        FeedHelper.instance.readFeed(url: album.feedUrl) { (podcasts) in
            if let podcastList = podcasts {
                self.podcastResults = podcastList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Cant read podcasts")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayPodcast" {
            let destination = segue.destination as! PlayPodcastViewController
            if let img = self.album.artworkImage {
                destination.coverImage = img
            }
            destination.selectedPodcast = self.selectedPodcast
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PodcastCell") as! UITableViewCell
        
        let podcast = podcastResults[indexPath.row]
        
        if let titleLabel = cell.viewWithTag(1) as? UILabel {
            titleLabel.text = String(indexPath.row + 1) + ". " + podcast.title
        }
        if let descriptionLabel = cell.viewWithTag(2) as? UILabel {
            descriptionLabel.text = podcast.description
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPodcast = self.podcastResults[indexPath.row]
        self.performSegue(withIdentifier: "toPlayPodcast", sender: self)
    }

}
