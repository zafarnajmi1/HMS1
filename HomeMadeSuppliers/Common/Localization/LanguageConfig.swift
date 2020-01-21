//
//  LanguageConfig.swift
//  TailerOnline
//
//  Created by apple on 3/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation

//MARK:- lanaguage handling
enum LanguageType:String {
    case en
    case ar
}
//selected default
var myDefaultLanguage = LanguageType.en



//language String formatters based on selected langauge
//func setDefaultLanguage(body : Title)-> String  {
//    
//    let defaultEn = body.en
//    
//    var myTitle = myDefaultLanguage == .en ? body.en: body.ar
//    
//    //if arabic is empty then show english title
//    myTitle = myTitle == "" ? defaultEn: myTitle
//    
//    return myTitle ?? ""
//}
