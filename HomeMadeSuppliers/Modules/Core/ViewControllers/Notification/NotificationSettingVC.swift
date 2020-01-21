//
//  NotificationSettingVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/16/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//



import UIKit
import XLPagerTabStrip
import ObjectMapper

class NotificationSettingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
       tableView.registerCell(id: NotificationSettingTableViewCell.id)
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if myDefaultLanguage == .ar {
        self.view.semanticContentAttribute = .forceRightToLeft
          }else{
           self.view.semanticContentAttribute = .forceLeftToRight
          }
        
         requestToGetProfile()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if myDefaultLanguage == .ar {
         self.view.semanticContentAttribute = .forceRightToLeft
           }else{
            self.view.semanticContentAttribute = .forceLeftToRight
           }
    }
    
    
}

 //MARK:-  api requests
extension NotificationSettingVC {
    func  requestToGetProfile()  {
        showNvLoader()
        ProfileManager.shared.getProfile { (result) in
            self.hideNvloader()
            
            switch result {
            case .sucess(let root):
                AppSettings.shared.setUser(model: root.user!)
                self.tableView.backgroundView = nil
                self.tableView.reloadData()
            case .failure(let error):
                self.tableView.setEmptyView(message: error)
            }
        }
    }
}

extension NotificationSettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationSettingModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingTableViewCell.id) as! NotificationSettingTableViewCell
        let model = notificationSettingModel.list[indexPath.row]
        if myDefaultLanguage == .ar {
            cell.mySwitch.semanticContentAttribute = .forceRightToLeft
               }else{
            cell.mySwitch.semanticContentAttribute = .forceLeftToRight
               }
        
        cell.setData(model: model)
        return cell
    }
    
    
}

