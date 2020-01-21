//
//  NavigatonBarBackButtonExtension.swift
//  TailerOnline
//
//  Created by apple on 3/1/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import BadgeHub











extension UIViewController {
   
       //MARK:- Back button
    func addBackBarButton()  {
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        
        switch myDefaultLanguage {
        case .ar:
            if let imgBackArrow = UIImage(named: "BackArrowAr") {
                imageView.image = imgBackArrow
            }
        default:
            if let imgBackArrow = UIImage(named: "BackArrow") {
                imageView.image = imgBackArrow
            }
        }
        
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backToMain))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view )
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
       
    }
    
    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
  
    
  
    func addMenuBarBtn() {
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        
        switch myDefaultLanguage {
        case .ar:
            if let imgBackArrow = UIImage(named: "Menu") {
                imageView.image = imgBackArrow
            }
        default:
            if let imgBackArrow = UIImage(named: "Menu") {
                imageView.image = imgBackArrow
            }
        }
        
        view.addSubview(imageView)
    
        let backTap = UITapGestureRecognizer(target: self, action: #selector(toggleMenu))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view )
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func toggleMenu() {
        NotificationCenter.default.post(name: .menuBtnTapped, object: nil)
    }
    
    
    
    func setTextButton() {
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.adjustsFontSizeToFitWidth =  true
        label.text = "Request Quote".localized
        label.font = UIFont(name: "Lato-Bold", size: 14)
      
        view.addSubview(label)
        view.zoomAnimate()
        let backTap = UITapGestureRecognizer(target: self, action: #selector(moveToRequestQuote))
        view.addGestureRecognizer(backTap)
        
        let barButtonItem = UIBarButtonItem(customView: view )
        self.navigationItem.rightBarButtonItem = barButtonItem
       
    }
    
    @objc func moveToRequestQuote() { }
    
    func hideNavigationBarRightBtn() {
         self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    
    func setFilterBarButton() {
     
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        
        imageView.image =  UIImage(named: "FilterWhite")
       
        view.addSubview(imageView)
        view.zoomAnimate()
        let backTap = UITapGestureRecognizer(target: self, action: #selector(moveToAdvanceSearchVC))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view )
        self.navigationItem.rightBarButtonItem = leftBarButtonItem
    }
    
    @objc func moveToAdvanceSearchVC() { }
    
    
  
    func setEditBtn() {
        
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        
        imageView.image =  UIImage(named: "EditWhite")
        
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(editBtnTapped))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view )
        self.navigationItem.rightBarButtonItem = leftBarButtonItem
    }
    
    @objc func editBtnTapped() {
       nvMessage.showStatusWarning(body: "Select or unselect")
    }
    
    func setDeleteBtn(tintColor: UIColor = .white) {
        
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
    
      
        imageView.image =  UIImage(named: "Delete")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = tintColor
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(deleteBtnTapped))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view )
        self.navigationItem.rightBarButtonItem = leftBarButtonItem
    }
    
    @objc func deleteBtnTapped() {
        nvMessage.showStatusWarning(body: "Select or unselect")
    }
    
    
    
    
    
    
    
    
//    func setAddNavigationBtn() -> UIBarButtonItem {
//        
//        //your custom view for back image with custom size
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
//        
//        imageView.image =  UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate)
//        imageView.tintColor = .white
//        view.addSubview(imageView)
//        
//        let backTap = UITapGestureRecognizer(target: self, action: #selector(addBtnTapped))
//        view.addGestureRecognizer(backTap)
//        
//        let leftBarButtonItem = UIBarButtonItem(customView: view )
//        self.navigationItem.rightBarButtonItem = leftBarButtonItem
//        return leftBarButtonItem
//    }
//    
//    @objc func addBtnTapped() {
//        nvMessage.showStatusWarning(body: "Select or unselect")
//    }
    
    func setCartBtn() -> UIBarButtonItem {
        
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 20, height: 20))
        
        imageView.image =  UIImage(named: "CartWhite")
        let hub = BadgeHub(view: imageView)
        hub.setCount(AppUserDefault.shared.cartBadgeItems ?? 0)
        hub.scaleCircleSize(by: 0.65)
        hub.moveCircleBy(x: 5, y: -4 )
        hub.setCircleColor(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), label: .white)
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(moveToCartVC))
        view.addGestureRecognizer(backTap)
        
        return UIBarButtonItem(customView: view )
      
    }
    
    func setShareBtn() -> UIBarButtonItem {
        
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 20, height: 20))
        
        imageView.image =  UIImage(named: "ShareWhite")
        
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(moveToShare))
        view.addGestureRecognizer(backTap)
        
        return UIBarButtonItem(customView: view )
        
    }
   
    @objc func moveToShare()  { }
    
    func setChatBtn() -> UIBarButtonItem {
        
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 20, height: 20))
        
        imageView.image =  UIImage(named: "Message")
        
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(moveToChatVC))
        view.addGestureRecognizer(backTap)
        
        return UIBarButtonItem(customView: view )
        
    }
    
    @objc func moveToChatVC()  { }
    
    

    @objc func moveToCartVC() { }
    
    //MARK:- setup Login Button
    func setLoginBarButton() {
      
        //first Item
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let imageView = UIImageView(frame: containerView.frame)
        containerView.addSubview(imageView)
        imageView.image =  UIImage(named: "UserWhite")
      
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveToLoginOptionVC))
        containerView.addGestureRecognizer(tap)
    
        let userIcon = UIBarButtonItem(customView: containerView )
        //second Item
        let containerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        let label = UILabel(frame: containerView2.frame)
        containerView2.addSubview(label)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.adjustsFontSizeToFitWidth =  true
        label.text = "Login".localized
        label.font = UIFont(name: "Lato-Bold", size: 12)
   
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(moveToLoginOptionVC))
        containerView2.addGestureRecognizer(tap2)
        
        let userTitle = UIBarButtonItem(customView: containerView2 )
        
        self.navigationItem.rightBarButtonItems = [userTitle, userIcon]
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [userTitle, userIcon]
    }
    
    @objc func moveToLoginOptionVC() {
        print("Override Me")
    }
    
    
    
    
    func checkoutNavigationLabel(string: String?) {
        
       
        let containerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let label = UILabel(frame: containerView2.frame)
        containerView2.addSubview(label)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.adjustsFontSizeToFitWidth =  true
        label.text = string ?? ""
        label.font = robotoMedium16
        label.textAlignment = .right
        
        let userTitle = UIBarButtonItem(customView: containerView2 )
        
        self.navigationItem.rightBarButtonItems = [userTitle]
       
    }
   
}




 //MARK:-  helpers naivgationBar
extension UIViewController {
    
    func hideBackButton()  {
        self.navigationItem.setHidesBackButton(true, animated:false)
    }
    
    
    
    func hideNavigationBar(animated: Bool = false) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    
    func showNavigationBar(animated: Bool = false) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setRootNavigationBar(title: String )  {
        navigationController?.navigationBar.topItem?.title = title
        
    }
    
    
}
