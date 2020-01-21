//
//  RootSettingModel.swift
//  TailerOnline
//
//  Created by apple on 4/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import ObjectMapper

class SettingAPIResponse : NSObject, Mappable{
    
    var data : SettingData?
    var errors : Error?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return SettingAPIResponse()
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


class SettingData : NSObject, Mappable{
    
    var categories : [Category]?
    var cities : [City]?
    var pages : [Page]?
    var searchCities : [City]?
    var settings : Setting?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return SettingData()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        categories <- map["categories"]
        cities <- map["cities"]
        pages <- map["pages"]
        searchCities <- map["searchCities"]
        settings <- map["settings"]
        
    }
}

class Page : NSObject, Mappable{
    
    var id : String?
    var createdAt : String?
    var detail : String?
    var detailAr : String?
    var detailEn : String?
    var image : String?
    var slug : String?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    var updatedAt : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Page()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        createdAt <- map["createdAt"]
        detail <- map["detail"]
        detailAr <- map["detailAr"]
        detailEn <- map["detailEn"]
        image <- map["image"]
        slug <- map["slug"]
        title <- map["title"]
        titleAr <- map["titleAr"]
        titleEn <- map["titleEn"]
        updatedAt <- map["updatedAt"]
        
    }
}


class Setting : NSObject, Mappable{
    
    var id : String?
    var aboutShortDescription : String?
    var aboutShortDescriptionAr : String?
    var aboutShortDescriptionEn : String?
    var aboutUs : String?
    var androidApp : String?
    var contactAddress : String?
    var contactAddressAr : String?
    var contactAddressEn : String?
    var contactEmail : String?
    var contactFeedbackSelectors : String?
    var contactFeedbackSelectorsAr : String?
    var contactFeedbackSelectorsEn : String?
    var createdAt : String?
    var emailFrom : String?
    var emailSenderName : String?
    var facebook : String?
    var google : String?
    var instagram : String?
    var iosApp : String?
    var latitude : AnyObject?
    var location : String?
    var longitude : AnyObject?
    var mainAboutUs : String?
    var paypalClientId : AnyObject?
    var paypalClientSecret : AnyObject?
    var paypalEnv : AnyObject?
    var paypalProductionKey : AnyObject?
    var phone1 : String?
    var phone2 : String?
    var pinterest : String?
    var privacy : String?
    var projectTitle : String?
    var projectTitleAr : String?
    var projectTitleEn : String?
    var serviceCharges : Int?
    var serviceChargesPersentage : Int?
    var snapchat : String?
    var terms : String?
    var twitter : String?
    var updatedAt : String?
    var whatsapp: String?
    
    class func newInstance(map: Map) -> Mappable?{
        return Setting()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        aboutShortDescription <- map["aboutShortDescription"]
        aboutShortDescriptionAr <- map["aboutShortDescriptionAr"]
        aboutShortDescriptionEn <- map["aboutShortDescriptionEn"]
        aboutUs <- map["aboutUs"]
        androidApp <- map["androidApp"]
        contactAddress <- map["contactAddress"]
        contactAddressAr <- map["contactAddressAr"]
        contactAddressEn <- map["contactAddressEn"]
        contactEmail <- map["contactEmail"]
        contactFeedbackSelectors <- map["contactFeedbackSelectors"]
        contactFeedbackSelectorsAr <- map["contactFeedbackSelectorsAr"]
        contactFeedbackSelectorsEn <- map["contactFeedbackSelectorsEn"]
        createdAt <- map["createdAt"]
        emailFrom <- map["emailFrom"]
        emailSenderName <- map["emailSenderName"]
        facebook <- map["facebook"]
        google <- map["google"]
        instagram <- map["instagram"]
        iosApp <- map["iosApp"]
        latitude <- map["latitude"]
        location <- map["location"]
        longitude <- map["longitude"]
        mainAboutUs <- map["mainAboutUs"]
        paypalClientId <- map["paypalClientId"]
        paypalClientSecret <- map["paypalClientSecret"]
        paypalEnv <- map["paypalEnv"]
        paypalProductionKey <- map["paypalProductionKey"]
        phone1 <- map["phone1"]
        phone2 <- map["phone2"]
        pinterest <- map["pinterest"]
        privacy <- map["privacy"]
        projectTitle <- map["projectTitle"]
        projectTitleAr <- map["projectTitleAr"]
        projectTitleEn <- map["projectTitleEn"]
        serviceCharges <- map["serviceCharges"]
        serviceChargesPersentage <- map["serviceChargesPersentage"]
        snapchat <- map["snapchat"]
        terms <- map["terms"]
        twitter <- map["twitter"]
        updatedAt <- map["updatedAt"]
        whatsapp <- map["whatsapp"]
        
    }
}

//Todo:- common class
class City : NSObject, Mappable{
    
    var id : String?
    var createdAt : String?
    var isActive : Bool?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    var updatedAt : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return City()
    }
    required init?(map: Map){}
     override init(){}
    init(title: String) {
        self.title = title
    }

    
    func mapping(map: Map)
    {
        id <- map["_id"]
        createdAt <- map["createdAt"]
        isActive <- map["isActive"]
        title <- map["title"]
        titleAr <- map["titleAr"]
        titleEn <- map["titleEn"]
        updatedAt <- map["updatedAt"]
        
    }
}


//Todo:- common class
class Category : NSObject,  Mappable{
    
    var id : String?
    var children : [Category]?
    var image : String?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    var isSelected: Bool?
    
    class func newInstance(map: Map) -> Mappable?{
        return Category()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        children <- map["children"]
        image <- map["image"]
        title <- map["title"]
        titleAr <- map["titleAr"]
        titleEn <- map["titleEn"]
        
    }
}
