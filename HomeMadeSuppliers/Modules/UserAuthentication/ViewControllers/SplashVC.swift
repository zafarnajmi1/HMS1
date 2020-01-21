//
//  SplashVC.swift
//  TailerOnline
//
//  Created by apple on 3/1/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

     //MARK:- outlets
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setViewDirectionByLanguage()
       
        self.myImage.animateZoomIn()
        
        requestToLoadSetting()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.showNavigationBar()
        var prefersStatusBarHidden: Bool {
            return false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
         self.hideNavigationBar()

    }
    
   
    
   // MARK:-  Web Request

    func requestToLoadSetting()  {

       // showNvLoader()
    
        activityIndicator.startAnimating()
        SettingManger.shared.fetchSettings { (response) in

            switch response {

            case let .sucess(rootModel):
               
                AppSettings.shared.setSettingData(model: rootModel.data!)
              
                self.checkUserIsLoggedIn()
                
            case let .failure(error):
               // self.hideNvloader()
                self.activityIndicator.stopAnimating()
                self.alertMessage(message: error.localized, completion: {
                    self.requestToLoadSetting()
                })
            }
        }
    }

    
    
    func checkUserIsLoggedIn()  {
        if AppUserDefault.shared.isUserLoggedIn == true {
            self.requestToLogin() // API Call
        }
        else if AppUserDefault.shared.isUserLoggedInBySocialAccount == true {
            self.requestToSoicalLogin()
        }
        else {
            
            delay(bySeconds: 0.5) {
                self.activityIndicator.stopAnimating()
                self.hideNvloader() // hie loader
                self.moveToChangeLanguageVC()
            }
            
        }
    }
    
    
    func requestToLogin()  {

      //  self.showNvLoader()
        guard let  email = AppUserDefault.shared.email, let password = AppUserDefault.shared.password  else {
            self.activityIndicator.stopAnimating()
            self.hideNvloader()
            self.moveToChangeLanguageVC()
            return
        }

        
        AuthManager.shared.login(email: email, password: password) { (response) in
            
            self.activityIndicator.stopAnimating()
            self.hideNvloader()

            switch response {

            case let .sucess(rootModel):
                self.saveUser(model: rootModel.user!)

            case .failure(_):
                self.moveToChangeLanguageVC()
            }
        }
    }

    


    
    func saveUser(model: User)  {
        //save model
        AppSettings.shared.setUser(model: model)
        //verfiy email
        checkIsEmailVerfied()
    }
    
    func checkIsEmailVerfied() {
        let user = AppSettings.shared.user
        
        if user?.isEmailVerified == true {
            //update user default and other data
            updateUserDefaults()
           
        }
        else {
            moveToChangeLanguageVC()
        }
    }
    
    func updateUserDefaults() {
        
        let user = AppSettings.shared.user
        //update account type
        let accountType = user?.accountType ?? "Uknown"
        myDefaultAccount = accountType == "store" ? .seller : .buyer
        
        
        //SocketConnection
        SocketIOManager.sharedInstance.setupSocket()
        SocketIOManager.sharedInstance.establishConnection()

        //navigate to main screen
        AppSettings.shared.moveToRootMainVC()
    }
    
   
    func moveToChangeLanguageVC()  {
        
        let storyBoard = UIStoryboard(name: "UserEntry", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    


    
    
}


extension SplashVC {
    
    func  requestToSoicalLogin()  {
        
        
        guard let  socialId = AppUserDefault.shared.socialId, let socialToken = AppUserDefault.shared.socialToken, let authMethod = AppUserDefault.shared.authMethod  else {
            self.activityIndicator.stopAnimating()
            self.hideNvloader()
            self.moveToChangeLanguageVC()
            return
        }

        
        var params: [String: Any] = [:]
        
       
        params.updateValue(socialToken, forKey: "accessToken")
        params.updateValue(authMethod, forKey: "authMethod")
        params.updateValue(socialId, forKey: "id")
       
        if let token = AppUserDefault.shared.fcmToken {
            params.updateValue(token, forKey: "fcm")
        }
        
        AuthManager.shared.socialLoginCheck(params: params) { (result) in
            self.activityIndicator.stopAnimating()
            self.hideNvloader()
            
            switch result {
            case .resultSuccess(let rootModel):
                AppSettings.shared.setUser(model: rootModel.user!)
                self.updateUserDefaults()
            case .resultFailure( _):
               self.moveToChangeLanguageVC()
            case .failure( _):
                self.moveToChangeLanguageVC()
                
            }
            
        }
    }
    
    
}
