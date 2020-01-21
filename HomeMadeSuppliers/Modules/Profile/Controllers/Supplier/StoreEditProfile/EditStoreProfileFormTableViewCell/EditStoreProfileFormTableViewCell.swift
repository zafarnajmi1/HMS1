//
//  StoreEditProfielHeaderTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/27/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import CoreLocation
class EditStoreProfileFormTableViewCell: BaseImagePickerTableViewCell {

    @IBOutlet weak var selectImageBtn: LoaderButton!
    @IBOutlet weak var selectCityBtn: UIButton!
    @IBOutlet weak var storeName: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var myImage: UITextField!
    @IBOutlet weak var internationalShipping: UITextField!
    @IBOutlet weak var domesticShipping: UITextField!
    
    //labels for localization
    @IBOutlet weak var internationalLabel: UILabel!
    @IBOutlet weak var domesticLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var arriveInLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var address: UITextField!
   
     //MARK:-  variables
    
    var imagePath: String?
    var storeNameEn: String?
    var storeNameAr: String?
    var detailEn: String?
    var detailAr: String?
    var myLocation = (lat: 0.0, long: 0.0)
    var myEmail: String?
    
    var deliverableCities = [DeliverableCity]()
    var myNewLocation: CLLocationCoordinate2D?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
        // Initialization code
        self.address.isUserInteractionEnabled = false
        self.myImage.isUserInteractionEnabled = false
        let priceType = myDefaultCurrency.rawValue
        internationalShipping.placeholder = "Price in " + priceType
        domesticShipping.placeholder = "Price in " + priceType
        imagePickerDelegate = self
    }

    
    func setData(model: User)  {
        
        self.deliverableCities = model.deliverableCities ?? []
        storeName.text = model.storeName
        address.text = model.address
        phone.text = model.phone
        myImage.text = model.image
    
        storeNameEn = model.storeNameEn
        storeNameAr = model.storeNameAr
        
        detailEn = model.descriptionEn
        detailAr = model.descriptionAr
        
        internationalShipping.text = setDefualtCurrency(price: model.internationalShipping)
        domesticShipping.text = setDefualtCurrency(price: model.domesticShipping)
        
        self.myEmail = model.email
        if let location = model.location {
            myLocation.lat = location.first ?? 0.0
            myLocation.long = location.last ?? 0.0
        }
        
        
    }
    
    
     //MARK:- actions
    @IBAction func pickImageBtnTapped(sender: UIButton) {
        self.endEditing(true)
        self.alertPickerOptions(aspectRatio: CGSize(width: 445, height: 264))
    }
    
    
    
    //MARK: - form validation
     func  formIsvalid() -> Bool {
        
        let title = "Edit Profile".localized
        
      
        
        if storeName.text!.trim.count < 3 || storeName.text!.trim.count > 30 {
            let msg = "Store name must be between 3-30 characters".localized
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
        
        if  internationalShipping.text?.count ?? 0 == 0 {
            let msg = "Please enter valid international shipping Price".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if  domesticShipping.text?.count ?? 0 == 0  && deliverableCities.count == 0{
            let msg = "Please enter valid domestic shipping Price".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        return true
    }
    
    
    
    
}


extension EditStoreProfileFormTableViewCell: BaseImagePickerTableViewCellDelegate {
    func mySelectedImage(image: UIImage) {
        
        self.selectImageBtn.showLoading(view: self.contentView )
        //        self.btn_Image.startAnimate(view: self.view)
        SocketEventManager.shared.uploadImage(image: image) { (result) in
            
            switch result {
                
            case .progress(let value):
                self.myImage.text = "\(Int(value))%"
                
            case .path(let fileName):
                self.selectImageBtn.hideLoading(view: self.contentView)
                print("Image = ",fileName)
        
                self.imagePath = fileName
                self.myImage.text = self.imagePath
                
            }
            
        }
    }
}



private extension EditStoreProfileFormTableViewCell {
    private func setLocalization() {
        self.storeNameLabel.text = "Store Name".localized
        self.phoneLabel.text = "Phone Number".localized
        self.addressLabel.text = "Address".localized
        self.imageLabel.text = "Image".localized
        self.domesticLabel.text = "Domestic Shipping".localized
        self.arriveInLabel.text = "We Can Arrive In".localized
        self.orLabel.text = "OR".localized
        self.selectCityBtn.setTitle("Select Cities".localized, for: .normal)
        
        self.storeName.placeholder = "Store Name".localized
        self.phone.placeholder = "Phone Number".localized
        self.address.placeholder = "Address".localized
        self.domesticShipping.placeholder = "Price in AED".localized
        
        AppLanguage.updateTextFieldsDirection([storeName, phone,
                                               address, myImage,domesticShipping])
    }
}

//MARK:-  location setup
extension EditStoreProfileFormTableViewCell {
    
       @IBAction func locationBtnTapped(_ sender: UIButton) {
           
           self.contentView.endEditing(true)
           let picker = LocationPickerController()
           picker.open { (coordinates, address) in
               self.myNewLocation = coordinates
               self.address.text = address
           }
       }
    
}
