//
//  ClubCreationVC.swift
//  Cast Club
//
//  Created by Henry Macht on 12/31/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class ClubCreationVC: UIViewController {
    
    
    
    let clubCreationView = createView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), headerText: "Create a Club", placeholderText: "Club's Name")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(clubCreationView)
        
        clubCreationView.doneButton.addTarget(self, action: #selector(ClubCreationVC.done), for: .touchUpInside)
        //NotificationCenter.default.addObserver(self, selector: "textChanged:", name: UITextField.textDidChangeNotification, object: nil)

        // Do any additional setup after loading the view.
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        clubCreationView.clubNameInput.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is LastStepVC
        {
            let vc = segue.destination as? LastStepVC
            if let input = clubCreationView.clubNameInput.text {
                vc?.clubeName = input
            }
            
        }
    }
    
    @objc func done() {
        print("Done")
        self.performSegue(withIdentifier: "lastStep", sender: self)
        
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
