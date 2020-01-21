//
//  NativeAlerts.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/18/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


typealias Action = () -> ()

var action: Action = { }


extension UIView {
    var parentVC: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }

}

extension UIView {
    //And add the functions of the protocol
    func presentAlert(title:String = "Alert".localized, message:String, ok: @escaping () -> Void, cancel: (() -> Void)? ){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let options = ["CANCEL".localized, "OK".localized]
        
        for (index, option) in options.enumerated() {
            if index == 0 {
                alertController.addAction(UIAlertAction.init(title: option, style: .cancel, handler: { (action) in
                    cancel?()
                }))
            }
            else {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    ok()
                }))
            }
            
        }
        //self.parentVC?.present(alertController, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //And add the functions of the protocol
    func presentAlert(title:String = "Alert".localized, message:String, no: (() -> Void)?, login: (() -> Void)? ){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let options = ["NO".localized, "Login".localized]
        
        for (index, option) in options.enumerated() {
            if index == 0 {
                alertController.addAction(UIAlertAction.init(title: option, style: .cancel, handler: { (action) in
                    no?()
                }))
            }
            else {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    login?()
                }))
            }
            
        }
        //self.parentVC?.present(alertController, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func presentAlert(title: String = "Please Confirm".localized, message: String, yes: @escaping () -> Void, no: (() -> Void)? ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let options = ["NO".localized, "YES".localized]
        
        for (index, option) in options.enumerated() {
            if index == 0 {
                alertController.addAction(UIAlertAction.init(title: option, style: .cancel, handler: { (action) in
                    no?()
                    
                }))
            }
            else {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    yes()
                }))
            }
            
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func alertMessage(title: String = "Alert".localized, message: String, btnTitle: String = "Try Again".localized, completion: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        alertController.addAction(UIAlertAction.init(title: btnTitle, style: .default, handler: { (action) in
            completion()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    
    
    func shareInApp(str: String)  {
        let items = [str]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(ac, animated: true, completion: nil)
    }
}

extension UIViewController {
    //And add the functions of the protocol
    func presentAlert(title:String = "Alert".localized, message:String, ok: @escaping () -> Void, cancel: (() -> Void)? ){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let options = ["CANCEL".localized, "OK".localized]
        
        for (index, option) in options.enumerated() {
            if index == 0 {
                alertController.addAction(UIAlertAction.init(title: option, style: .cancel, handler: { (action) in
                   cancel?()
                }))
            }
            else {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    ok()
                }))
            }
            
        }
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func presentAlert(title: String = "Please Confirm".localized, message: String, yes: @escaping () -> Void, no: (() -> Void)? ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let options = ["NO".localized, "YES".localized]
        
        for (index, option) in options.enumerated() {
            if index == 0 {
                alertController.addAction(UIAlertAction.init(title: option, style: .cancel, handler: { (action) in
                    no?()
                    
                }))
            }
            else {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    yes()
                }))
            }
            
        }
         self.present(alertController, animated: true, completion: nil)
    }
    
    
    func presentAlert(title: String = "Please Confirm".localized, message: String, view: @escaping () -> Void, cancel: (() -> Void)? ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let options = ["Cancel".localized, "VIEW".localized]
        
        for (index, option) in options.enumerated() {
            if index == 0 {
                alertController.addAction(UIAlertAction.init(title: option, style: .cancel, handler: { (action) in
                    cancel?()
                    
                }))
            }
            else {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    view()
                }))
            }
            
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertMessage(title: String = "Alert".localized, message: String, btnTitle: String = "Try Again".localized, completion: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        alertController.addAction(UIAlertAction.init(title: btnTitle, style: .default, handler: { (action) in
            completion()
        }))
         self.present(alertController, animated: true, completion: nil)
    }
    
}
