//
//  MenuVC.swift
//  TailerOnline
//
//  Created by apple on 3/7/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import SideMenu

class MenuVC: UIViewController {

     //MARK:-  outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    
    //MARK:-  my life cycle
    var menu = Menu()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
      
       viewWillAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("menuAppear")
//        NotificationCenter.default.post(name: .menuVCDidLoad, object: nil)
       
        tableView.registerHeaderFooterCell(id: MenuHeaderTableViewCell.id )
        tableView.registerCell(id: MenuTableViewCell.id)
        tableView.reloadData()
        tableView.backgroundView?.backgroundColor = .red
        self.navigationController?.navigationBar.isHidden = true
    }
 
    
    
}





 //MARK:-  tableview Implementation
extension MenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160 // header height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerId = "MenuHeaderTableViewCell"
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! MenuHeaderTableViewCell
       
        let user = AppSettings.shared.user
        header.setData(model: user, self)
       
        return header
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.setData(model: menu.data[indexPath.row])
        return cell
    }
    
   
}

extension MenuVC: MenuHeaderTableViewCellDelegate {
    func headerBtnTapped() {
        let msg = "You are in guest Mode. Please login first".localized
        self.presentAlert(message: msg , yes: {
            let s = AppConstant.storyBoard.userEntry
            let vc = s.instantiateViewController(withIdentifier: LoginOptionVC.id) as! LoginOptionVC
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }, no: nil)
       
        
    }
    
}

extension MenuVC:  UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  item = menu.data[indexPath.row]
        
        // delegate?.collapseSidePanels?()
        
        switch item.name {
            
        case "Settings".localized:
            moveToSettingsVC()
            
        case "About Us".localized:
            moveToAboutUsVC()
            
        case "Contact Us".localized:
            moveToContactUsVC()
            
        case "Terms & Conditions".localized:
            moveToTermsAndConditionVC()
            
        case "Profile".localized:
            if myDefaultAccount == .buyer {
                moveToProfileCustomerVC()
            }
            if myDefaultAccount == .seller {
                moveToStoreProfileVC()
            }
            
        case "Manage Products".localized:
           moveToManageProductVC()
            
        case "Rating & Reviews".localized:
            moveToRatingReviewVC()
            
        case "Conversations".localized:
            moveToConversationsVC()
            
        case "Payment Profile".localized:
            moveToPaymentProfileVC()
            
        case "Favorites".localized:
            moveToFavoriteProductVC()
            
        case "My Orders".localized:
            if myDefaultAccount == .buyer {
                moveToMyOrderVC()
            }
            if myDefaultAccount == .seller {
                moveToStoreOrderListVC()
            }
            
            
        case "Categories".localized:
            moveToCategoryVC()
            
        case "Logout".localized:
            logoutConfirmation()
            
        default:
            nvMessage.showError(body: "I am not suppose to open screen")
        }
    }
    
    
    
    
    func moveToAboutUsVC()  {
        let s = AppConstant.storyBoard.setting
        let vc = s.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
       self.navigationController?.pushViewController(vc, animated: true)
    }

    func moveToSettingsVC()  {
        let s = AppConstant.storyBoard.setting
        let vc = s.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToContactUsVC()  {
        let s = AppConstant.storyBoard.setting
        let vc = s.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToTermsAndConditionVC()  {
        let s = AppConstant.storyBoard.setting
        let vc = s.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    func moveToProfileCustomerVC()  {
       
        
        let s = AppConstant.storyBoard.profile
        let vc = s.instantiateViewController(withIdentifier: "CustomerProfileVC") as! CustomerProfileVC
        vc.callBack = {
            self.tableView.reloadData()
        }
        
       self.navigationController?.pushViewController(vc, animated: true)
      
    }
    
    func moveToStoreProfileVC()  {
        let s = AppConstant.storyBoard.profile
        let vc = s.instantiateViewController(withIdentifier: "StoreProfileVC") as! StoreProfileVC
        vc.callBack = {
            self.tableView.reloadData()
        }
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func logoutConfirmation()  {

        self.presentAlert(message: "Do you want to logout?".localized, yes: {
         
            self.requesToLogout()
            
        }, no: nil)
        
    }
    
    
    func requesToLogout()  {
        self.showNvLoader()
        AuthManager.shared.logoutUser { (completion) in
            self.hideNvloader()
            switch completion {
            case .sucess(let model):
                AppSettings.shared.resetUserProfile()
                myDefaultAccount = .none
                print("server message:\(model.message ?? "")")
               // nvMessage.showSuccess(body: "successfully logout" ) {
                  let s = AppConstant.storyBoard.userEntry
                  let vc = s.instantiateViewController(withIdentifier: LoginOptionVC.id) as! LoginOptionVC
                  self.navigationController?.hidesBottomBarWhenPushed = true
                  vc.modalTransitionStyle = .crossDissolve
                  self.navigationController?.pushViewController(vc, animated: true)
              //  }
            case .failure(let error):
                nvMessage.showError(title: "Logout".localized, body: error)
            }
        }
    }
    
    
   
    
    func moveToRatingReviewVC()  {
        let s = AppConstant.storyBoard.profile
        let vc = s.instantiateViewController(withIdentifier: RatingReviewVC.id) as! RatingReviewVC
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    
    func moveToPaymentProfileVC()  {
        let s = AppConstant.storyBoard.profile
        let vc = s.instantiateViewController(withIdentifier: PaymentProfileVC.id) as! PaymentProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToFavoriteProductVC()  {
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: FavoriteProductVC.id) as! FavoriteProductVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToMyOrderVC()  {
        let s = AppConstant.storyBoard.order
        let vc = s.instantiateViewController(withIdentifier: MyOrderListVC.id) as! MyOrderListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func moveToCategoryVC()  {
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func moveToConversationsVC()  {
        let s = AppConstant.storyBoard.chat
        let vc = s.instantiateViewController(withIdentifier: ConversationsVC.id) as! ConversationsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

  
    func moveToStoreOrderListVC()  {
        let s = AppConstant.storyBoard.order
        let vc = s.instantiateViewController(withIdentifier: StoreOrderListVC.id) as! StoreOrderListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToManageProductVC()  {
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: ManageProductVC.id) as! ManageProductVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
}




