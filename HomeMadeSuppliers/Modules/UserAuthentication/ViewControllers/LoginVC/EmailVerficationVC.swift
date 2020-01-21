//
//  EmailVerficationVC.swift
//  TailerOnline
//
//  Created by apple on 3/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


class EmailVerficationVC: UIViewController {

    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var resendCodeBtn: UIButton!
    @IBOutlet weak var resendLabel: UILabel!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var verificationCodeLabel: UILabel!
    @IBOutlet weak var verificationCode: UITextField!
    
    
    var email: String?
    var superIsLoginVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocalization()
        self.title = "Email Verification".localized
        addBackBarButton()
       
        if superIsLoginVC {
            self.requestToResendCode()
        }
    }
    
    func setLocalization()  {
        labelInfo.text = "Please enter verification code sent at your email address to activate account".localized
        resendLabel.text = "Resend Code".localized
        submitBtn.setTitle("Submit".localized, for: .normal)
        verificationCodeLabel.text = "Verification Code".localized
        setTextFieldDirectionByLanguage(textFields: [verificationCode] as! [UITextField])
        setViewDirectionByLanguage()
    }
    
    
    
    override func backToMain() {
        self.popBack(toControllerType: LoginOptionVC.self)
    }
    
    
     //MARK:- actions
    
    @IBAction func resendCodeBtnTapped(_ sender: UIButton ) {
        self.verificationCode.text = ""
        requestToResendCode()
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton ) {
        
        self.view.endEditing(true)
        if !formIsVaid() {return}
        
       self.requestToEmailVerification()
        
    }

    func formIsVaid() -> Bool {
        
        if verificationCode.text!.count < 3 {
            let msg = "Please enter valid verification code".localized
            nvMessage.showError(title: self.title!, body: msg )
            return false
        }
       return true
        
    }
   
    func requestToEmailVerification( )  {

        AuthManager.shared.verificationCode(code: verificationCode.text!,completion: { (result) in


            switch result {

            case let .sucess(rootModel):
                AppSettings.shared.setUser(model: rootModel.user!)
                self.moveToRootVC()

            case let .failure(error):
                nvMessage.showError(body: error)
            }

        })
    }

    func moveToRootVC() {
        //set account type
        let user = AppSettings.shared.user
        let accountType = user?.accountType ?? "Uknown"
        myDefaultAccount = accountType == "store" ? .seller : .buyer

        AppUserDefault.shared.isUserLoggedIn = true

        AppSettings.shared.moveToRootMainVC()
       

    }
    
    func requestToResendCode( )  {
        showNvLoader()
        AuthManager.shared.resendVerificationCode { (result) in
            self.hideNvloader()
            switch result {
            case let .sucess(rootModel):
                nvMessage.showSuccess(body: rootModel.message ?? "")
            case let .failure(error):
                nvMessage.showError(body: error)
            }
        }
    }
    
}


