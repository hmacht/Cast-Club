//
//  SearchPodcastsViewController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/23/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class SearchPodcastsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let screenSize = UIScreen.main.bounds

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hintLabel: UILabel!
    
    var searchResults = [PodcastAlbum]()
    var selectedAlbum = PodcastAlbum()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set delegates for tableview
        tableView.delegate = self
        tableView.dataSource = self
        // Set delegate for search bar
        searchBar.delegate = self
        
        
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        tableView.keyboardDismissMode = .onDrag
        
        self.createActivityIndicator()
        
    }
    
    
    func createActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        self.activityIndicator.frame = CGRect(x: self.view.frame.width/2 - 20, y: self.view.frame.height/2 - 20, width: 40, height: 40)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
        self.view.addSubview(self.activityIndicator)
    }
    
    
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
            imgView.layer.cornerRadius = 4.0
            imgView.clipsToBounds = true
            if let img = searchResults[indexPath.row].artworkImage {
                imgView.image = img
            } else {
                imgView.image = UIImage(named: "Group 224")
                DispatchQueue.global(qos: .background).async {
                    _ = self.searchResults[indexPath.row].getImageData { (image) in
                        if let img = image {
                            DispatchQueue.main.async {
                                imgView.image = img
                            }
                        }
                    }
                }
            }
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAlbum = self.searchResults[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()
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
        
        // Show loading
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        TunesHelper.instance.searchiTunes(term: searchBar.text!) { (success, results) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if success {
                if let r = results {
                    self.searchResults = r
                    self.tableView.reloadWithAnimation()
                }
            } else {
                print("error in itunes api helper")
            }
        }
        hintLabel.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }

}
