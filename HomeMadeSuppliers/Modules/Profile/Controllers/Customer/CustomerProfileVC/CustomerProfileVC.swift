//
//  CustomerProfileVC.swift
//  TailerOnline
//
//  Created by apple on 3/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Closures

class CustomerProfileVC: UIViewController {

     //MARK:- outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    var profileModel: User?
    var callBack: (()-> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profile".localized
        self.showNavigationBar()
        addBackBarButton()
        requestToGetProfile()
    }
    
   

    func  requestToGetProfile()  {
        showNvLoader()
     
        ProfileManager.shared.getProfile { (result) in
          
            self.hideNvloader()
          
            switch result {
            case .sucess(let root):
                self.profileModel = root.user
               
                    AppSettings.shared.setUser(model: root.user!)
                    self.tableView.backgroundView = nil
                    self.tableView.reloadData()
                    self.callBack?()
                
               
            case .failure(let error):
                self.tableView.setEmptyView(message: error)
            }
        }
    }

    
}

extension CustomerProfileVC : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profileModel?.email == nil ? 0:1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomerProfileTableViewCell.id) as! CustomerProfileTableViewCell
        cell.controller = self
        cell.setData(model: profileModel!)
        
         //MARK:- actions
        cell.editProfileBtn.onTap {
            let board = UIStoryboard(name: "Profile", bundle: nil)
            let vc = board.instantiateViewController(withIdentifier: "EditCustomerProfileVC") as! EditCustomerProfileVC
            vc.userProfile = self.profileModel
            vc.callBack = {
                self.requestToGetProfile()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        
        return cell
    }
    
    
}
