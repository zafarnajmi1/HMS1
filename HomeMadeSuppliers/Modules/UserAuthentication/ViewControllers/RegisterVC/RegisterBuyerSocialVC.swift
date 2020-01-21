//
//  RegisterBuyerSocialVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/17/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DLRadioButton
import CoreLocation

class RegisterBuyerSocialVC: UIViewController {

    //MARK:- outlets
    
    @IBOutlet weak var maleBtn: DLRadioButton! //male
    @IBOutlet weak var femaleBtn: DLRadioButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    //labels for localization
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var alreadyAccountLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var address: UITextField!
   
    //MARK:- Properties
    var profileModel: SocialProfile!
    private var mySelectedLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up".localized
        self.addBackBarButton()
        setLocalization()
      
        self.maleBtn.isSelected = true
        self.reloadForm()
    }
    
    //MARK: - Base config
    
    fileprivate func setLocalization() {
        //Buttons
        self.femaleBtn.setTitle("Female".localized, for: .normal)
        self.maleBtn.setTitle("Male".localized, for: .normal)
        self.registerBtn.setTitle("Continue".localized, for: .normal)
  
        //Labels
        self.genderLabel.text = "Select Gender".localized
       // self.alreadyAccountLabel.text = "Already have an account?".localized
        self.firstNameLabel.text = "First Name".localized
        self.lastNameLabel.text = "Last Name".localized
        self.emailLabel.text = "Email".localized
        self.phoneLabel.text = "Phone Number".localized
        self.addressLabel.text = "Address".localized
        
        //TF
        self.firstName.placeholder = "e.g Jhon".localized
        self.lastName.placeholder = "e.g Doe".localized
        self.email.placeholder = "e.g Jhondoe@gmail.com".localized
        self.phone.placeholder = "+00000000".localized
        self.address.placeholder = "e.g 46 street, Al Ain. UAE".localized

        AppLanguage.updateTextFieldsDirection([firstName, lastName, email, phone])
        self.setViewDirectionByLanguage()
        
    }
    
    func reloadForm()  {
        self.firstName.text = profileModel.firstName
        self.lastName.text = profileModel.lastName
        self.email.text = profileModel.email
    }
    
    //MARK:- buyer Register
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if self.formIsvalid() {
           self.reuquestToSignup()
        }
    }
    
    
    //MARK: - form validation
    private func  formIsvalid() -> Bool {
        
        let title = self.title?.localized ?? "Buyer"
        
        if firstName.text!.trim.count < 3 || firstName.text!.trim.count > 30 {
            let msg = "First name must be between 3-30 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if lastName.text!.trim.count < 3 || lastName.text!.trim.count > 30 {
            let msg = "Last name must be between 3-30 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        if  isValid(email: email.text!) == false {
            let msg = "Please enter valid email".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if  phone.text!.count < 9 || phone.text!.count > 15{
            let msg = "Phone number must be between 9-15 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if (address.text?.count)! < 2 {
            let msg = "Please enter valid address".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if confirmPassword.text!.count < 6 || confirmPassword.text!.count > 32 {
            let msg = "Confirm password must be between 6-32 characters".localized
            nvMessage.showError(title: title , body: msg)
            return false
        }
        if password.text != confirmPassword.text {
            let msg = "Confirm Password does not match, please add same password to confirm".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        return true
    }
    
    
    func reuquestToSignup()  {
        
        
        let gender = maleBtn.isSelected == true ? "male" : "female"
        
        let params = [
            "firstName":self.firstName.text!,
            "lastName": self.lastName.text!,
            "phone":self.phone.text!,
            "email":self.email.text!,
            "accountType": "buyer",
            "password": password.text!,
            "passwordConfirmation": confirmPassword.text!,
            "address": self.address.text!,
            "latitude": mySelectedLocation?.latitude ?? "",
            "longitude": mySelectedLocation?.longitude ?? "",
            "gender": gender,
            "accessToken":profileModel.socialToken!,
            "authMethod":profileModel.authMethod!,
            "id":profileModel.socialId!] as  [String:Any]

        
        showNvLoader()
        AuthManager.shared.register(params: params) { (result) in
            
            self.hideNvloader()
            
            switch result {
                
            case let .sucess(model):
                self.saveUser(model: model.user!)
               
            case let .failure(error):
                nvMessage.showError(title: self.title?.localized ?? "Buyer", body: error)
            }
        }
    }
    
   
    func saveUser(model: User)  {
        //save model
        AppSettings.shared.setUser(model: model)
        //update user default and other data
        updateUserDefaults()
        //navigate to main screen
        moveToRootVC()
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
        //update account Type
        let accountType = user?.accountType ?? "Uknown"
        myDefaultAccount = accountType == "store" ? .seller : .buyer
        
        //update userDefaults
        AppUserDefault.shared.socialId = profileModel.socialId
        AppUserDefault.shared.socialToken = profileModel.socialToken
        AppUserDefault.shared.authMethod = profileModel.authMethod
        AppUserDefault.shared.isUserLoggedInBySocialAccount = true
        
        AppUserDefault.shared.isUserLoggedIn = false
        AppUserDefault.shared.email = nil
        AppUserDefault.shared.password = nil
        
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

 //MARK:-  location setup
extension RegisterBuyerSocialVC {
   
    @IBAction func locationBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let picker = LocationPickerController()
        picker.open { (coordinates, address) in
            self.mySelectedLocation = coordinates
            self.address.text = address
        }
        
    }
    
    
}
