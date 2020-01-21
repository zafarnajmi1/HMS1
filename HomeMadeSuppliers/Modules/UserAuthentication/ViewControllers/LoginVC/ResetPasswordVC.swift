//
//  ResetpasswordVC.swift
//  TailerOnline
//
//  Created by apple on 4/2/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var passwordConfirmLabel: UILabel!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Reset Password".localized
        self.setLocalization()
        self.addBackBarButton()
        
        
    }
    
    //MARK: - intialization code
    
    func setLocalization() {
        //buttons
        self.resetBtn.setTitle("Reset".localized, for: .normal)
        
        //labels
        self.detailLabel.text = "Please enter verification code sent at your email address to activate account".localized
        self.codeLabel.text = "Code".localized
        self.newPasswordLabel.text = "New Password".localized
        self.passwordConfirmLabel.text = "Confirm Password".localized
        //textfields
        self.code.placeholder = "1234".localized
        self.newPassword.placeholder = "New Password".localized
        self.passwordConfirm.placeholder = "Confirm New Password".localized
        
        
        let txtFields = [newPassword, passwordConfirm, code ] as [UITextField]
        //View directions
        self.setTextFieldDirectionByLanguage(textFields: txtFields)
        self.setViewDirectionByLanguage()
        
    }
    
    //MARK:-  actions
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if !formIsValid(){return}
        self.requestToResetpassword()
    }
    
    //MARK:-  form validation
    
    func formIsValid()-> Bool {
        
        let title = (self.title?.localized)!
        
        if (code.text?.count)! < 3 {
            
            let msg = "Please enter valid code".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        if newPassword.text!.count < 6 || newPassword.text!.count > 32 {
            let msg = "New password must be between 6-32 characters".localized
            nvMessage.showError(title: title , body: msg)
            return false
        }
        if passwordConfirm.text!.count < 6 || passwordConfirm.text!.count > 32 {
            let msg = "Confirm password must be between 6-32 characters".localized
            nvMessage.showError(title: title , body: msg)
            return false
        }
        
        if newPassword.text != passwordConfirm.text {
            let msg = "Confirm new password does not match, please add same new password to confirm".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        
        return true
    }
    
    
    
     //MARK:-  web services
    func requestToResetpassword()  {

        var params = ["email": email!] as [String: Any]
        params.updateValue(code.text!, forKey: "resetPasswordCode")
        params.updateValue(newPassword.text!, forKey: "password")
        params.updateValue(passwordConfirm.text!, forKey: "passwordConfirmation")

        self.showNvLoader()
        AuthManager.shared.resetPassword(params: params) { (result) in
          self.hideNvloader()

            switch result {
            case .sucess(let result):
                nvMessage.showSuccess(body: result.message ?? "", closure: {
                     self.moveToLoginVC()
                })

            case .failure(let error):
                nvMessage.showError(title: self.title!, body: error)
            }
        }
    }

    
     func moveToLoginVC() {
        let s = AppConstant.storyBoard.userEntry
        let vc = s.instantiateViewController(withIdentifier: "LoginVC" ) as! LoginVC
        vc.mySelectedEmail = self.email
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
