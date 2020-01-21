//
//  NotificationPager.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/16/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import UIKit
import XLPagerTabStrip
import ObjectMapper

class NotificationPager: ButtonBarPagerTabStripViewController {
    
    
    
    
    override func viewDidLoad() {
        self.setHeaderAppearance()
        super.viewDidLoad()
        self.navigationItem.title = "Notifications".localized
        addMenuBarBtn()
    }
    
     override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()
           if myDefaultLanguage == .ar {
            self.view.semanticContentAttribute = .forceRightToLeft
              }else{
               self.view.semanticContentAttribute = .forceLeftToRight
              }
       }
    override func toggleMenu() {
        AppSettings.shared.showMenu(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       if myDefaultLanguage == .ar {
       self.view.semanticContentAttribute = .forceRightToLeft
         }else{
          self.view.semanticContentAttribute = .forceLeftToRight
         }
        if myDefaultAccount == .guest {
            
            AppSettings.guestLogin(view: self.view)
        }
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let s = AppConstant.storyBoard.main
        let child1 = s.instantiateViewController(withIdentifier: NotificationVC.id) as! NotificationVC
        let child2 = s.instantiateViewController(withIdentifier: NotificationSettingVC.id) as! NotificationSettingVC
        return [child1, child2]
    }
    
    
}


extension NotificationVC: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notifications".localized)
    }
    
}


extension NotificationSettingVC: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Settings".localized)
    }
    
}
