//
//  ContactUsVC.swift
//  TailerOnline
//
//  Created by apple on 3/12/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DropDown

class ContactUsVC: UIViewController {

    
     //MARK:-  outlets
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet var dropDownBtn: UIButton!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var help: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var yourCommentsLabel: UILabel!
    @IBOutlet var commentsTv: UITextView!
    @IBOutlet var commentsTvPlaceHolder: UILabel!
  
    //MARK:- Properties
    
    let helpDropDown = DropDown()
   
    
     //MARK:-  my life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contact Us".localized
        showNavigationBar()
        setupView()
    }
    
//    override func backToMain() {
//        self.dismiss(animated: true, completion: nil)
//    }

    
    func setupView() {
        addBackBarButton()
        setLocalization()
        setupHelpDropDown()
        commentsTv.delegate = self
        
        //default selected dropdown
        self.help.text = "Feedback".localized
    }
    
    //MARK:-  Intialization code
    func setLocalization() {
        
        self.sendBtn.setTitle("Send".localized, for: .normal)
        
        self.firstNameLabel.text = "First Name".localized
        self.lastNameLabel.text = "Last Name".localized
        self.emailLabel.text = "Email".localized
        self.yourCommentsLabel.text = "Message".localized
        self.helpLabel.text = "What can we help you with?".localized
        
        self.firstName.placeholder = "First Name".localized
        self.lastName.placeholder = "Last Name".localized
        self.email.placeholder = "jhonDoe@gmail.com".localized
        self.help.placeholder = "Feedback".localized
        let tfs = [firstName, lastName, email, help] as [UITextField]
        self.setTextFieldDirectionByLanguage(textFields: tfs)
        
        self.commentsTvPlaceHolder.text = "Write your message here".localized
        let tvs = [commentsTv] as [UITextView]
        self.setTextViewDirectionByLanguage(textViews: tvs)
        
        self.setViewDirectionByLanguage()
    }
    
    
    
    func setupHelpDropDown(){
        let ds = ["Feedback".localized,"Suggestion".localized, "Request".localized]
        helpDropDown.setData(btn: dropDownBtn, dataSource: ds)
        helpDropDown.selectionAction = {[unowned self](index: Int, item: String) in
                        self.help.text = item
                    }
        
    }
    
    //MARK:-  actions
    @IBAction func DropdownAction(_ sender: UIButton) {
        helpDropDown.show()
    }
    
    
    
    
    func isValidForm()->Bool{
        
        let title = self.title ?? "Contact Us".localized
        
        
        if self.help.text?.trim.count == 0 {
            let message = "Please select subject".localized
            nvMessage.showError(title: title, body: message)
            
            return false
        }
       
        if self.firstName.text?.trim.count ?? 0 < 3  {
            let msg =  "Please enter valid first name".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        
        if self.lastName.text?.trim.count ?? 0  < 3 {
            let msg =  "Please enter valid last name".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if isValid(email: self.email.text!) == false{
            let message = "Please enter valid email".localized
            nvMessage.showError(title: title, body: message)
            
            return false
        }
        
       
        if  self.commentsTv.text?.trim.count ?? 0 < 5 {
            let message = "Please enter valid message".localized
            nvMessage.showError(title: title, body: message)
            
            return false
        }
        return true
        
    }
    
    @IBAction func btnSendAction(_ sender: UIButton) {
        //API Call
        self.view.endEditing(true)
        
        if !isValidForm(){ return }
          requestToContactUs()
        
        
    }
    
    func requestToContactUs()  {

        let fullName = "\(firstName.text!) \(lastName.text!)"
        let params: [String:Any] = ["name":fullName,
                                    "email": self.email.text!,
                                    "subject":self.help.text!,
                                    "message":commentsTv.text! ]

        self.showNvLoader()
        SettingManger.shared.contactUs(params: params) { (result) in
            
           self.hideNvloader()
            
            switch result {
            case .sucess(let rootModel):
                nvMessage.showSuccess(body: rootModel.message!, closure: {
                    self.dismiss(animated: true, completion: nil)
                })
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }

    }
    
}

extension ContactUsVC: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        commentsTvPlaceHolder.isHidden = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentsTv.text.count == 0 {
            commentsTvPlaceHolder.isHidden = false
        }
        
    }
}
