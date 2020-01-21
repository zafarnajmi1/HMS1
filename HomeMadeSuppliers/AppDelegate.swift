//
//  AppDelegate.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/16/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit
import IQKeyboardManagerSwift
import SideMenu

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
    
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
  
        application.registerForRemoteNotifications()
        //FCM -Push Notification implementation
        FirebaseApp.configure()
        let manager = PushNotificationManager()
        manager.registerForPushNotifications()
        
        GMSPlacesClient.provideAPIKey("AIzaSyB3w5MNXWdyFVn9bCYMbPHiUmhBii3crTQ")
       
       // GMSPlacesClient.provideAPIKey("AIzaSyCg5kyymmLwkkMn6RHV4a7DZqBpvVSmAfM")
        GMSServices.provideAPIKey("AIzaSyBAHovBCLopRZoLNxquZdBkWRLfxWmrkfM")
        
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentSandbox: "AR9DVJvSCQyaYqojNmNyjPaz14YM17PkPJ3KlyCbDfEOg4WYZAYctEF5s6Dxkxx-jVWva2xCXOXHWGvl"])
        
        //Google SignIn
        GIDSignIn.sharedInstance()?.clientID = "499772228440-rf6m541lmtuhid68jjqvohlb5u5ef0ga.apps.googleusercontent.com"
       
        //Facebook Login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        //Dark Mode restriction
        if #available(iOS 13.0, *) {
        window?.overrideUserInterfaceStyle = .light
        }
        
        
        
        
        
        //Realod Setup
        reloadOnStartup()
        
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
         // only for testing purpose
        
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()

        print("Device Token:\(deviceTokenString)")
        
    }

  

    func applicationWillTerminate(_ application: UIApplication) {
        
        if myDefaultAccount == .buyer && AppUserDefault.shared.isUserLoggedIn == true {
            let socket = SocketIOManager.sharedInstance.getSocket()
             socket.emit("cartNotInProcess")
        }
    }


}


//MARK:-  helpers
extension AppDelegate {
    
    func reloadOnStartup()  {
        
        //Set Default language
        if let lang = AppUserDefault.shared.rememberdMyDefaultLanguage {
            switch lang {
            case "ar":
                myDefaultLanguage = .ar
            default:
                myDefaultLanguage = .en
            }
        }
        
        //Apply Theme
        ThemeManager.applyTheme(theme: .myDefault)
        
        //move to Root Controller
        moveToRootSplashVC()
    
    }
    
    
    
    func moveToRootMainVC() {
        
       
        //self.window?.removeFromSuperview()
        let board = AppConstant.storyBoard.main
        let vc = board.instantiateViewController(withIdentifier: TabBarVC.id) as! TabBarVC
        self.window?.switchRootViewController(vc)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
     
        AppLanguage.updateUIScreenDirection()
        
    }
    
    func moveToRootLoginOptionVC() {
       
        
        let board = AppConstant.storyBoard.userEntry
        let vc = board.instantiateViewController(withIdentifier: LoginOptionVC.id) as! LoginOptionVC
        let nvc = UINavigationController(rootViewController: vc)
        self.window?.switchRootViewController(nvc)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        AppLanguage.updateUIScreenDirection()
    }
    
    func moveToRootSplashVC() {
        
        myDefaultAccount = .none
        
        let board = AppConstant.storyBoard.userEntry
        let vc = board.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        let nvc = UINavigationController(rootViewController: vc)
        self.window?.switchRootViewController(nvc)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        AppLanguage.updateUIScreenDirection()
        
        
    }
    
    
//    func moveToRootLoginOptionsVC() {
//
//        let board = AppConstant.storyBoard.userEntry
//        let vc = board.instantiateViewController(withIdentifier: "LoginOptionVC") as! LoginOptionVC
//        let nvc = UINavigationController(rootViewController: vc)
//        self.window?.switchRootViewController(nvc)
//        self.window?.makeKeyAndVisible()
//        AppLanguage.updateUIScreenDirection()
//    }
  
}
