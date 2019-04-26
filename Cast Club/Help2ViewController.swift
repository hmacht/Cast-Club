//
//  Help2ViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 4/25/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class Help2ViewController: UIViewController {

    let screenSize = UIScreen.main.bounds
    
    var headerLabel = UILabel()
    
    var detailLabel = UILabel()
    
    var image = UIImageView()
    
    func createImage(){
        let sideLemgth = screenSize.width
        image = UIImageView(frame: CGRect(x: screenSize.width/2 - sideLemgth/2, y: 40, width: sideLemgth, height: sideLemgth))
        image.image = UIImage(named: "mirage-message-sent")
        image.contentMode = .scaleAspectFill
        self.view.addSubview(image)
    }
    
    func createHeaderLabel(){
        headerLabel = UILabel(frame: CGRect(x: 25, y: screenSize.height - screenSize.height/2.4, width: 200, height: 50))
        headerLabel.text = "Join a Club"
        headerLabel.font = UIFont(name: "Avenir-Black", size: 20)
        headerLabel.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        self.view.addSubview(headerLabel)
    }
    
    func createDetailesLabel(){
        detailLabel = UILabel(frame: CGRect(x: 25, y: headerLabel.frame.maxY - 20, width: screenSize.width - 50, height: 80))
        detailLabel.text = "Podcast clubs allow you to talk with your friends about the podcast that you love. They also help with finding new podcast to listen to."
        detailLabel.font = UIFont(name: "Avenir-Medium", size: 14)
        detailLabel.textColor = UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        detailLabel.numberOfLines = 3
        self.view.addSubview(detailLabel)
    }
    
    func createNextButton(){
        let button = UIButton(frame: CGRect(x: 25, y: detailLabel.frame.maxY + 10, width: 100, height: 45))
        button.backgroundColor = UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        button.setTitle("Begin", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 14)
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(Help1ViewController.next(sender: )), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    
    @objc func next(sender: UIButton!) {
        print("Button tapped")
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImage()
        createHeaderLabel()
        createDetailesLabel()
        createNextButton()
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
