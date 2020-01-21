//
//  AppSetting.swift
//  TailerOnline
//
//  Created by apple on 3/29/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import SideMenu
import Firebase


class AppSettings {
    static let shared = AppSettings()
    private init() {}
    
    
    var user : User?
    var settingData: SettingData?
    var storeAPIResponse: StoreAPIResponse?
    
    var userToken : String? {
        return user?.authorization ?? ""
    }

    
}

 //MARK:-  store/update data in app active state ( temporary storage )
extension AppSettings {
    
    func setUser(model : User)  {
        self.user = model
    }
    
    func setSettingData(model : SettingData)  {
        settingData = model
    }
    
    func setStoreAPIResponse(model : StoreAPIResponse)  {
        storeAPIResponse = model
    }
    
    func resetUserProfile() {
        self.user = nil
        self.storeAPIResponse = nil
        AppUserDefault.shared.resetUserDefault()
        SocketIOManager.sharedInstance.closeConnection()
        self.deleteFireBaseToken()
    }
}


extension AppSettings {
    
    
    private func deleteFireBaseToken () {
//        let instance = InstanceID.instanceID()
//        instance.deleteID { (error) in
//            print(error.debugDescription)
//        }
//
//        instance.instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else {
//                print("Remote instance ID token: \(String(describing: result?.token))")
//            }
//        }
       // Messaging.messaging().shouldEstablishDirectChannel = true
        
        
    }
    
}


 //MARK:-  root naviagations
extension AppSettings {
   
    func moveToSplashVC()  {
        
        resetUserProfile()
        let del = UIApplication.shared.delegate as! AppDelegate
        del.moveToRootSplashVC()
    }
    
    
    func moveToRootMainVC()  {
        
        let del = UIApplication.shared.delegate as! AppDelegate
        del.moveToRootMainVC()
       
    }
    
    
    func moveToRootLoginOptionsVC()  {
        resetUserProfile()
        let del = UIApplication.shared.delegate as! AppDelegate
        del.moveToRootLoginOptionVC()
        
    }
    
     //MARK:-  alrets
    static func guestLogin(view: UIView)  {
        let msg = "You are in guest Mode. Please login first".localized
        view.presentAlert(message: msg, no: nil) {
            let s = AppConstant.storyBoard.userEntry
            let vc = s.instantiateViewController(withIdentifier: LoginOptionVC.id) as! LoginOptionVC
           // vc.modalTransitionStyle = .crossDissolve
            view.parentVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    static func storeIsBusyAlert(view: UIView) {
        let msg = "This store is busy and is not currently taking any orders".localized
        view.alertMessage( message: msg, btnTitle: "OK".localized) {
            return
        }
    }
    
    
}

 //MARK:-  sidemenu implementation
extension AppSettings {
    
    func showMenu(_ viewController: UIViewController)  {
        let s = UIStoryboard(name: "Main", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "LeftMenuNavigationVC") as! UISideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController = vc
        updateMenus()
        vc.leftSide = true
        if myDefaultLanguage == .ar {
            vc.leftSide = false
        }
        viewController.present(vc, animated: true, completion: nil)
    }
    
    
    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        // SideMenuManager.default.rightMenuNavigationController?.settings = settings
    }
    
    
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        //        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        return  .menuSlideIn
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.backgroundColor = ThemeManager.currentTheme().statusBarBgColor
        // presentationStyle.menuStartAlpha = 0.5
        // presentationStyle.menuStartAlpha = CGFloat(menuAlphaSlider.value)
     
        presentationStyle.onTopShadowRadius = 4
        presentationStyle.onTopShadowOpacity = 0.4
        presentationStyle.onTopShadowColor = .black
        presentationStyle.onTopShadowOffset = CGSize(width: 4, height: 4)
    
        
        // presentationStyle.presentingScaleFactor = CGFloat(presentingScaleFactorSlider.value)
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        
        
//        settings.menuWidth = AppSettings.screenWidth - 0.25
        //   let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        // settings.blurEffectStyle = styles[blurSegmentControl.selectedSegmentIndex]
        //  settings.statusBarEndAlpha = blackOutStatusBar.isOn ? 1 : 0
        
        return settings
    }
    
}

 //MARK:-
extension AppSettings {
   
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var defaultError : String{
        get {
            return "Something went wrong, please try again later".localized
        }
    }
    static var defaultSuccess : String{
        get {
            return "Your request has been processed".localized
        }
    }
}


extension Notification.Name {
    static let menuBtnTapped = Notification.Name("menuBtnTapped")
    static let languagaeChanged = Notification.Name("languagaeChanged")
    
}
