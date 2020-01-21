//
//  NotificationSettingModel.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/16/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation



enum notificationSettingType: String {
    case systemNotifications,
    chatNotifications,
    ordersNotifications
    
}

class notificationSettingModel {
    var title: String?
    var subtitle: String?
    var isSelected: Bool?
    var myNotificationType = notificationSettingType.systemNotifications
    
    init(title: String? , subtitle: String?, isSelected: Bool , type: notificationSettingType) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        myNotificationType = type
    }
    
    
   static var list: [notificationSettingModel] {
        get{
            
            guard let user = AppSettings.shared.user else { return [] }
            
            let item1 = notificationSettingModel(
                title: "System Notifications".localized,
                subtitle: "Do you want to enable system notifications?".localized,
                isSelected: user.notificationsSetting?.system ?? false,
                type: .systemNotifications)
           
            let item2 = notificationSettingModel(
                title: "Conversation Notifications".localized,
                subtitle: "Do you want to enable conversation notifications?".localized,
                isSelected: user.notificationsSetting?.chat ?? false,
                type: .chatNotifications)
            
            let item3 = notificationSettingModel(
                title: "Order Notifications".localized,
                subtitle: "Do you want to enable order notifications?".localized,
                isSelected: user.notificationsSetting?.orders ?? false,
                type: .ordersNotifications)
            
           return [item1, item2, item3]
        }
    }
    
   
}
