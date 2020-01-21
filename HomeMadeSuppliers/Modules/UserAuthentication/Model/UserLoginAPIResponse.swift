//
//  RegisterAPIResponse.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/20/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//


import Foundation
import ObjectMapper


class UserLoginAPIResponse : NSObject, Mappable{
    
    var user : User?
    var errors : ErrorModel?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return UserLoginAPIResponse()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        user <- map["data"]
        errors <- map["errors"]
        message <- map["message"]
        success <- map["success"]
        
    }
    
}

class User : NSObject, Mappable{
    
    var id : String?
    var accountType : String?
    var address : String?
    var addresses : [Address]?
    var amountRefundRequested : Bool?
    var amountRefunded : Int?
    var authorization : String?
    var averageRating : Double?
    var balanceEarned : Int?
    var canReviewUsers : [CanReviewUser]?
    var deliverableCities : [DeliverableCity]?
    var createdAt : String?
    var currentBalance : Int?
    var descriptionField : String?
    var descriptionAr : String?
    var descriptionEn : String?
    var domesticShipping : Price?
    var email : String?
    var fcmTokens : [AnyObject]?
    var firstName : String?
    var fullName : String?
    var gender : String?
    var image : String?
    var internationalShipping : Price?
    var isActive : Bool?
    var isCartProcessing : Bool?
    var isEmailVerified : Bool?
    var isLoggedIn : Bool?
 
    var lastName : String?
    var location : [Double]?
    var paypalClientId : String?
    var paypalSecretId : String?
    var phone : String?
    var products : [AnyObject]?
    var role : Role?
    var storeName : String?
    var storeNameAr : String?
    var storeNameEn : String?
    var updatedAt : String?
    var verificationCode : Int?
    
    var exists : Bool?
    var availabilitySetting: String?
    var locationSetting: Bool?
    var notificationsSetting : NotificationsSetting?
    class func newInstance(map: Map) -> Mappable?{
        return User()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        accountType <- map["accountType"]
        address <- map["address"]
        addresses <- map["addresses"]
        amountRefundRequested <- map["amountRefundRequested"]
        amountRefunded <- map["amountRefunded"]
        authorization <- map["authorization"]
        averageRating <- map["averageRating"]
        balanceEarned <- map["balanceEarned"]
        canReviewUsers <- map["canReviewUsers"]
        deliverableCities <- map["deliverableCities"]
        createdAt <- map["createdAt"]
        currentBalance <- map["currentBalance"]
        descriptionField <- map["description"]
        descriptionAr <- map["descriptionAr"]
        descriptionEn <- map["descriptionEn"]
        domesticShipping <- map["domesticShipping"]
        email <- map["email"]
       
        fcmTokens <- map["fcmTokens"]
        firstName <- map["firstName"]
        fullName <- map["fullName"]
        gender <- map["gender"]
      
        image <- map["image"]
        internationalShipping <- map["internationalShipping"]
        isActive <- map["isActive"]
        isCartProcessing <- map["isCartProcessing"]
        isEmailVerified <- map["isEmailVerified"]
        isLoggedIn <- map["isLoggedIn"]
      
        lastName <- map["lastName"]
        location <- map["location"]
        paypalClientId <- map["paypalClientId"]
        paypalSecretId <- map["paypalSecretId"]
        phone <- map["phone"]
        products <- map["products"]
        role <- map["role"]
        storeName <- map["storeName"]
        storeNameAr <- map["storeNameAr"]
        storeNameEn <- map["storeNameEn"]
        updatedAt <- map["updatedAt"]
        verificationCode <- map["verificationCode"]
        
        exists <- map["exists"]
        availabilitySetting <- map["availabilitySetting"]
        locationSetting <- map["locationSetting"]
        notificationsSetting <- map["notificationsSetting"]
    }
    
}

class NotificationsSetting : NSObject, Mappable{
    
    var chat : Bool?
    var orders : Bool?
    var system : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return NotificationsSetting()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        chat <- map["chat"]
        orders <- map["orders"]
        system <- map["system"]
        
    }
    
}


//Todo:- common class
class DeliverableCity : NSObject, Mappable{
    
    var id : String?
    var city : City?
    var price : Price?
    var title : String?
    var isDomestic = true
    
    class func newInstance(map: Map) -> Mappable?{
        return DeliverableCity()
    }
    required init?(map: Map){}
    override init(){}
    init(price: Price?, city: City?, isDomestic: Bool = true) {
        self.price = price
        self.city = city
        self.isDomestic = isDomestic
    }
    func mapping(map: Map)
    {
        id <- map["_id"]
        city <- map["city"]
        price <- map["price"]
  
    }
}

class Price : NSObject, Mappable{
    
    var aed : Currency?
    var usd : Currency?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Price()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        aed <- map["aed"]
        usd <- map["usd"]
        
    }
}



class Currency : NSObject,  Mappable{
    
    var amount : Int?
    var formatedAmount : String?
    var symbol : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Currency()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        amount <- map["amount"]
        formatedAmount <- map["formatedAmount"]
        symbol <- map["symbol"]
        
    }

    
}
class Role : NSObject, Mappable{
    
    var id : String?
    var permissions : Permission?
    var title : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Role()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        permissions <- map["permissions"]
        title <- map["title"]
        
    }
    
}

class Address : NSObject,  Mappable{
    
