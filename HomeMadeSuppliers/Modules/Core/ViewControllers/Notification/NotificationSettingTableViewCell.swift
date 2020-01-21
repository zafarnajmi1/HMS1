//
//  NotificationSettingTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/16/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class NotificationSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    
    var selectedNotificationType: String = ""
    var selectedSwitch: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mySwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        if myDefaultLanguage == .ar {
            mySwitch.semanticContentAttribute = .forceRightToLeft
        }else{
            mySwitch.semanticContentAttribute = .forceLeftToRight
        }
       
    }

    
    func setData(model: notificationSettingModel)  {
        self.title.text = model.title
        self.subtitle.text = model.subtitle
        self.selectedSwitch = model.isSelected ?? false
        mySwitch.setOn(self.selectedSwitch, animated:true)
        self.selectedNotificationType = model.myNotificationType.rawValue
        
        #if DEBUG
        print(self.selectedSwitch.string)
        print(self.selectedNotificationType )
        #endif

    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        self.selectedSwitch = mySwitch.isOn
        print(self.selectedSwitch.string )
        requestToUpdateProfileSetting()
    }
    
    func requestToUpdateProfileSetting()  {
        
        var params: [String: String] = [:]
        let notification = AppSettings.shared.user?.notificationsSetting
        // default
        params.updateValue(notification?.system?.string ?? "false", forKey: notificationSettingType.systemNotifications.rawValue )
         params.updateValue(notification?.chat?.string ?? "false", forKey: notificationSettingType.chatNotifications.rawValue )
         params.updateValue(notification?.orders?.string ?? "false", forKey: notificationSettingType.ordersNotifications.rawValue )
        
        //replace with default one
        params.updateValue(selectedSwitch.string , forKey: selectedNotificationType )
        
        self.parentVC?.showNvLoader()
        ProfileManager.shared.updateProfileSettings(params: params) { (result) in
            self.parentVC?.hideNvloader()
            switch result {
            case .sucess(let root):
                AppSettings.shared.setUser(model: root.user!)
                nvMessage.showSuccess(body: root.message ?? "")
              
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
    }
}
