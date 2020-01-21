//
//  StoreAPIResponse.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/30/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper
import GoogleMaps

class StoreAPIResponse : NSObject, Mappable{
    
    var data : StoreData?
    var errors : Error?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return StoreAPIResponse()
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


class StoreData : NSObject, Mappable{
    
    var collection : [Store]?
    var pagination : Pagination?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return StoreData()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        collection <- map["collection"]
        pagination <- map["pagination"]
        
    }
    
}


class Store : NSObject, Mappable{
    
    var id : String?
    var averageRating : Double?
    var address: String?
    var deliverableCities : [DeliverableCity]?
    var domesticShipping : Price?
    var internationalShipping: Price?
    var descriptionField : String?
    var descriptionAr : String?
    var descriptionEn : String?
    var image : String?
    var location : [Double]?
    var storeName : String?
    var storeNameAr : String?
    var storeNameEn : String?
    var canReviewUsers: [CanReviewUser]?
    var availabilitySetting: String?
    var locationSetting: Bool?
    var city: City?
    
    var marker : GMSMarker?
    var addressExchange : String? {
        get {
            if locationSetting == false {
                return city?.title
            }
            return address
        }
    }
    var locationExchange: [Double]? {
        get {
            if locationSetting == false {
                return nil
            }
            return location
        }
    }
    
    var isBusy: Bool {
        get {
            guard let status = availabilitySetting else { return false }
            return status.contains("busy")
        }
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return Store()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        address <- map["address"]
        averageRating <- map["averageRating"]
        deliverableCities <- map["deliverableCities"]
        descriptionField <- map["description"]
        descriptionAr <- map["descriptionAr"]
        descriptionEn <- map["descriptionEn"]
        image <- map["image"]
        location <- map["location"]
        storeName <- map["storeName"]
        storeNameAr <- map["storeNameAr"]
        storeNameEn <- map["storeNameEn"]
        domesticShipping <- map["domesticShipping"]
        internationalShipping <- map["internationalShipping"]
        canReviewUsers <- map["canReviewUsers"]
        availabilitySetting <- map["availabilitySetting"]
        city <- map["city"]
        locationSetting <- map["locationSetting"]
    }
    
}

//Todo:- common class
class Pagination : NSObject, Mappable{
    
    var next : Int?
    var page : Int?
    var pages : Int?
    var perPage : Int?
    var previous : Int?
    var total : Int?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Pagination()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        next <- map["next"]
        page <- map["page"]
        pages <- map["pages"]
        perPage <- map["perPage"]
        previous <- map["previous"]
        total <- map["total"]
        
    }
}
