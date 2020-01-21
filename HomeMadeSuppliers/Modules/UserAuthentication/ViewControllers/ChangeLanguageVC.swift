//
//  ChangeLanguageVC.swift
//  TailerOnline
//
//  Created by apple on 3/1/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class ChangeLanguageVC: UIViewController {

    //MARK:- outlets
    @IBOutlet weak var languageView: DesignableView!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var englishCheckMark: UIImageView!
    @IBOutlet weak var arabicLabel: UILabel!
    @IBOutlet weak var arabicCheckMark: UIImageView!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var rememberBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    //MARK:- properties
    var comeFromSettingVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        self.setLocalization()
        languageView.zoomAnimate()
        updateView()
      
    }
    
    private func setupView() {
        if comeFromSettingVC == false {
            self.hideBackButton()
            myDefaultAccount = .none
           self.title = "Select Language".localized
        }
        else {
            addBackBarButton()
            self.title = "Change Language".localized
        }
        
        updateRememberCheck()
    }
    
    private func updateRememberCheck() {
        if let lang = AppUserDefault.shared.rememberdMyDefaultLanguage {
            print("language Remembered: \(lang)")
            rememberBtn.isSelected = true
        }
        else {
            rememberBtn.isSelected = false
        }
        
    }
}






extension ChangeLanguageVC {
    
    func setLocalization() {
    
        continueBtn.setTitle("Continue".localized, for: .normal)
        rememberLabel.text = "Remember my choice".localized
        AppLanguage.updateUIScreenDirection()
    }
    
    
    //MARK:- actions
    
    @IBAction func englishBtnTapped(_ sender: UIButton) {
        
        myDefaultLanguage = .en
        updateView()
    }
    
    @IBAction func arabicBtnTapped(_ sender: UIButton) {
                myDefaultLanguage = .ar
                updateView()
    }
    
    
    @IBAction func RememberBtnTapped(_ sender: UIButton) {
        
        rememberBtn.zoomAnimate()
        
        rememberBtn.isSelected.toggle()
        
        if rememberBtn.isSelected == true {
            AppUserDefault.shared.rememberdMyDefaultLanguage = myDefaultLanguage.rawValue
        }
        else{
            AppUserDefault.shared.rememberdMyDefaultLanguage = nil
        }
    }
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        
        self.setViewDirectionByLanguage()
       
        if comeFromSettingVC == true {
          // NotificationCenter.default.post(name: .languagaeChanged, object: nil)
            AppSettings.shared.moveToRootMainVC()
           //self.navigationController?.popViewController(animated: true)
        }
        else {
            moveToLoginOptionVC()
        }
        
    }
    
    
    override func moveToLoginOptionVC()  {
        let s = AppConstant.storyBoard.userEntry
        let vc = s.instantiateViewController(withIdentifier: LoginOptionVC.id) as! LoginOptionVC
        vc.hideBackButton()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- helpers
    
    func updateView() {
        
        if rememberBtn.isSelected == true {
              AppUserDefault.shared.rememberdMyDefaultLanguage = myDefaultLanguage.rawValue
        }
        
        switch myDefaultLanguage {
            
        case .ar:
            
          
            arabicCheckMark.image = AppConstant.images.checkCircleActive
            arabicCheckMark.zoomAnimate()
            
            //not active elements
            englishLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.1215686275, blue: 0.1254901961, alpha: 1)
            englishCheckMark.image = AppConstant.images.checkCircle
            
        default: //en
            
          
            englishCheckMark.image = AppConstant.images.checkCircleActive
            englishCheckMark.zoomAnimate()
            
            //not active elements
            arabicLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.1215686275, blue: 0.1254901961, alpha: 1)
            arabicCheckMark.image = AppConstant.images.checkCircle
            
        }
        
        
        
    }
    
   
}
