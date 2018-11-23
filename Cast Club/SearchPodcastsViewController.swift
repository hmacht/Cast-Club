//
//  SearchPodcastsViewController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/23/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class SearchPodcastsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults = [PodcastAlbum]()
    var selectedAlbum = PodcastAlbum()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set delegates for tableview
        tableView.delegate = self
        tableView.dataSource = self
        // Set delegate for search bar
        searchBar.delegate = self
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! UITableViewCell
        
        if let titleLabel = cell.viewWithTag(1) as? UILabel {
            titleLabel.text = searchResults[indexPath.row].title
        }
        
        if let artistLabel = cell.viewWithTag(2) as? UILabel {
            artistLabel.text = searchResults[indexPath.row].artistName
        }
        
        if let numEpisodesLabel = cell.viewWithTag(3) as? UILabel {
            numEpisodesLabel.text = String(searchResults[indexPath.row].numEpisodes) + " Episodes"
        }
        if let imgView = cell.viewWithTag(4) as? UIImageView {
            if let img = searchResults[indexPath.row].artworkImage {
                imgView.image = img
            } else {
                if let img = searchResults[indexPath.row].getImageData() {
                    imgView.image = img
                }
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAlbum = self.searchResults[indexPath.row]
        self.performSegue(withIdentifier: "toAlbumView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbumView" {
            let destination = segue.destination as! AlbumViewController
            destination.album = self.selectedAlbum
        }
    }
    
    // Search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        TunesHelper.instance.searchiTunes(term: searchBar.text!) { (success, results) in
            if success {
                if let r = results {
                    self.searchResults = r
                    self.tableView.reloadData()
                }
            } else {
                print("error in itunes api helper")
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }

}
