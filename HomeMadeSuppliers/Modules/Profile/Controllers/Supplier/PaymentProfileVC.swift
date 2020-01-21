//
//  PaymentProfileVC.swift
//  TailerOnline
//
//  Created by apple on 3/6/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


class PaymentProfileVC: UIViewController {

     //MARK:- outlets
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var clientId: UITextField!
    @IBOutlet weak var secretId: UITextField!
    //labels for localization
    @IBOutlet weak var secretIdLabel: UILabel!
    @IBOutlet weak var enterIdLabel: UILabel!
    @IBOutlet weak var paymentLabelInfo: UILabel!
    
     //MARK:-  my life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        self.title = "Payment Profile".localized
        self.showNavigationBar()
        self.addBackBarButton()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        let user = AppSettings.shared.user
        secretId.text = user?.paypalSecretId
        clientId.text = user?.paypalClientId
        
    }
    
//    override func backToMain() {
//       self.dismiss(animated: true, completion: nil)
//       self.navigationController?.popViewController(animated: true)
//    }
    
     //MARK:- base configuration
    
    func setLocalization()  {
        self.paymentLabelInfo.text = "Save your payment profile".localized
        self.enterIdLabel.text = "Enter Id".localized
        self.secretIdLabel.text = "Secret".localized
        self.saveBtn.setTitle("Save".localized, for: .normal)
        
        self.clientId.placeholder = "Enter Id".localized
        self.secretId.placeholder = "Secret".localized
        
        let tfs = [clientId, secretId] as [UITextField]
        setTextFieldDirectionByLanguage(textFields: tfs)
    }
    
   //MARK:-  form validtion
   
    func formIsValid()-> Bool{
        
        if self.clientId.text?.count ?? 0 < 3 {
            
            let msg = "Please enter valid PayPal Client ID, at least 4 characters are required".localized
            nvMessage.showError(title: self.title!.localized, body: msg )
            return false
        }
        else  if self.secretId.text?.count ?? 0 < 3 {
            
            let msg = "Please enter valid PayPal Secret ID, at least 4 characters are required".localized
            nvMessage.showError(title: self.title!.localized, body: msg )
            
            return false
        }
        return true
    }
    
     //MARK:- actions
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if formIsValid(){
           self.requestToUpdateCredetials()
        }
        
    }
    
    
    func requestToUpdateCredetials()  {
        let params = ["paypalClientId": clientId.text!,
                      "paypalSecretId": secretId.text!] as [String: Any]
       
        showNvLoader()
        ProfileManager.shared.updateProfileSettings(params: params) { (result) in
            self.hideNvloader()
            switch result {
            case .sucess(let root):
                AppSettings.shared.setUser(model: root.user!)
                nvMessage.showSuccess(title: self.title!, body: root.message ?? "", closure: {
                    self.navigationController?.popViewController(animated: true)
                })
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
    }
    
}
