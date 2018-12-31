//
//  LastStepVC.swift
//  Cast Club
//
//  Created by Henry Macht on 12/31/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

class LastStepVC: UIViewController {
    
    var header = UILabel()
    let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHeader()

        // Do any additional setup after loading the view.
    }
    
    func createHeader(){
        header = UILabel(frame: CGRect(x: screenSize.width/8, y: screenSize.height/10, width: 300, height: 30))
        header.textAlignment = .left
        header.textColor = .black
        header.font = UIFont(name: "Mont-HeavyDEMO", size: 27)
        header.text = "One Last thing"
        self.view.addSubview(header)
    }
    
    func createSubHeader(text: String){
        header = UILabel(frame: CGRect(x: screenSize.width/8, y: screenSize.height/10 + 20, width: 100, height: 30))
        header.textAlignment = .left
        header.textColor = .black
        header.font = UIFont(name: "Avenir-Heavy", size: 16)
        header.text = text
        self.view.addSubview(header)
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
