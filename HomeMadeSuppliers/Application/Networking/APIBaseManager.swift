//
//  APIBaseManager.swift
//  TailerOnline
//
//  Created by apple on 3/28/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import Alamofire


class APIBaseManager: NSObject {
    
    var sessionManager: SessionManager
    var basePath: String
    var rawHeader: HTTPHeaders
   
    
    override init() {
        
        sessionManager = Alamofire.SessionManager.default
       
        
        basePath = AppNetwork.current.baseURL
        
        
        
        rawHeader = ["Content-Type": "application/json"]

    }
    
    func authHeader() -> HTTPHeaders  {
        guard  let authId = AppSettings.shared.userToken  else {
           return ["Authorization": ""]
        }
        return ["Authorization": authId]
    }
    
  
    //1: API Sub Path  Constants
    
    struct auth {
        static let login = "login"
        static let register = "register"
        static let authEmailVerification = "auth/email-verification"
        static let authResendVerficationCode = "auth/resend-verification-code"
        static let forgotPassword = "forgot-password"
        static let resetPassword = "reset-password"
        static let socialLogin = "social-login"
        static let socialLoginCheck = "social-login/check"
        static let logout = "auth/logout"
    }
    
    //Todo:-  authorization optional
    struct front {
        static let settings = "settings"
        static let page = "page"
        static let contactus = "contact-us"
        static let stores = "auth/stores/apps"
        static let storeDetail = "auth/store/detail"
        static let productSearch = "auth/product/search"
        static let authProduct = "auth/products"
        static let authProductFavorite = "auth/product/favorite"
        static let authProductNotifyOnRestock = "auth/product/notify-on-restock"
        static let authProductDetail = "auth/product/detail"
        static let authProductSubmitReview = "auth/product/review"
        static let authProductReviews = "auth/product/reviews"
        static let authStoreSubmitReview = "auth/store/review"
        static let authStoreReviews = "auth/store/reviews"
        static let authProductDelete = "auth/product/delete"
        static let featuresCharacteristics = "features-characteristics"
        static let authProductStore = "auth/product/store"
        static let authProductUpdate = "auth/product/update"
    
        
        

        
        

    }
    
    
    struct cart {
        static let authCartAddProduct = "auth/cart/add-product"
        static let authCart = "auth/cart"
        static let authCartUpdate = "auth/cart/update"
        static let authCartProductRemove = "auth/cart/product/remove"
    }
    
    struct profile{
        
        static let authProfile = "auth/profile"
        static let authChangePassword = "auth/change-password"
        static let authUpdateProfile = "auth/update-profile"
        static let authUpdateStorePaypalCredentials = "auth/update-store/paypal-credentials"
        static let authRemoveDeveliverable = "auth/remove/develiverable"
        static let authStoreDeveliverables = "auth/store/develiverables"
        static let authUpdateProfileSettings = "auth/update-profile-settings"
    }
   
    struct order {
        static let authUpdateUserAddresses = "auth/update/user-addresses"
        static let authCheckout = "auth/checkout"
        static let authOrdersStores = "auth/orders/stores"
        static let authOrdersUsers = "auth/orders/users"
        static let authOrdersStoresDetail = "auth/orders/stores/detail"
        static let authOrderDetail = "auth/order/detail"
        static let authOrderItemRefunded = "auth/order/item-refunded"
        static let authShipProduct = "auth/ship/product"
        static let authCompleteProduct = "auth/complete/product"
    }
}


    

