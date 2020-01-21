//
//  SettingPageAPIResponse.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/18/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import ObjectMapper

class SettingPageAPIResponse : NSObject, Mappable{
    
    var data : Page?
    var errors : Error?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return SettingPageAPIResponse()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        data <- map["data"]
        errors <- map["errors"]
        message <- map["message"]
        success <- map["success"]
        
    }
}

//
//class PageData : NSObject, Mappable{
//
////    var id : String?
////    var createdAt : String?
////    var detail : String?
////    var detailAr : String?
////    var detailEn : String?
////    var image : String?
////    var slug : String?
////    var title : String?
////    var titleAr : String?
////    var titleEn : String?
////    var updatedAt : String?
//    var settings: Page?
//
//    class func newInstance(map: Map) -> Mappable?{
//        return PageData()
//    }
//    required init?(map: Map){}
//    private override init(){}
//
//    func mapping(map: Map)
//    {
//
//        settings <- map["settings"]
//    }
//}
