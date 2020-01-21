//
//  CheckOutVC.swift
//  TailerOnline
//
//  Created by apple on 3/19/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DLRadioButton

class CheckOutVC: PayPalVC  {
    
    
    //MARK:- outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var shipToCheckBtn: UIButton!
    @IBOutlet weak var shippingFormView: UIView!
    @IBOutlet weak var shippingFormViewHeight: NSLayoutConstraint! //520
    @IBOutlet weak var paypalOptionBtn: DLRadioButton!
    @IBOutlet weak var cashDeliveryOptionBtn: DLRadioButton!
    @IBOutlet weak var placeOrderBtn: UIButton!
    
    //titles
    @IBOutlet weak var billingTitleLabel: UILabel!
    @IBOutlet weak var shippingTitleLabel: UILabel!
    @IBOutlet weak var paymentOptionLabel: UILabel!
    
    //MARK:-  Billing fields
    @IBOutlet weak var firstNameBilling: UITextField!
    @IBOutlet weak var lastNameBilling: UITextField!
    @IBOutlet weak var address1Billing: UITextField!
    @IBOutlet weak var address2Billing: UITextField!
    @IBOutlet weak var phoneBilling: UITextField!
    @IBOutlet weak var postalCodeBilling: UITextField!
    @IBOutlet weak var emailBilling: UITextField!
    
    //MARK:-  Billing Labels
    @IBOutlet weak var firstNameBillingLabel: UILabel!
    @IBOutlet weak var lastNameBillingLabel: UILabel!
    @IBOutlet weak var address1BillingLabel: UILabel!
    @IBOutlet weak var address2BillingLabel: UILabel!
    @IBOutlet weak var phoneBillingLabel: UILabel!
    @IBOutlet weak var postalCodeBillingLabel: UILabel!
    @IBOutlet weak var emailBillingLabel: UILabel!
    
    //MARK:-  Shipping fields
    @IBOutlet weak var firstNameShipping: UITextField!
    @IBOutlet weak var lastNameShipping: UITextField!
    @IBOutlet weak var address1Shipping: UITextField!
    @IBOutlet weak var address2Shipping: UITextField!
    @IBOutlet weak var phoneShipping: UITextField!
    @IBOutlet weak var postalCodeShipping: UITextField!
    @IBOutlet weak var emailShipping: UITextField!
    
    //MARK:-  Shipping fields
    @IBOutlet weak var firstNameShippingLabel: UILabel!
    @IBOutlet weak var lastNameShippingLabel: UILabel!
    @IBOutlet weak var address1ShippingLabel: UILabel!
    @IBOutlet weak var address2ShippingLabel: UILabel!
    @IBOutlet weak var phoneShippingLabel: UILabel!
    @IBOutlet weak var postalCodeShippingLabel: UILabel!
    @IBOutlet weak var emailShippingLabel: UILabel!
    
    @IBOutlet weak var orderNotes: UITextView!
    @IBOutlet weak var orderNotesPlaceHolder: UILabel!
    @IBOutlet weak var orderNotesLabel: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    
    var delegate : CallBackDelegate?
    
    var cartList: [Cart]!
    var totalBilAmount: Price?
    var isFromBuyNow = false
    
    enum PaymentMethod: String {
        case cash
        case paypal
    }
    
    // default paypal is selected
    var selectedPaymentType = PaymentMethod.paypal
    
    
     //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Checkout".localized
        addBackBarButton()
        setLocalization()
        setupView()
        reloadFormData()
        
    }
    
    override func paypalPaymentComplete() {
        self.selectedPaymentType = .paypal
        self.requestToCheckout()
    }
    
    
    
    override func backToMain() {
        let socket = SocketIOManager.sharedInstance.getSocket()
        socket.emit("cartNotInProcess")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
}

//MARK:- localization

private extension CheckOutVC {
    
