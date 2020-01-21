//
//  WindowExtension.swift
//  Delivigo
//
//  Created by Muhammad Naveed on 9/8/18.
//  Copyright © 2018 Muhammad Naveed. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    func switchRootViewController(_ viewController: UIViewController,  animated: Bool = true, duration: TimeInterval = 0.5, options: UIView.AnimationOptions = .transitionCrossDissolve, completion: (() -> Void)? = nil) {
        
        guard animated else {
            rootViewController = viewController
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}

extension UIApplication {
    

    func windowRootViewControllerPresent (vc: UIViewController ) {
         let window = UIApplication.shared.keyWindow
         vc.modalPresentationStyle = .fullScreen
         window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    

    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482458
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                
                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
    
    
    
}

extension NSObject {
    class var id: String {
        return String(describing: self)
    }
    
    class var className: String {
        return String(describing: self)
    }
}





extension  UIViewController {
    
    /// pop back to specific viewcontroller
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
}
