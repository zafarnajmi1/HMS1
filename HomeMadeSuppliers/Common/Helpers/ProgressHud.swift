//
//  ProgressHud.swift
//  Baqala
//
//  Created by apple on 2/21/19.
//  Copyright © 2019 My Technology. All rights reserved.
//

import Foundation

import UIKit
import MBProgressHUD

class ProgressHUD: MBProgressHUD {
    
    private static var sharedView: ProgressHUD!
    
    @discardableResult
    func mode(mode: MBProgressHUDMode) -> ProgressHUD {
        self.mode = mode
        return self
    }
    
    @discardableResult
    func animationType(animationType: MBProgressHUDAnimation) -> ProgressHUD {
        self.animationType = animationType
        return self
    }
    
    @discardableResult
    func backgroundViewStyle(style: MBProgressHUDBackgroundStyle) -> ProgressHUD {
        self.backgroundView.style = style
        return self
    }
    
    
   class func progress(text: String)  {
        ProgressHUD.sharedView.label.text = text
    }
    
    class func ProgressHudSharedView() -> ProgressHUD {
        return ProgressHUD.sharedView
    }
    
    @discardableResult
    class func present(animated: Bool) -> ProgressHUD {
        if sharedView != nil {
            sharedView.hide(animated: false)
        }
        if let view = UIApplication.shared.keyWindow {
            sharedView = ProgressHUD.showAdded(to: view, animated: true)
        }
        return sharedView
    }
    
    class func dismiss(animated: Bool) {
        if sharedView != nil {
            sharedView.hide(animated: true)
        }
    }
    
}
