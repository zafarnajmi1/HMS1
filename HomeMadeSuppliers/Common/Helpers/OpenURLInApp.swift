//
//  OpenURLInApp.swift
//  TailerOnline
//
//  Created by apple on 4/15/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class OpenInApp {
    
    class func dialPhone(number:String?) {
        guard let phone = number else { return }
        
        if let phoneCallURL = URL(string: "tel://\(phone)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    
    class func sendMessage(number:String?) {
          guard let phone = number else { return }
        
        if let messageURL = URL(string: "sms://\(phone)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(messageURL)) {
                if #available(iOS 10.0, *) {
                    application.open(messageURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(messageURL as URL)
                    
                }
            }
        }
    }
    
   class func goToSetting(){
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
}