    private func setLocalization()   {
        
        self.placeOrderBtn.setTitle("Place Order".localized, for: .normal)
        self.paypalOptionBtn.setTitle("Continue With Paypal".localized, for: .normal)
        self.cashDeliveryOptionBtn.setTitle("Cash On Delivery".localized, for: .normal)
        //titles
        self.paymentOptionLabel.text = "Select Payment Option".localized
        self.billingTitleLabel.text = "Billing Address".localized
        self.shippingTitleLabel.text = "Ship To Different Address?".localized
        
        //billing labels
        self.firstNameBillingLabel.text = "First Name".localized
        self.lastNameBillingLabel.text = "Last Name".localized
        self.emailBillingLabel.text = "Email".localized
        self.address1BillingLabel.text = "Address".localized
        self.address2BillingLabel.text = "Address Line 2".localized
        self.phoneBillingLabel.text = "Phone Number".localized
        self.postalCodeBillingLabel.text = "Postcode / Zip".localized
        //shipping labels
        self.firstNameShippingLabel.text = "First Name".localized
        self.lastNameShippingLabel.text = "Last Name".localized
        self.emailShippingLabel.text = "Email".localized
        self.address1ShippingLabel.text = "Address".localized
        self.address2ShippingLabel.text = "Address Line 2".localized
        self.phoneShippingLabel.text = "Phone Number".localized
        self.postalCodeShippingLabel.text = "Postcode / Zip".localized
        //billing fields
        self.firstNameBilling.placeholder = "First Name".localized
        self.lastNameBilling.placeholder = "Last Name".localized
        self.emailBilling.placeholder = "Email".localized
        self.address1Billing.placeholder = "Address Line 1".localized
        self.address2Billing.placeholder = "Address Line 2".localized
        self.phoneBilling.placeholder = "Phone Number".localized
        self.postalCodeBilling.placeholder = "Postcode / Zip".localized
        //shipping fields
        self.firstNameShipping.placeholder = "First Name".localized
        self.lastNameShipping.placeholder = "Last Name".localized
        self.emailShipping.placeholder = "Email".localized
        self.address1Shipping.placeholder = "Address Line 1".localized
        self.address2Shipping.placeholder = "Address Line 2".localized
        self.phoneShipping.placeholder = "Phone Number".localized
        self.postalCodeShipping.placeholder = "Postcode / Zip".localized
        
       
        AppLanguage.updateTextFieldsDirection([firstNameBilling,lastNameBilling, emailBilling,
                                               address1Billing,address2Billing,phoneBilling,
                                               postalCodeBilling,firstNameShipping, lastNameShipping,
                                               emailShipping,address1Shipping, address2Shipping,
                                               phoneShipping, postalCodeShipping])
        
        self.orderNotesLabel.text = "Delivery Notes".localized
        self.orderNotesPlaceHolder.text = "Write your notes here".localized
        AppLanguage.updateTextViewsDirection([orderNotes])
    }
    
}



 //MARK:-  helpers
extension CheckOutVC {
    
    private func setupView()  {
        self.totalAmount.text = ""
        let price =  setDefualtCurrency(price: totalBilAmount)
        checkoutNavigationLabel(string: price)
        paypalOptionBtn.isSelected = true
        shipToCheckBtn.isSelected = false
        self.shippingFormView.isHidden = true
        self.shippingFormViewHeight.constant = 0
        orderNotes.delegate = self
        
        let socket = SocketIOManager.sharedInstance.getSocket()
        socket.emit("cartInProcess")
    }
    
    private func checkPaymentType()  {
        
        if cashDeliveryOptionBtn.isSelected  == true {
            selectedPaymentType = .cash
            requestToCheckout()
        }
        else {
            selectedPaymentType = .paypal
            moveToPaypalVC(billAmount: totalBilAmount)
            return
        }
    }
    
    
    
