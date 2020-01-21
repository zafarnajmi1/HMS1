//
//  JGProgressHud.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/15/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//



import JGProgressHUD
class NvProgressLoader {
    //static let shared = Loader()
    
    private static let hud = JGProgressHUD(style: .dark)
    
    class func showLoader(blockUI: Bool = true) {
        hud.interactionType = .blockNoTouches
        hud.vibrancyEnabled = false
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        
        hud.textLabel.text = "Loading...".localized
        hud.detailTextLabel.text = "Please Wait".localized
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
             hud.show(in: window)
        }
      
        
        if blockUI {
            hud.interactionType = .blockAllTouches
            hud.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
           // UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
        
        
    }
    
    class func progress(count : Int) {
        
        hud.progress = Float(count)/100.0
        hud.textLabel.text = "Please Wait".localized
        let completeLabel = "Complete".localized
        hud.detailTextLabel.text = "\(count)% \(completeLabel)"
        
        
        // if count > 99 {
        // DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
        // UIView.animate(withDuration: 0.1, animations: {
        // self.hud.textLabel.text = "Success"
        // self.hud.detailTextLabel.text = nil
        // self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        // })
        //
        // self.hud.dismiss(afterDelay: 1.0)
        //
        // // DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        // // showHUDWithTransform()
        // // }
        // }
        // }
        
    }
    
    class func hideLoader() {
//UIApplication.shared.endIgnoringInteractionEvents()
        self.hud.dismiss()
    }
}
