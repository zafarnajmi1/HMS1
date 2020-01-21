//
//  AccountTypeConfig.swift
//  TailerOnline
//
//  Created by apple on 3/11/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation

//MARK:- lanaguage handling
enum AccountType:String {
    case guest
    case buyer
    case seller
    case none
}
//selected default
var myDefaultAccount = AccountType.none
