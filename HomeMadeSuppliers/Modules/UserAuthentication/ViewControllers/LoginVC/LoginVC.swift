//
//  LoginVC.swift
//  TailerOnline
//
//  Created by apple on 3/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


class LoginVC: UIViewController {

     //MARK:-  outlet
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var noAcccountLabelXPosition: NSLayoutConstraint!
    
    var mySelectedEmail: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        myImage.zoomAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addBackBarButton()
        setLocalization()
        self.title = "Login".localized
       

        
        if let myEmail = mySelectedEmail {
            email.text = myEmail
            password.text = ""
        }
        
    }
    
    
    
    //MARK: - actions
    
    @IBAction func forgotPasswordBtnTapped(_ sender: UIButton) {
        
        let storydoard = AppConstant.storyBoard.userEntry
        let vc = storydoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        
        if AppConstant.loginOrSignup.signup{
            self.navigationController?.popViewController(animated: true)
        }else{
            AppConstant.loginOrSignup.signup = true
            let storydoard = AppConstant.storyBoard.userEntry
            let vc = storydoard.instantiateViewController(withIdentifier: "RegisterBuyerVC") as! RegisterBuyerVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if !formIsValid() {return}
        requestToLogin()
        
    }
    
    
    //MARK:- Form validations
    
    func formIsValid() -> Bool {
        let title = "Login".localized
     
        if  isValid(email: email.text!) == false {
            let msg = "Please enter valid email".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if password.text!.count < 6 || password.text!.count > 32 {
            let msg = "Please enter valid password, Password must be between 6-32 characters".localized
            nvMessage.showError(title: title , body: msg)
            return false
        }
        return true
    }

    
    
    // MARK:-  Web Request
    func requestToLogin() {
        showNvLoader()
        AuthManager.shared.login(email: email.text!, password: password.text!) { (response) in
            self.hideNvloader()
            switch response {
                case let .sucess(rootModel):
                    self.saveUser(model: rootModel.user!)
                case let .failure(error):
                     nvMessage.showError(body: error)
            }
        }
    }
    
    func saveUser(model: User) {
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
            //navigate to main screen
            moveToRootVC()
        }
        else {
            moveToEmailVerificationVC()
        }
    }
    
    func updateUserDefaults() {
        
        let user = AppSettings.shared.user
        //update account type
        let accountType = user?.accountType ?? "Uknown"
        myDefaultAccount = accountType == "store" ? .seller : .buyer
        
        //update userDefaults
        AppUserDefault.shared.email = email.text
        AppUserDefault.shared.password = password.text
        AppUserDefault.shared.isUserLoggedIn = true
        
        //socketConnection
        SocketIOManager.sharedInstance.setupSocket()
        SocketIOManager.sharedInstance.establishConnection()
    }
    
    func moveToRootVC() {
        let del = UIApplication.shared.delegate as! AppDelegate
        del.moveToRootMainVC()
    }
    
    func moveToEmailVerificationVC() {
        myDefaultAccount = .none
        let s = AppConstant.storyBoard.userEntry
        let vc = s.instantiateViewController(withIdentifier: "EmailVerficationVC") as! EmailVerficationVC
        vc.superIsLoginVC = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


 //MARK:- localization
extension LoginVC {
    
       private func setLocalization() {
           //buttons
           self.registerBtn.setTitle("Register Now".localized, for: .normal)
           self.loginBtn.setTitle("Login".localized, for: .normal)
           self.forgotPassBtn.setTitle("Forgot your password?".localized, for: .normal)
           //labels
           self.noAccountLabel.text = "Don't have an account?".localized
         
           self.emailLabel.text = "Email".localized
           self.passwordLabel.text = "Password".localized
           //textfields
           self.email.placeholder = "jhonDoe@gmail.com".localized
           self.password.placeholder = "******".localized
           
           let txtFields = [email, password] as [UITextField]
           //View directions
           self.setTextFieldDirectionByLanguage(textFields: txtFields)
           self.setViewDirectionByLanguage()
           
           if myDefaultLanguage == . ar {
               noAcccountLabelXPosition.constant =  26
           }
       
       }
    
}
