//
//  SettingVC.swift
//  TailerOnline
//
//  Created by apple on 3/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DLRadioButton

class SettingVC: UIViewController {

     //MARK:-  outlets
    
    @IBOutlet var passwordView: UIView!
    @IBOutlet var locationSettingView: UIView!
    @IBOutlet var statusAvailableView: UIView!
    @IBOutlet var passwordBtnLabel: UILabel!
    @IBOutlet var passwordTitle: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    
    @IBOutlet var languageBtnLabel: UILabel!
    @IBOutlet var languageTitle: UILabel!
    @IBOutlet var languageLabel: UILabel!
    
    @IBOutlet var currencyTitle: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
    @IBOutlet weak var lblAED: UILabel!
    @IBOutlet weak var lblUSD: UILabel!
    @IBOutlet weak var aedBtn: UIButton!
    @IBOutlet weak var usdBtn: UIButton!
    
    @IBOutlet weak var locationTitleLabel: UILabel!
    
    @IBOutlet weak var locationSubtitleLabel: UILabel!
    
    
    @IBOutlet weak var locationYesBtn: UIButton!
    @IBOutlet weak var locationNoBtn: UIButton!
    
    @IBOutlet weak var lblNO: UILabel!
    @IBOutlet weak var lblYES: UILabel!
    @IBOutlet weak var availableTitleLabel: UILabel!
    @IBOutlet weak var availableSubtitleLabel: UILabel!
    
    @IBOutlet weak var lblavailable: UILabel!
    @IBOutlet weak var availabilityYesBtn: UIButton!
    @IBOutlet weak var availabilityNoBtn: UIButton!
    @IBOutlet weak var lblBusy: UILabel!
    
     @IBOutlet weak var changePasswordLabelPosition: NSLayoutConstraint!
     @IBOutlet weak var ChangeLanguageLabelPosition: NSLayoutConstraint!
    
    var locationSetting = false
    enum availability: String{
        case available
        case busy
    }
    
    var myDefaultAvailability = availability.available
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setLocalization()
        self.title = "Settings".localized
        showNavigationBar()
        addBackBarButton()
       
