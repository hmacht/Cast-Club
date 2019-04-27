//
//  CreateUsernameVC.swift
//  Cast Club
//
//  Created by Henry Macht on 1/29/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class CreateUsernameVC: UIViewController {
    
    var fromSettings = false
    
    

    let usernameCreationView = createView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), headerText: "Enter a Name", placeholderText: "Username")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(usernameCreationView)
        
        if fromSettings == false{
            usernameCreationView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        usernameCreationView.doneButton.addTarget(self, action: #selector(CreateUsernameVC.done), for: .touchUpInside)
        usernameCreationView.header.numberOfLines = 2
        //NotificationCenter.default.addObserver(self, selector: "textChanged:", name: UITextField.textDidChangeNotification, object: nil)
        
        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        if fromSettings {
            usernameCreationView.clubNameInput.becomeFirstResponder()
        }
        
    }
    
    @objc func done() {
        if let text = usernameCreationView.clubNameInput.text {
            CloudKitHelper.instance.username = text
            CloudKitHelper.instance.setUsername(username: text) { (error) in
                if let e = error {
                    print(e)
                }
            }
        }
        
        if fromSettings{
            self.navigationController?.popViewController(animated: true)
        } else {
            performSegue(withIdentifier: "toHome", sender: self)
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

}
