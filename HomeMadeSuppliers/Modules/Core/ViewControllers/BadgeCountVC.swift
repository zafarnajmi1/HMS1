//
//  BaseCountVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/3/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import ObjectMapper

class BadgeCountVC: BaseImagePickerVC {
    
    override func viewWillAppear(_ animated: Bool) {
        switch myDefaultAccount {
        case .buyer:
            requestToFetchCartList()
            notificationObserver()
        case .seller:
            notificationObserver()
        default:
            return
        }
    }
    
    
    func notificationObserver() {
      SocketIOManager.sharedInstance.startListeningCommonMethods()
        
      NotificationCenter.default.addObserver(self, selector: #selector(updateBadge(notification:)), name: .didUpdateUnseenNotification, object: nil)
       
    }
    
    @objc func updateBadge(notification: Notification) {
        guard let dict = notification.object as? [String: AnyObject] else { return }
        guard let obj =  Mapper<NotificationAPIResponse>().map(JSONObject: dict) else { return }
        if obj.success == false { return }
        
        let count = obj.data?.unseenNotificationsCount ?? 0
        AppUserDefault.shared.notificationCount = count
        UIApplication.shared.applicationIconBadgeNumber = count
        
        if count == 0 {
            self.tabBarController?.increaseBadge(indexOfTab: 2, num: nil)
        }
        else {
            self.tabBarController?.increaseBadge(indexOfTab: 2, num: "\(count)")
        }
            
    }
   
    
}

//MARK:-  APIs Implementation
extension BadgeCountVC {
    
   func requestToFetchCartList(){
        
       // showNvLoader()
        CartManager.shared.fetchCartList { (result) in
          //  self.hideNvloader()
            
            switch result {
            case .sucess(let root):
                let count = self.getTotalQty(cartItmes: root.data?.cart)
                self.tabBarController?.increaseBadge(indexOfTab: 3, num: count)
                AppUserDefault.shared.cartBadgeItems = Int(count?.description ?? "0")
                _ = self.setCartBtn()
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
  
}



extension Notification.Name {
    static let didUpdateUnseenNotification = Notification.Name("didUpdateNotification")
    static let didUpdateCartCount = Notification.Name("didUpdateCartCount")
}
