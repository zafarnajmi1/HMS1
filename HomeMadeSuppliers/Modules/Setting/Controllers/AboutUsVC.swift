//
//  AboutUsVC.swift
//  TailerOnline
//
//  Created by apple on 3/11/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController {

     //MARK:-  outlets
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var aboutUsLabel: UILabel!
    @IBOutlet weak var FollowUsLabel: UILabel!
    @IBOutlet weak var mydetail: UILabel!
    @IBOutlet weak var myPhone: UILabel!
    @IBOutlet weak var myEmail: UILabel!
    
    //mark properties
    let setting = AppSettings.shared.settingData?.settings
    
     //MARK:- my life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "About Us".localized
        addBackBarButton()
        showNavigationBar()
        setupView()
    }
    


    override func viewDidAppear(_ animated: Bool) {
        self.requestToFetchSettingByPage()
    }
    
    
     //MARK:-  intialzation code
    func setupView() {
       
        setLocalization()
        reloadContentView()
        self.mydetail.text = ""
       
      
    }
    
    func setLocalization() {
       // aboutUsLabel.text = "Homemade Suppliers".localized
        FollowUsLabel.text = "Follow Us".localized
        
        switch myDefaultLanguage {
        case .ar:
            let image = UIImage(named: "Contact")
            let flippedImage = image?.withHorizontallyFlippedOrientation()
            phoneImage.image = flippedImage
        default: // en
            phoneImage.image = UIImage(named: "Contact")
         }
    }
  
    func reloadContentView()  {
        // self.mydetail.text = setting?.aboutShortDescription ?? " "
         self.myEmail.text = setting?.contactEmail ?? " "
         self.myPhone.text = setting?.phone1 ?? " "
     }

    
    @IBAction  func facebookBtnTapped(_ sender: UIButton) {
        if let url = URL(string: setting?.facebook ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    @IBAction  func googleBtnTapped(_ sender: UIButton) {
        if let url = URL(string: setting?.google ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction  func snapChatBtnTapped(_ sender: UIButton) {
        if let url = URL(string: setting?.snapchat ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction  func InstagramBtnTapped(_ sender: UIButton) {
        if let url = URL(string: setting?.instagram ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction  func whatsappBtnTapped(_ sender: UIButton) {
        if let url = URL(string: setting?.whatsapp ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}



extension AboutUsVC {
    
    func requestToFetchSettingByPage()  {
        
        let terms = AppSettings.shared.settingData?.settings?.aboutUs
        guard let termsSlug = terms  else {
            nvMessage.showError(body: "Terms & Conditions key not found")
            return
        }
        
        var queryItems:[URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "slug", value: termsSlug))
        queryItems.append(URLQueryItem(name: "currency", value: myDefaultCurrency.rawValue))
        showNvLoader()
        SettingManger.shared.fetchSettingPage(queryItems: queryItems) { (response) in
            self.hideNvloader()
            
            switch response {
                
            case let .sucess(rootModel):
                
                self.updateUI(page: rootModel.data)
               
                
            case let .failure(error):
                self.hideNvloader()
                
                self.alertMessage(message: error, completion: {
                   
                })
            }
        }
    }
    
    
    func updateUI(page: Page?)  {
           guard let page = page else {
               nvMessage.showError(body: "data not found".localized)
           return
           }
          // self.myTitle.text = page.title ?? ""
          // self.myImage.setPath(image: page.image, placeHolder: AppConstant.placeHolders.store)
           let deleteImageTage = page.detail?.deleteHTMLTag(tag: "img")
           self.mydetail.attributedText = deleteImageTage?.html2AttributedString
           
       }
}



