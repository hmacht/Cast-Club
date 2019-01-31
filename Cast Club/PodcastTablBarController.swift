//
//  PodcastTablBarController.swift
//  Cast Club
//
//  Created by Toby Kreiman on 11/28/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class PodcastTablBarController: UITabBarController {
    
    var audioController: MiniController?
    
    var errorPopUp = ErrorView()
    var blockerView = UIView()
    var clubIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.blockerView.frame = self.view.frame
        self.blockerView.backgroundColor = .clear
        self.blockerView.isUserInteractionEnabled = false
        self.view.addSubview(blockerView)
        
        self.errorPopUp = ErrorView(frame: CGRect(x: self.view.frame.width/2 - 125, y: self.view.frame.height/2 - 100, width: 250, height: 200), message: ErrorMessage.basic.rawValue)
        self.errorPopUp.okButton.addTarget(self, action: #selector(PodcastTablBarController.hide), for: .touchUpInside)
        self.errorPopUp.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.view.addSubview(errorPopUp)
        
    }
    
    /*func showError(with message: String) {
        
        /*self.blockerView.isUserInteractionEnabled = true
        self.errorPopUp.message = message
        self.errorPopUp.messageLabel.text = self.errorPopUp.message
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: [], animations: {
            self.errorPopUp.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)*/
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }*/
    
    @objc func hide() {
        /*self.blockerView.isUserInteractionEnabled = false
    
        UIView.animate(withDuration: 0.4, animations: {
            self.errorPopUp.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (success) in
            self.errorPopUp.transform = CGAffineTransform(scaleX: 0, y: 0)
        }*/
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


extension UITabBarController {
    
    func showError(with message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
