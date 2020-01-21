//
//  LoginOptionVC.swift
//  TailerOnline
//
//  Created by apple on 3/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import GoogleSignIn


class LoginOptionVC: SocialAccountVC {

    //MARK:- outlets
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var continueGuestBtn: UIButton!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var googleLabel: UILabel!
    @IBOutlet weak var InstagramLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    

   
    
    
     //MARK:-  my life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
        
        self.title = "Login or Create Account".localized
        setupView()
       
    }
    
   func setupView()  {
    
    switch myDefaultAccount {
    case .guest:
        self.showNavigationBar()
        addBackBarButton()
    default:
        self.showNavigationBar()
        self.hideBackButton()
    }
    
    
        
        //API Call
        getProfileCompletionHandler = {
            self.requestToSoicalLogin()
        }
    
        myImage.zoomAnimate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func setLocalization()  {
        facebookLabel.text = "Continue With Facebook".localized
        googleLabel.text = "Continue Login With Google".localized
        InstagramLabel.text = "Continue Login With Instagram".localized
        orLabel.text = "OR".localized
        loginBtn.setTitle("Login".localized, for: .normal)
        registerBtn.setTitle("Register".localized, for: .normal)
        continueGuestBtn.setTitle("Continue As Guest".localized, for: .normal)
        AppLanguage.updateNavigationBarSementic(vc: self)
        setViewDirectionByLanguage()
        
    }
    
    
    //MARK:- actions
    
    @IBAction func LoginBtnTapped(_ sender: UIButton) {
       
        let board = UIStoryboard(name: "UserEntry", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        AppConstant.loginOrSignup.login = true
        AppConstant.loginOrSignup.signup = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func RegisterBtnTapped(_ sender: UIButton) {
        let board = UIStoryboard(name: "UserEntry", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "RegisterBuyerVC") as! RegisterBuyerVC
        AppConstant.loginOrSignup.login = false
        AppConstant.loginOrSignup.signup = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ContinueGuestBtnTapped(_ sender: UIButton) {
        // set default account
        myDefaultAccount = .guest
        AppSettings.shared.moveToRootMainVC()
       // requestToLoadSetting()
        
    }
    
   
     //MARK:- social login actions
    @IBAction func facebookBtnTapped(_ sender: UIButton) {
        //1- get  fb profile data > Call API to Check If user exist in DB
        //2- if user Exist  -> then go to home screen
        //3- else goto social register and pass user profile data to Register screen
        self.logoutFromFacebook()
        self.setupFaceBookLogin()
    }
    
    @IBAction func googleBtnTapped(_ sender: UIButton) {
        //1- get  google profile data > Call API to Check If user exist in DB
        //2- if user Exist  -> then go to home screen
        //3- else goto social register and pass user profile data to Register screen
        self.setupGmailLogin()
    }
    
    @IBAction func instagramBtnTapped(_ sender: UIButton) {
        //1- get  instagram profile data > Call API to Check If user exist in DB
        //2- if user Exist  -> then go to home screen
        //3- else goto social register and pass user profile data to Register screen
        self.setupInsgramLogin()
    }
    
    func moveToSocialRegister() {
        let authMethod = socialAccountTypeSelected.rawValue
        let model = SocialProfile(firstName: self.firstName,
                                  lastName: self.lastName,
                                  email: self.email,
                                  socialId: self.socialId,
                                  socialToken: self.socialToken,
                                  authMethod: authMethod)
        
        
        let board = UIStoryboard(name: "UserEntry", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "RegisterBuyerSocialVC") as! RegisterBuyerSocialVC
        vc.profileModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//validate if user is already registered with social login account
extension LoginOptionVC {
    
    func  requestToSoicalLogin()  {

        var params = ["authMethod": ""] as [String: Any]

        switch socialAccountTypeSelected {
        case .facebook:
            params.updateValue(socialToken!, forKey: "accessToken")
            params.updateValue("facebook", forKey: "authMethod")
            params.updateValue(socialId!, forKey: "id")
        case .google:
            params.updateValue(socialToken!, forKey: "accessToken")
            params.updateValue("google", forKey: "authMethod")
            params.updateValue(socialId!, forKey: "id")

        case .instagram:
            params.updateValue(socialToken!, forKey: "accessToken")
            params.updateValue("instagram", forKey: "authMethod")
            params.updateValue(socialId!, forKey: "id")
        case .none:
            print("--")
        }


        if let token = AppUserDefault.shared.fcmToken {
            params.updateValue(token, forKey: "fcm")
        }

        self.showNvLoader()

        AuthManager.shared.socialLoginCheck(params: params) { (result) in
            self.hideNvloader()

            switch result {
            case .resultSuccess(let rootModel):
                self.saveUser(model: rootModel.user!)
            case .resultFailure(let rootModel):
                if rootModel.user?.exists == false {
                     self.moveToSocialRegister()
                }
            
            case .failure(let error):
               nvMessage.showError(title: "Login".localized , body: error)
            
            }

        }
    }

    
    func saveUser(model: User)  {
        //save model
        AppSettings.shared.setUser(model: model)
        updateUserDefaults()
        
    }
    

    
    func updateUserDefaults() {
        
        let user = AppSettings.shared.user
        //update account type
        let accountType = user?.accountType ?? "Uknown"
        myDefaultAccount = accountType == "store" ? .seller: .buyer
        
        //update userDefaults
        AppUserDefault.shared.socialId = socialId
        AppUserDefault.shared.authMethod = socialAccountTypeSelected.rawValue
        AppUserDefault.shared.socialToken = socialToken
        AppUserDefault.shared.isUserLoggedInBySocialAccount = true
        
        AppUserDefault.shared.isUserLoggedIn = false
        AppUserDefault.shared.email = nil
        AppUserDefault.shared.password = nil
        
        //socketConnection
        SocketIOManager.sharedInstance.setupSocket()
        SocketIOManager.sharedInstance.establishConnection()
        
        //navigate to main screen
        AppSettings.shared.moveToRootMainVC()
    }
    
    
    func moveToEmailVerificationVC() {
        myDefaultAccount = .none
        let s = AppConstant.storyBoard.userEntry
        let vc = s.instantiateViewController(withIdentifier: "EmailVerficationVC") as! EmailVerficationVC
        vc.superIsLoginVC = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func requestToLoadSetting()  {
        
        showNvLoader()
        SettingManger.shared.fetchSettings { (response) in
            self.hideNvloader()
            
            switch response {
                
            case let .sucess(rootModel):
                
                AppSettings.shared.setSettingData(model: rootModel.data!)
                AppSettings.shared.moveToRootMainVC()
               
                
            case let .failure(error):
                self.hideNvloader()
                self.alertMessage(message: error, completion: {
                    self.requestToLoadSetting()
                })
            }
        }
    }
}



