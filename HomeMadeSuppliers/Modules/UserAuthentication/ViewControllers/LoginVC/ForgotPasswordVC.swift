//
//  ForgotPasswordVC.swift
//  TailerOnline
//
//  Created by apple on 3/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var forgetInfoLabel: UILabel!
    @IBOutlet weak var recoverBtn:UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setLocalization()
        self.title = "Forgot Password".localized
        addBackBarButton()
    }
    
    func setLocalization() {
        forgetInfoLabel.text = "Please enter email address to recover your password".localized
        self.recoverBtn.setTitle("Recover".localized, for: .normal)
        self.emailLabel.text = "Email".localized
        self.email.placeholder = "e.g jhondoe@gmail.com".localized
        self.setTextFieldDirectionByLanguage(textFields: [email] as! [UITextField])
        
    }
    

    @IBAction func recoverBtnTapped(sender: UIButton) {
    
        self.view.endEditing(true)
        if !formIsVaid() { return }
        
        requestToRecoverPassword()
    }
    
    func formIsVaid() -> Bool {
        
        if  isValid(email: email.text!) == false {
            let msg = "Please enter valid email".localized
            nvMessage.showError(title: self.title!, body: msg)
            return false
        }
        
        return true
    }
    
    
    
    
    func  requestToRecoverPassword()  {
       
        self.showNvLoader()
       
        AuthManager.shared.forgotPassword(email: email.text!) { (result) in
            
            self.hideNvloader()
            
            switch result {

            case .sucess(let rootModel):
                nvMessage.showSuccess(body: rootModel.message!, closure: {
                    self.moveToResetPasswordVC()

                })
            case .failure(let error):
                nvMessage.showError(title: self.title!, body: error)
                
            }
        }
    }

    
    func moveToResetPasswordVC() {
        let s = AppConstant.storyBoard.userEntry
        let vc = s.instantiateViewController(withIdentifier: "ResetPasswordVC" ) as! ResetPasswordVC
        vc.email = self.email.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
