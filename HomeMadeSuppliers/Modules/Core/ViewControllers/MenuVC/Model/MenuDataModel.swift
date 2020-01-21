//
//  MenuDataModel.swift
//  TailerOnline
//
//  Created by apple on 3/11/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation


class  MenuModel {
    var name: String!
    var image: String!
    
   fileprivate init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
}

// main class
final class Menu {
    
    var data: [MenuModel] {
        
        get {return setDataByAccountType() }
    }
    
    
    private func setDataByAccountType() -> [MenuModel] {
        switch myDefaultAccount {
        case .seller:
            return sellerMenu()
        case .buyer:
            return buyerMenu()
        default:
            return guestMenu()
        }
    }
    
    
    private func guestMenu() -> [MenuModel] {
        
        var list = [MenuModel]()
        
        list.append(MenuModel(name: "Settings".localized, image: "Setting"))
        list.append(MenuModel(name: "Terms & Conditions".localized, image: "Terms&Cond"))
        list.append(MenuModel(name: "About Us".localized, image: "About"))
        list.append(MenuModel(name: "Contact Us".localized, image: "Contact"))
        //list.append(MenuModel(name: "Login", image: "UserWhite"))
        return list
    }
    
    private func buyerMenu() -> [MenuModel] {
    
        var list = [MenuModel]()
        list.append(MenuModel(name: "Profile".localized, image: "UserRed"))
        list.append(MenuModel(name: "Conversations".localized, image: "Conversation"))
        list.append(MenuModel(name: "My Orders".localized, image: "Order"))
        list.append(MenuModel(name: "Favorites".localized, image: "HeartRed"))
        list.append(MenuModel(name: "Categories".localized, image: "CategoryRed"))
        list.append(MenuModel(name: "Settings".localized, image: "Setting"))
        list.append(MenuModel(name: "Terms & Conditions".localized, image: "Terms&Cond"))
        list.append(MenuModel(name: "About Us".localized, image: "About"))
        list.append(MenuModel(name: "Contact Us".localized, image: "Contact"))
        list.append(MenuModel(name: "Logout".localized, image: "Logout"))
        return list
    }
    
    private func sellerMenu() -> [MenuModel] {
        
        var list = [MenuModel]()
        list.append(MenuModel(name: "Profile".localized, image: "UserRed"))
        list.append(MenuModel(name: "Manage Products".localized, image: "ManageProducts"))
        list.append(MenuModel(name: "Conversations".localized, image: "Conversation"))
        list.append(MenuModel(name: "My Orders".localized, image: "Order"))
        list.append(MenuModel(name: "Rating & Reviews".localized, image: "RatingAndReview"))
        list.append(MenuModel(name: "Payment Profile".localized, image: "Payment"))
        list.append(MenuModel(name: "Settings".localized, image: "Setting"))
        list.append(MenuModel(name: "Terms & Conditions".localized, image: "Terms&Cond"))
        list.append(MenuModel(name: "About Us".localized, image: "About"))
        list.append(MenuModel(name: "Contact Us".localized, image: "Contact"))
     
        list.append(MenuModel(name: "Logout".localized, image: "Logout"))
        return list
    }
    
   
    
}
