//
//  Help0ViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 4/27/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class Help0ViewController: UIPageViewController {
    
    let screenSize = UIScreen.main.bounds
    
    func createImage(){
        let sideLemgth = screenSize.width * 0.7
        let image = UIImageView(frame: CGRect(x: 25, y: 0, width: sideLemgth, height: sideLemgth))
        image.center.y = (screenSize.height / 2) - 50
        image.image = UIImage(named: "Group 907")
        image.contentMode = .scaleAspectFit
        self.view.addSubview(image)
    }
    
    func createNextButton(){
        let button = UIButton(frame: CGRect(x: 25, y: screenSize.height - screenSize.height/3.2 + 120, width: 100, height: 45))
        button.backgroundColor = UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 14)
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(Help1ViewController.next(sender: )), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    
    @objc func next(sender: UIButton!) {
        print("Button tapped")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImage()
        //createNextButton()

        // Do any additional setup after loading the view.
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
