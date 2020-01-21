//
//  StoreProfileVC.swift
//  TailerOnline
//
//  Created by apple on 3/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Closures
import Cosmos

class StoreProfileVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
   
     //MARK:- varialbles
    var callBack: (()-> Void)?
    var user: User!
    
    override func viewDidLoad() {
        
        self.title = "Profile".localized
        self.showNavigationBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestToGetProfile()
    }
    
    func setupView()  {
        addBackBarButton()
        setEditBtn()
        setLocalization()
        
        self.user = AppSettings.shared.user
        self.tableView.registerCell(id: "StoreProfileHeaderTableViewCell")
        self.tableView.registerCell(id: "StoreProfileFooterTableViewCell")
       
    }
    
//    override func backToMain() {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    func setLocalization()  {
        self.setViewDirectionByLanguage()
    }
    
    override func editBtnTapped() {
        let s = AppConstant.storyBoard.profile
        let vc = s.instantiateViewController(withIdentifier: "EditStoreProfileVC") as! EditStoreProfileVC
        vc.callback = {
            self.user = AppSettings.shared.user
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func  requestToGetProfile()  {
        showNvLoader()
        ProfileManager.shared.getProfile { (result) in
            self.hideNvloader()
            
            switch result {
            case .sucess(let root):
                self.user = root.user
                AppSettings.shared.setUser(model: self.user)
                
                self.tableView.reloadData()
                self.callBack?()
            case .failure(let error):
                self.tableView.setEmptyView(message: error)
            }
        }
    }
    
   
}

extension StoreProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreProfileHeaderTableViewCell", for: indexPath) as! StoreProfileHeaderTableViewCell
            cell.setData(model: user)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
            let model = user.deliverableCities!
            cell.setData(model: model, isRemovableCell: false)
            return cell
            
        default: // footer cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreProfileFooterTableViewCell", for: indexPath) as! StoreProfileFooterTableViewCell
                cell.setData(model: user)
            return cell
        }
        
        
    }
}

