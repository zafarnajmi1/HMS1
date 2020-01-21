//
//  EditCustomerProfileVC.swift
//  TailerOnline
//
//  Created by apple on 3/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DLRadioButton
import CoreLocation

class EditCustomerProfileVC: BaseImagePickerVC {

    //MARK:- outlets
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var maleBtn: DLRadioButton! //male
    @IBOutlet weak var femaleBtn: DLRadioButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var attachBtn: LoaderButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    
    
    //labels for localization
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var address: UITextField!
    
    var imagePath: String?
    var newImage: UIImage?
    var userProfile: User?
    var callBack: (()->Void)?
    var location = (lat: 0.0, long: 0.0)
    private var mySelectedLocation: CLLocationCoordinate2D?
      
    
      
    //MARK:-  my life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile".localized
        addBackBarButton()
        
        self.email.isEnabled = false
        self.maleBtn.isSelected = true //default male selected
        self.setLocalization()
        self.imagePickerDelegate = self
        
        self.imagePath = nil
        
        reloadContentData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       myImage.isUserInteractionEnabled = true
     
    }
    
    
    //MARK: - Base config
    
    fileprivate func setLocalization() {
        
        //Buttons
        self.femaleBtn.setTitle("Female".localized, for: .normal)
        self.maleBtn.setTitle("Male".localized, for: .normal)
        self.saveBtn.setTitle("Save".localized, for: .normal)
        //Labels
        self.genderLabel.text = "Gender".localized
        
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
        
        
        let txtFields = [firstName, lastName, email, phone, address] as [UITextField]
        self.setTextFieldDirectionByLanguage(textFields: txtFields)
        
        let tfs = [firstName, lastName, email, phone, address] as! [UITextField]
        self.setTextFieldDirectionByLanguage(textFields: tfs)
        self.setViewDirectionByLanguage()
        
    }
    
    //MARK:- data initalazation
    func reloadContentData()  {
        guard let user = userProfile else {return}
        let url = user.image?.resizeImage(width: 300, height: 300)
        myImage.setPath(image: url,
                        placeHolder: AppConstant.placeHolders.user)
        
        
        firstName.text = user.firstName
        lastName.text = user.lastName
        email.text = user.email
        phone.text = user.phone
        address.text = user.address
        let lat = user.location?.first
        let long = user.location?.last
        self.location.lat = lat ?? 0.0
        self.location.long = long ?? 0.0
        
        
        
        if let gender = user.gender {
            if gender == "male" {
                maleBtn.isSelected = true
            } else {
                femaleBtn.isSelected = true
            }
        }
        
        
        myImage.addTapGesture { (gesture) in
            self.view.showImageVC(singImageURL: user.image)
//
//            let vc = AppConstant.storyBoard.main.instantiateViewController(withIdentifier: ImagePreviewVC.id) as! ImagePreviewVC
//
//            vc.imageURL = url ?? ""
//            vc.myImage = self.myImage.image
//            vc.modalTransitionStyle = .crossDissolve
//            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
 //MARK:-  actions
    
    @IBAction  func pickImageBtnTapped(sender: UIButton) {
        self.view.endEditing(true)
        self.alertPickerOptions(aspectRatio: CGSize(width: 200, height: 200))
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - form validation
    private func  formIsvalid() -> Bool {
        
        let title = self.title?.localized ?? "Buyer"
        
        var stringValue = self.firstName.text!
        var trimmedStr = stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedStr.count < 2 {
            let msg = "Please enter valid first name".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        stringValue = self.lastName.text!
        trimmedStr = stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedStr.count < 2 {
            let msg = "Please enter valid last name".localized
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
        
        return true
    }
    
    
    //MARK:- actions
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if !formIsvalid() { return }
        requestToUpdateProfile()
        
    }
    
    
    
    
    //MARK:-  web services
    
    func requestToUpdateProfile() {
        let gender = maleBtn.isSelected == true ? "male": "female"
        let locale = myDefaultLanguage == .en ? "en":"ar"
        var params = ["firstName": firstName.text!] as [String: Any]
        params.updateValue(lastName.text!, forKey: "lastName")
        params.updateValue(phone.text!, forKey: "phone")
        params.updateValue(gender, forKey: "gender")
        params.updateValue(address.text!, forKey: "address")
        
        if let location = mySelectedLocation {
            
            params.updateValue(location.latitude, forKey: "latitude")
            params.updateValue(location.longitude, forKey: "longitude")
        }
        else {
            params.updateValue(location.lat, forKey: "latitude")
            params.updateValue(location.long, forKey: "longitude")
        }
        
       
        params.updateValue(locale, forKey: "locale")
        
        if let path = imagePath {
            params.updateValue(path, forKey: "image")
        }
        
        
        self.showNvLoader()
        ProfileManager.shared.editProfile(params: params) { (result) in
            self.hideNvloader()
            self.imagePath = nil
            
            switch result {
            case .sucess(let root):
                AppSettings.shared.setUser(model: root.user!)
                if let image = self.newImage {
                    self.myImage.setPath(image: root.user?.image, placeHolder: image)
                }
                nvMessage.showSuccess(title: self.title?.localized ?? "Edit Profile", body: root.message ?? "", closure: {
                    self.callBack?()
                    self.navigationController?.popViewController(animated: true)
                })
                
            case .failure(let error):
                nvMessage.showError(body: error)
                
            }
        }
        
    }
    
    
}

extension EditCustomerProfileVC: BaseImagePickerVCDelegate {
    
    func mySelectedImage(image: UIImage) {
        
        self.myImage.image = image
        self.newImage = image
        
        self.attachBtn.showLoading(view: view )
        self.progressLabel.isHidden = false
        SocketEventManager.shared.uploadImage(image: image) { (result) in
            
            switch result {
                
            case .progress(let value):
                self.progressLabel.text = "\(Int(value))%"
            case .path(let fileName):
                self.progressLabel.isHidden = true
                self.attachBtn.hideLoading(view: self.view)
                self.imagePath = fileName
                
                self.requestToUpdateProfile()
            }
            
        }
        
    }
    
}

extension EditCustomerProfileVC {
    @IBAction func locationBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let picker = LocationPickerController()
        picker.open { (coordinates, address) in
            self.mySelectedLocation = coordinates
            self.address.text = address
        }
        
    }
}