    var id : String?
    var address1 : String?
    var address2 : String?
    var address3 : String?
    var addressType : String?
    var email : String?
    var firstName : String?
    var lastName : String?
    var phone : String?
    var postCode : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Address()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        address1 <- map["address1"]
        address2 <- map["address2"]
        address3 <- map["address3"]
        addressType <- map["addressType"]
        email <- map["email"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        phone <- map["phone"]
        postCode <- map["postCode"]
        
    }
}

class Permission : NSObject, Mappable{
    
    var canDeleteCategories : Bool?
    var canDeleteCharacteristics : Bool?
    var canDeleteCities : Bool?
    var canDeleteFeatures : Bool?
    var canDeleteManufacturers : Bool?
    var canDeletePage : Bool?
    var canDeleteProducts : Bool?
    var canDeleteRole : Bool?
    var canDeleteSlider : Bool?
    var canDeleteStores : Bool?
    var canDeleteSubadmin : Bool?
    var canEditSetting : Bool?
    var canGiveFeedback : Bool?
    var canPasswordChange : Bool?
    var canPermissions : Bool?
    var canProfile : Bool?
    var canProfileUpdate : Bool?
    var canReportError : Bool?
    var canStoreCategories : Bool?
    var canStoreCharacteristics : Bool?
    var canStoreCities : Bool?
    var canStoreFeatures : Bool?
    var canStoreManufacturers : Bool?
    var canStorePage : Bool?
    var canStoreProducts : Bool?
    var canStoreRole : Bool?
    var canStoreSlider : Bool?
    var canStoreStores : Bool?
    var canStoreSubadmin : Bool?
    var canUpdateCategories : Bool?
    var canUpdateCharacteristics : Bool?
    var canUpdateCities : Bool?
    var canUpdateFeatures : Bool?
    var canUpdateManufacturers : Bool?
    var canUpdatePage : Bool?
    var canUpdateProducts : Bool?
    var canUpdateRole : Bool?
    var canUpdateSetting : Bool?
    var canUpdateSlider : Bool?
    var canUpdateStores : Bool?
    var canUpdateSubadmin : Bool?
    var canViewCategories : Bool?
    var canViewCharacteristics : Bool?
    var canViewCities : Bool?
    var canViewFeatures : Bool?
    var canViewManufacturers : Bool?
    var canViewPages : Bool?
    var canViewProducts : Bool?
    var canViewRoles : Bool?
    var canViewSliders : Bool?
    var canViewStores : Bool?
    var canViewSubadmins : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Permission()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        canDeleteCategories <- map["canDeleteCategories"]
        canDeleteCharacteristics <- map["canDeleteCharacteristics"]
        canDeleteCities <- map["canDeleteCities"]
        canDeleteFeatures <- map["canDeleteFeatures"]
        canDeleteManufacturers <- map["canDeleteManufacturers"]
        canDeletePage <- map["canDeletePage"]
        canDeleteProducts <- map["canDeleteProducts"]
        canDeleteRole <- map["canDeleteRole"]
        canDeleteSlider <- map["canDeleteSlider"]
        canDeleteStores <- map["canDeleteStores"]
        canDeleteSubadmin <- map["canDeleteSubadmin"]
        canEditSetting <- map["canEditSetting"]
        canGiveFeedback <- map["canGiveFeedback"]
        canPasswordChange <- map["canPasswordChange"]
        canPermissions <- map["canPermissions"]
        canProfile <- map["canProfile"]
        canProfileUpdate <- map["canProfileUpdate"]
        canReportError <- map["canReportError"]
        canStoreCategories <- map["canStoreCategories"]
        canStoreCharacteristics <- map["canStoreCharacteristics"]
        canStoreCities <- map["canStoreCities"]
        canStoreFeatures <- map["canStoreFeatures"]
        canStoreManufacturers <- map["canStoreManufacturers"]
        canStorePage <- map["canStorePage"]
        canStoreProducts <- map["canStoreProducts"]
        canStoreRole <- map["canStoreRole"]
        canStoreSlider <- map["canStoreSlider"]
        canStoreStores <- map["canStoreStores"]
        canStoreSubadmin <- map["canStoreSubadmin"]
        canUpdateCategories <- map["canUpdateCategories"]
        canUpdateCharacteristics <- map["canUpdateCharacteristics"]
        canUpdateCities <- map["canUpdateCities"]
        canUpdateFeatures <- map["canUpdateFeatures"]
        canUpdateManufacturers <- map["canUpdateManufacturers"]
        canUpdatePage <- map["canUpdatePage"]
        canUpdateProducts <- map["canUpdateProducts"]
        canUpdateRole <- map["canUpdateRole"]
        canUpdateSetting <- map["canUpdateSetting"]
        canUpdateSlider <- map["canUpdateSlider"]
        canUpdateStores <- map["canUpdateStores"]
        canUpdateSubadmin <- map["canUpdateSubadmin"]
        canViewCategories <- map["canViewCategories"]
        canViewCharacteristics <- map["canViewCharacteristics"]
        canViewCities <- map["canViewCities"]
        canViewFeatures <- map["canViewFeatures"]
        canViewManufacturers <- map["canViewManufacturers"]
        canViewPages <- map["canViewPages"]
        canViewProducts <- map["canViewProducts"]
        canViewRoles <- map["canViewRoles"]
        canViewSliders <- map["canViewSliders"]
        canViewStores <- map["canViewStores"]
        canViewSubadmins <- map["canViewSubadmins"]
        
    }
    
}


class ErrorModel : NSObject, Mappable{
    
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ErrorModel()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        
    }
    
}
