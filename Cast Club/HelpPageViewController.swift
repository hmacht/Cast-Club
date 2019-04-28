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
        
        if viewControllerIndex < 3 {
            
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
        return [self.newVC(viewController: "sbHelp0"), self.newVC(viewController: "sbHelp1"), self.newVC(viewController: "sbHelp2"), self.newVC(viewController: "sbUsername")]
    }()
    
    var pages:[UIViewController] = [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbHelp0"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbHelp1"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbHelp2"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbUsername")
    ]
    
    func newVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    let button = UIButton()
    let screenSize = UIScreen.main.bounds
    
    private func setupView() {
        
        let button = UIButton(frame: CGRect(x: 25, y: screenSize.height - screenSize.height/3.2 + 120, width: 100, height: 45))
        button.backgroundColor = UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 14)
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    var pageIndex = 1
    
    @objc func buttonAction(sender: UIButton!) {
        //Do whatever.
        print("ButtonTapped")
        
        
        
        // change page of PageViewController
        self.setViewControllers([self.pages[pageIndex]], direction: .forward, animated: true, completion: nil)
        pageIndex += 1
        
        if pageIndex == 4 {
            sender.isEnabled = false
        }
        
        
    }
    
    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        self.dataSource = self
        
        self.view.backgroundColor = .white
        
        removeSwipeGesture()
        
        self.setViewControllers([self.pages[0]], direction: .forward, animated: true, completion: nil)
        
        
        
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
