//
//  UITableView+RelodeWithAnimation.swift
//  Cast Club
//
//  Created by Henry Macht on 11/26/18.
//  Copyright © 2018 Henry Macht. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        
        
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight/2)
            cell.alpha = 0
        }
        for cell in cells {
            UIView.animate(withDuration: 0.5, delay: 0.08 * Double(delayCounter), options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1
            }, completion: nil)
            delayCounter += 1
        }
    }
}
