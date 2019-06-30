//
//  LaunchScreenViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 4/28/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit
import CloudKit

class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CloudKitHelper.instance.setCurrentUserId { (error) in
            if let e = error {
                print(e)
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "startApp", sender: self)
                }
                
            } else {
                CloudKitHelper.instance.isAuthenticated = true
                // Get user subscriptions albums
                CloudKitHelper.instance.getAlbums { (albums, error2) in
                    if let e = error2 {
                        print(e)
                        
                        
                        CloudKitHelper.instance.internetErrorDescription = "Oops, there was an error connecting to the server. Check your internet connection."
                        // If error, start app
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "startApp", sender: self)
                        }
                        
                    } else if albums.count > 0 {
                        subscriptionAlbum = albums
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "startApp", sender: self)
                        }
                    } else if albums.count == 0 {
                        print("here")
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "startApp", sender: self)
                        }
                    }
                }
                
                // Get user subscribed clubs
                CloudKitHelper.instance.getClubIdsForCurrentUser(completion: { (results, error3) in
                    if let e = error3 {
                        self.tabBarController?.showError(with: e.localizedDescription)
                    } else {
                        //clubIds = results
                        print("Done here")
                    }
                })
                
                
            }
        }
    }
    
}
