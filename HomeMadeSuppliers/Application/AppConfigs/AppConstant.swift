//
//  ImageConstants.swift
//  TailerOnline
//
//  Created by apple on 3/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit



//FIXME: struct nameType ( add Post Fix as Type In struct)

class AppConstant {
    
    struct loginOrSignup {
        static var login = false
        static var signup = false //show 10 items in per page
    }
    
    struct defaults {
        static let pagination = 20
        static let homePagination = 10 //show 10 items in per page
    }
    
    struct error {
        static let objectMapper = "ObjectMapper failed to serialize response."
        static let serverIssue = "Something went wrong, please try later.".localized
    }
    
    struct storyBoard {
        static let userEntry =  UIStoryboard(name: "UserEntry", bundle: nil)
        static let chat = UIStoryboard(name: "Chat", bundle: nil)
        static let order = UIStoryboard(name: "Order", bundle: nil)
        static let main =  UIStoryboard(name: "Main", bundle: nil)
        static let profile =  UIStoryboard(name: "Profile", bundle: nil)
        static let setting = UIStoryboard(name: "Setting", bundle: nil)
        static let product = UIStoryboard(name: "Product", bundle: nil)
        static let checkout = UIStoryboard(name: "Checkout", bundle: nil)
    }
    
    struct images {
        static let checkCircle = UIImage(named: "CircleUnselect")
        static let checkCircleActive = UIImage(named: "CircleSelectRed")
        static let checkBoxActive = UIImage(named: "CircleSelectRed")
        static let checkBox = UIImage(named: "SquareWithBorder")
        static let logo = UIImage(named: "Logo")
        static let login = UIImage(named: "login")
       
    }
    
    struct placeHolders {
        static let user = "User"
        static let product = "Product"
        static let store = "Store"
        static let category = "Category"
        static let storeList = "Store-listing"
        
    }
}






