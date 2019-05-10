//
//  HelpViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 5/9/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit
import MessageUI

class HelpViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Help"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Group 909"), style: .done, target: self, action: #selector(HelpViewController.moreHelp))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func moreHelp(){
        print("more help")
        
        createEmail(reasoning: "Question", explanation: "Ask us any question you have and we will get back as soon as possible")
    }
    
    func createEmail(reasoning: String, explanation: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["podtalkdevelopers@gmail.com"])
            mail.setSubject(reasoning)
            mail.setMessageBody("<b>\(explanation)</b> \n <p>Question: </p>", isHTML: true)
            
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