        reloadSetting()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
         AppLanguage.updateNavigationBarSementic(vc: self)
    }

    
    
    //MARK: - Initialzation Code
    func setLocalization()  {
     
        if myDefaultLanguage == .ar {
            changePasswordLabelPosition.constant = -9
            ChangeLanguageLabelPosition.constant = -9
        }
        else {
            changePasswordLabelPosition.constant = 9
            ChangeLanguageLabelPosition.constant = 9
        }
        
        //self.aedBtn.setTitle("AED".localized, for: .normal)
        //self.usdBtn.setTitle("USD".localized, for: .normal)
        self.locationTitleLabel.text = "Location Setting".localized
        self.locationSubtitleLabel.text = "Do you want to show your store location?".localized
        AppLanguage.updateLabelsDirection([locationSubtitleLabel])
        //self.locationYesBtn.setTitle("Yes".localized, for: .normal)
        //self.locationNoBtn.setTitle("No".localized, for: .normal)
        self.availableTitleLabel.text = "Availability Status".localized
        self.availableSubtitleLabel.text = "Are you available or busy?".localized
        //self.availabilityYesBtn.setTitle("Available".localized, for: .normal)
        //self.availabilityNoBtn.setTitle("Busy".localized, for: .normal)
        
        self.passwordTitle.text = "Password".localized
        self.passwordLabel.text = "Change Password".localized
        self.passwordBtnLabel.text  = "Change".localized
        
        self.languageTitle.text = "Language".localized
        self.languageLabel.text = "Change Language".localized
        self.languageBtnLabel.text  = "Change".localized
        
        self.currencyTitle.text = "Currency".localized
        self.currencyLabel.text = "Select Currency".localized
        
        lblBusy.text = "Busy".localized
        lblavailable.text = "Available".localized
        lblNO.text = "No".localized
        lblYES.text = "Yes".localized
        lblAED.text = "AED".localized
        lblUSD.text = "USD".localized
        
        
    }
    
    
    fileprivate func reloadSetting() {
        
       
        //currency handling
        if myDefaultCurrency == .aed {
            self.aedBtn.isSelected = true
        }
        else {
            self.usdBtn.isSelected = true
        }
        //account type handling
        switch myDefaultAccount {
        case .buyer:
             passwordView.isHidden = false
             locationSettingView.isHidden = true
             statusAvailableView.isHidden = true
             locationSettingView.heightAnchor.constraint(equalToConstant: 0).isActive = true
             statusAvailableView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            
        case .seller:
             passwordView.isHidden = false
             let user = AppSettings.shared.user
             locationSetting = user?.locationSetting ?? false
            
             if locationSetting == true {
                locationYesBtn.isSelected = true
             }
             else {
                locationNoBtn.isSelected = true
             }
             
             if user?.availabilitySetting == "busy" {
                myDefaultAvailability = .busy
                availabilityNoBtn.isSelected = true
             } else {
                availabilityYesBtn.isSelected = true
                myDefaultAvailability = .available
            }
          default: //geust
             passwordView.isHidden = true
             locationSettingView.isHidden = true
             statusAvailableView.isHidden = true
            
             passwordView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
    
     //MARK:-  actions
    
    @IBAction func currencyAEDBtnTapped(_ sender: UIButton) {
        myDefaultCurrency = .aed
        self.usdBtn.isSelected = false
        self.aedBtn.isSelected =  true
        self.usdBtn.setImage(UIImage.init(named: "2"), for: .normal)
        self.aedBtn.setImage(UIImage.init(named: "1"), for: .normal)
        
    }
    
    @IBAction func currencyUSDBtnTapped(_ sender: UIButton) {
        myDefaultCurrency = .usd
        self.usdBtn.isSelected = true
        self.aedBtn.isSelected =  false
        self.usdBtn.setImage(UIImage.init(named: "1"), for: .normal)
        self.aedBtn.setImage(UIImage.init(named: "2"), for: .normal)
        
    }
    
    @IBAction func LocationYesBtnTapped(_ sender: UIButton) {
        locationSetting = true
        self.locationYesBtn.isSelected = true
        self.locationNoBtn.isSelected = false
        self.locationYesBtn.setImage(UIImage.init(named: "1"), for: .normal)
        self.locationNoBtn.setImage(UIImage.init(named: "2"), for: .normal)
        requestToUpdateProfileSetting()
    }
    
    @IBAction func LocationNoBtnTapped(_ sender: UIButton) {
        locationSetting = false
        self.locationYesBtn.isSelected = false
        self.locationNoBtn.isSelected = true
        self.locationYesBtn.setImage(UIImage.init(named: "2"), for: .normal)
        self.locationNoBtn.setImage(UIImage.init(named: "1"), for: .normal)
        requestToUpdateProfileSetting()
    }
    
    @IBAction func availabelStatusYesBtnTapped(_ sender: UIButton) {
       myDefaultAvailability = .available
        self.availabilityNoBtn.isSelected = false
        self.availabilityYesBtn.isSelected = true
        self.availabilityNoBtn.setImage(UIImage.init(named: "2"), for: .normal)
        self.availabilityYesBtn.setImage(UIImage.init(named: "1"), for: .normal)
        requestToUpdateProfileSetting()
    }
    
    @IBAction func availabelStatusNoBtnTapped(_ sender: UIButton) {
        myDefaultAvailability = .busy
        self.availabilityNoBtn.isSelected = true
        self.availabilityYesBtn.isSelected = false
        self.availabilityNoBtn.setImage(UIImage.init(named: "1"), for: .normal)
        self.availabilityYesBtn.setImage(UIImage.init(named: "2"), for: .normal)
        requestToUpdateProfileSetting()
    }
    
    @IBAction func btnChangePaswordAction(_ sender: UIButton) {
        
        let s = AppConstant.storyBoard.userEntry
        let vc = s.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func BtnChnageLanguageAction(_ sender: UIButton) {
        
        let  s = AppConstant.storyBoard.userEntry
        let vc =  s.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
        vc.comeFromSettingVC = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func requestToUpdateProfileSetting()  {
        let params = ["locationSetting": locationSetting ? "true" : "false",
                      "availabilitySetting": myDefaultAvailability.rawValue] as [String: Any]
        
        showNvLoader()
        ProfileManager.shared.updateProfileSettings(params: params) { (result) in
            self.hideNvloader()
            switch result {
            case .sucess(let root):
                AppSettings.shared.setUser(model: root.user!)
                nvMessage.showSuccess(title: self.title!, body: root.message ?? "")
                self.reloadSetting()
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
    }

}

    

    