    private func moveToMyOrdersVC()  {
        
        let s = AppConstant.storyBoard.order
        let vc = s.instantiateViewController(withIdentifier: MyOrderListVC.id) as! MyOrderListVC
        vc.isComeFromCheckout = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


//MARK:-  update view
extension CheckOutVC {
    
    private func reloadFormData(){
        let user = AppSettings.shared.user
        
        
        if user?.addresses?.count ?? 0 == 0  {
            self.firstNameBilling.text = user?.firstName ?? ""
            self.lastNameBilling.text = user?.lastName ?? ""
            self.emailBilling.text = user?.email ?? ""
            self.address1Billing.text = user?.address
            self.phoneBilling.text = user?.phone ?? ""
            self.firstNameShipping.text = user?.firstName ?? ""
            self.lastNameShipping.text = user?.lastName ?? ""
            self.emailShipping.text = user?.email ?? ""
            self.address1Shipping.text = user?.address
            self.phoneShipping.text = user?.phone ?? ""
            
            
        }
        
        guard let addresses = user?.addresses else { return }
        
        for (index, model) in addresses.enumerated()  {
            switch index {
            case 0:
                self.firstNameBilling.text = model.firstName ?? ""
                self.lastNameBilling.text = model.lastName ?? ""
                self.emailBilling.text = model.email ?? ""
                self.address1Billing.text = model.address1 ?? ""
                self.address2Billing.text = model.address2 ?? ""
                self.phoneBilling.text = model.phone ?? ""
                self.postalCodeBilling.text = model.postCode ?? ""
            case 1://shipping fields
                self.firstNameShipping.text = model.firstName ?? ""
                self.lastNameShipping.text = model.lastName ?? ""
                self.emailShipping.text = model.email ?? ""
                self.address1Shipping.text = model.address1 ?? ""
                self.address2Shipping.text = model.address2 ?? ""
                self.phoneShipping.text = model.phone ?? ""
                self.postalCodeShipping.text = model.postCode ?? ""
            default:
                print("something went wrong")
            }
        }
    }
    
    private func adressesParams() -> [String: Any] {
        
        var billing:[String: Any] = [:]
        var shipping:[String: Any] = [:]
        
        billing = ["firstName": self.firstNameBilling.text!,
                   "lastName": self.lastNameBilling.text!,
                   "email":self.emailBilling.text!,
                   "address1":self.address1Billing.text!,
                   "address2":self.address2Billing.text!,
                   "phone": self.phoneBilling.text!,
                   "postCode": self.postalCodeBilling.text!,
                   "addressType": "billing"]
        
        if shipToCheckBtn.isSelected {
            shipping = ["firstName": self.firstNameShipping.text!,
                        "lastName": self.lastNameShipping.text!,
                        "email":self.emailShipping.text!,
                        "address1":self.address1Shipping.text!,
                        "address2":self.address2Shipping.text!,
                        "phone": self.phoneShipping.text!,
                        "postCode": self.postalCodeShipping.text!,
                        "addressType": "shipping"]
            
        }
        else {
            shipping = ["firstName": self.firstNameBilling.text!,
                        "lastName": self.lastNameBilling.text!,
                        "email":self.emailBilling.text!,
                        "address1":self.address1Billing.text!,
                        "address2":self.address2Billing.text!,
                        "phone": self.phoneBilling.text!,
                        "postCode": self.postalCodeBilling.text!,
                        "addressType": "shipping"]
        }
        
        return ["addresses" : [billing,shipping]] as [String: Any]
    }
}



//MARK:-  network
extension CheckOutVC {
    
    private func requestToUpdateUserAddresses(_ params : [String: Any] ){
        
        self.showNvLoader()
        
        OrderManager.shared.updateUserAddresses(params: params){ (result) in
            self.hideNvloader()
            
            switch result {
            case .sucess(let rootModel):
                
                AppSettings.shared.setUser(model: rootModel.user!)
                self.checkPaymentType()
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
    }
    
    private func requestToCheckout(){
        
        let paymentType = selectedPaymentType.rawValue
        var params = ["paymentMethod" : paymentType] as [String: Any]
        
        let addresses = AppSettings.shared.user?.addresses
        
        if let billing = addresses?.first(where: {$0.addressType == "billing"} ){
            params.updateValue(billing.id!, forKey: "billingAddressId")
        }
        if let shipping = addresses?.first(where: {$0.addressType == "shipping"} ){
            params.updateValue(shipping.id!, forKey: "shippingAddressId")
        }
        
        if let id = paymentId {
            params.updateValue(id, forKey: "paymentId")
        }
        
        if let notes = orderNotes.text {
            params.updateValue(notes, forKey: "orderNote")
        }
        
        if isFromBuyNow {
            params.updateValue("true", forKey: "buyNow")
        }
        
        self.showNvLoader()
        OrderManager.shared.checkout(params: params){ (result) in
            self.hideNvloader()
            
            switch result {
            case .sucess(let rootModel):
                nvMessage.showSuccess(body: rootModel.message ?? "", closure: {
                    self.delegate?.reloadData()
                    self.tabBarController?.increaseBadge(indexOfTab: 3, num: "0")
                    self.moveToMyOrdersVC()
                })
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
    }
    
}



//MARK:-  actions
extension CheckOutVC {
    
    @IBAction func shipToDifferentAddressBtnTapped(_ sender: UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
            // shippingFormSelected(bool: false)
            UIView.animate(withDuration: 0.5, animations: {
                self.shippingFormViewHeight.constant = 0
                self.shippingFormView.isHidden = true
                self.view.layoutIfNeeded()
            })
        }
        else {
            sender.isSelected = true
            // shippingFormSelected(bool: true)
            UIView.animate(withDuration: 0.5, animations: {
                self.shippingFormViewHeight.constant = 532
                
            }) { (true) in
                self.shippingFormView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func placeOrderBtnTapped(_ sender: Any) {
        
        if checkFormIsValid() == false { return }
        
        let params = adressesParams()
        self.requestToUpdateUserAddresses(params)
        
    }
    
    
}


//MARK:-  form validation
extension CheckOutVC {
    
    private func checkFormIsValid() -> Bool {
        
        var title = "Billing Address".localized
        
        
        if firstNameBilling.text!.trim.count < 3 || firstNameBilling.text!.trim.count > 30 {
            let msg = "First name must be between 3-30 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if lastNameBilling.text!.trim.count < 3 || lastNameBilling.text!.trim.count > 30 {
            let msg = "Last name must be between 3-30 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        
        if isValid(email: emailBilling.text!) == false {
            let error = "Please enter valid email ".localized
            nvMessage.showError(title: title, body: error)
            return false
        }
        if (address1Billing.text?.count)! < 2 {
            let error = "Please enter valid address ".localized
            nvMessage.showError(title: title, body: error)
            return false
        }
        
        if  phoneBilling.text!.trim.count < 9 || phoneBilling.text!.trim.count > 15{
            let msg = "Phone number must be between 9-15 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        //do not validate shipping form is ship check btn is not selected
        if   self.shipToCheckBtn.isSelected == false {
            return true
        }
        title = "Shipping Address".localized
        
        if firstNameShipping.text!.trim.count < 3 || firstNameShipping.text!.trim.count > 30 {
            let msg = "First name must be between 3-30 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if firstNameShipping.text!.trim.count < 3 || firstNameShipping.text!.trim.count > 30 {
            let msg = "Last name must be between 3-30 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if isValid(email: emailShipping.text!) == false {
            let error = "Please enter valid email ".localized
            nvMessage.showError(title: title, body: error)
            return false
        }
        
        if (address1Shipping.text?.count)! < 2 {
            let error = "Please enter valid address".localized
            nvMessage.showError(title: title, body: error)
            return false
        }
        
        if  phoneShipping.text!.trim.count < 9 || phoneShipping.text!.trim.count > 15{
            let msg = "Phone number must be between 9-15 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        //        if (postalCodeShipping.text?.count)! < 3 {
        //            let error = "Please enter valid PostCode/Zip".localized
        //            nvMessage.showError(title: title, body: error)
        //            return false
        //        }
        
        return true
    }
    
    
}

extension CheckOutVC: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        orderNotesPlaceHolder.isHidden = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if orderNotes.text.count == 0 {
            orderNotesPlaceHolder.isHidden = false
        }
        
    }
}
