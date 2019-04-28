//
//  fadeSegue.swift
//  Cast Club
//
//  Created by Henry Macht on 4/28/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import Foundation
import UIKit

class FadeOutPopSegue: UIStoryboardSegue {
    
    override func perform() {
        
        if var sourceViewController = self.source as? UIViewController, var destinationViewController = self.destination as? UIViewController {
            
            var transition: CATransition = CATransition()
            
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            
            sourceViewController.view.window?.layer.add(transition, forKey: "kCATransition")
            sourceViewController.navigationController?.popViewController(animated: false)
        }
    }
    
}
