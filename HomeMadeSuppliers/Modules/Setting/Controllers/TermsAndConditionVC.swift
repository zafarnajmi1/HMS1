//
//  TermsAndConditionVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/22/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class TermsAndConditionVC: UIViewController {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myDetail: UILabel!
    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
          requestToFetchSettingByPage()
    }

    func setupView() {
        self.title = "Terms & Conditions".localized
        showNavigationBar()
        addBackBarButton()
        self.myDetail.text = ""
        self.myTitle.text = ""
      
    //    reloadContentView()
    }
    
    func reloadContentView()  {
        let pages = AppSettings.shared.settingData?.pages
        guard let pagelist = pages else {
            nvMessage.showError(body: "Record not found")
            return
         }
        
        for page in pagelist {
            
            switch page.titleEn {
            case "Terms & Conditions":
                self.myDetail.text = page.detail?.html2String ?? ""
                //webview.loadHTMLString(page.detail ?? "", baseURL: nil)
                 
            default:
                print("?")
            }
        }
        
    }

    func updateView(page: Page?)  {
        guard let page = page else {
            nvMessage.showError(body: "data not found".localized)
        return
        }
       // self.myTitle.text = page.title ?? ""
       // self.myImage.setPath(image: page.image, placeHolder: AppConstant.placeHolders.store)
        self.myDetail.attributedText = page.detail?.html2AttributedString
        AppLanguage.updateLabelsDirection([myDetail])
    }

}


extension TermsAndConditionVC {
    
    func requestToFetchSettingByPage()  {
        
        let terms = AppSettings.shared.settingData?.settings?.terms
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
                
                self.updateView(page: rootModel.data)
               
                
            case let .failure(error):
                self.hideNvloader()
                
                self.alertMessage(message: error, completion: {
                   
                })
            }
        }
    }
}
