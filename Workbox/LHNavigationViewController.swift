//
//  LHNavigationViewController.swift
//  Workbox
//
//  Created by 刘海 on 2016/12/13.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class LHNavigationViewController: UINavigationController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    var transitioning:Bool = false;
    var stack:NSMutableArray = [];
    
    typealias codeBlock = () ->Void;
    
    override func viewDidLoad() {
        self.delegate = self;
        self.interactivePopGestureRecognizer?.delegate = self;
        self.navigationBar.tintColor = Color(red: 22.0, green: 22.0, blue: 22.0, alpha: 1.0);
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        print("UINavigationController pushViewController");
        return super.pushViewController(viewController, animated: animated);
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
//        print("UINavigationController popToRootViewController");
        return super.popToRootViewController(animated: animated);
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
//        print("UINavigationController popViewController");
        return super.popViewController(animated: animated);
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.isEnabled = true;
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers.first{
                return false;
            }
        }
        return true;
    }
    
}
