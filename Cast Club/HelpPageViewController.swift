//
//  HelpPageViewController.swift
//  Cast Club
//
//  Created by Henry Macht on 4/25/19.
//  Copyright © 2019 Henry Macht. All rights reserved.
//

import UIKit

class HelpPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderViewController.index(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex > 0 {
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else  {
                return orderViewController.last
            }
            
            guard orderViewController.count > previousIndex else {
                return nil
            }
            
            return orderViewController[previousIndex]
        } else {
            return nil
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderViewController.index(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex < 1 {
            
            let nextIndex = viewControllerIndex + 1
            
            guard orderViewController.count != nextIndex else  {
                return orderViewController.first
            }
            
            guard orderViewController.count > nextIndex else {
                return nil
            }
            
            return orderViewController[nextIndex]
        } else {
            return nil
        }
    }
    
    lazy var orderViewController: [UIViewController] = {
        return [self.newVC(viewController: "sbHelp1"), self.newVC(viewController: "sbHelp2")]
    }()
    
    func newVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        self.view.backgroundColor = .white
        
        if let firstViewController = orderViewController.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
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
