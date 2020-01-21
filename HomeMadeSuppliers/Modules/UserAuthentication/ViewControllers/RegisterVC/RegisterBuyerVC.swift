//
//  RegisterBuyerVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/17/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DLRadioButton
import CoreLocation

class RegisterBuyerVC: UIViewController {

    //MARK:- outlets
  
    @IBOutlet weak var maleBtn: DLRadioButton! //male
    @IBOutlet weak var femaleBtn: DLRadioButton!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
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
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passowrdConfirmLabel: UILabel!
    
    @IBOutlet weak var alreadyAccountLabelXposition: NSLayoutConstraint!
    @IBOutlet weak var address: UITextField!
    //MARK:- Properties
    private var mySelectedLocation: CLLocationCoordinate2D?
      
    
     //MARK:-  life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    private func setupView () {
        setLocalization()
        addBackBarButton()
        self.title = "Register".localized
        self.maleBtn.isSelected = true
    }
    
    
    //MARK: - Base config
    
    fileprivate func setLocalization() {
        //Buttons
        self.femaleBtn.setTitle("Female".localized, for: .normal)
        self.maleBtn.setTitle("Male".localized, for: .normal)
        self.registerBtn.setTitle("Signup".localized, for: .normal)
        self.loginBtn.setTitle("Login Now".localized, for: .normal)
        //Labels
        self.genderLabel.text = "Select Gender".localized
        self.alreadyAccountLabel.text = "Already have an account?".localized
        self.firstNameLabel.text = "First Name".localized
        self.lastNameLabel.text = "Last Name".localized
        self.emailLabel.text = "Enter Email".localized
        self.phoneLabel.text = "Phone Number".localized
        self.addressLabel.text = "Address".localized
        self.passwordLabel.text = "Password".localized
        self.passowrdConfirmLabel.text = "Confirm Password".localized
        //TF
        self.firstName.placeholder = "e.g Jhon".localized
        self.lastName.placeholder = "e.g Doe".localized
        self.email.placeholder = "e.g Jhondoe@gmail.com".localized
        self.phone.placeholder = "+00000000".localized
        self.address.placeholder = "e.g 46 street, Al Ain. UAE".localized
        self.password.placeholder = "*******".localized
        self.confirmPassword.placeholder = "*******".localized
        
       
        AppLanguage.updateTextFieldsDirection([firstName, lastName, address,
                                               email, phone, password, confirmPassword])
        self.setViewDirectionByLanguage()
        
        if myDefaultLanguage == .ar {
            alreadyAccountLabelXposition.constant = 40
        }
    }
    
    
    //MARK:- Login
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        if AppConstant.loginOrSignup.login{
            AppConstant.loginOrSignup.signup = false
            self.navigationController?.popViewController(animated: true)
        }else{
            let storyboard = UIStoryboard(name: "UserEntry", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func moveToEmailVerificationVC() {
        
        let storyboard = UIStoryboard(name: "UserEntry", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EmailVerficationVC") as! EmailVerficationVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- buyer Register
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        
       
        if !self.formIsvalid() {return}
        
        self.reuquestToSignup()
        
    }
    
    func reuquestToSignup()  {


        let gender = maleBtn.isSelected == true ? "male" : "female"

        let params = [
            "firstName":self.firstName.text!,
            "lastName": self.lastName.text!,
            "phone":self.phone.text!,
            "email":self.email.text!,
            "password":self.password.text!,
            "passwordConfirmation":self.confirmPassword.text!,
            "accountType": "buyer",
            "address": self.address.text!,
            "latitude": mySelectedLocation?.latitude ?? "",
            "longitude": mySelectedLocation?.longitude ?? "",
            "gender": gender] as  [String:Any]

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
    
    func saveUser(model: User) {
        AppSettings.shared.setUser(model: model)
        self.moveToEmailVerifaicaton()
    }

    func moveToEmailVerifaicaton()  {
        let s = AppConstant.storyBoard.userEntry
        let vc = s.instantiateViewController(withIdentifier: "EmailVerficationVC") as! EmailVerficationVC
        vc.email = self.email.text

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    //MARK: - form validation
    private func  formIsvalid() -> Bool {
        
        let title = "Register".localized
        
        
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
        
        if password.text!.count < 6 || password.text!.count > 32 {
            let msg = "Password must be between 6-32 characters".localized
            nvMessage.showError(title: title , body: msg)
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
    

}


 //MARK:-  location setup
extension RegisterBuyerVC {
   
    @IBAction func locationBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let picker = LocationPickerController()
        picker.open { (coordinates, address) in
            self.mySelectedLocation = coordinates
            self.address.text = address
        }
        
    }
    
    
}
