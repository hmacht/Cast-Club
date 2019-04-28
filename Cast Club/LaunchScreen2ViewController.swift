//
//  LaunchScreen2ViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 4/28/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class LaunchScreen2ViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "startApp", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
