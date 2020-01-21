//
//  ProductAPIResponse.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/31/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import ObjectMapper


class ProductAPIResponse : NSObject, Mappable{
    
    var data : ProductData?
    var errors : Error?
    var message : String?
    var success : Bool?
    var product: Product?
    
    class func newInstance(map: Map) -> Mappable?{
        return ProductAPIResponse()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        data <- map["data"]
        errors <- map["errors"]
        message <- map["message"]
        success <- map["success"]
        product <- map["data"]
    }
    
}



class ProductData : NSObject,  Mappable{
    
    var collection : [Product]?
    var pagination : Pagination?
    var totalWithShipping : Price?
    var productsOutOfStock: Int?
    class func newInstance(map: Map) -> Mappable?{
        return ProductData()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        collection <- map["collection"]
        pagination <- map["pagination"]
        totalWithShipping <- map["totalWithShipping"]
        productsOutOfStock <- map["productsOutOfStock"]
    }
}

class Product : NSObject,  Mappable{
    
    var id : String?
    var address : String?
    var available : Int?
    var averageRating : Double?
    var canReviewUsers : [CanReviewUser]?
    var categories : [Category]?
    var characteristics : [Characteristic]?
    var city : String?
    var combinations : [Combination]?
    var descriptionField : String?
    var descriptionAr : String?
    var descriptionEn : String?
    var favorites : [String]?
    var features : [FeatureProduct]?
    var image : String?
    var images : [Image]?
    var isActive : Bool?
    var isAvailable : Bool?
    var isFeatured : Bool?
    var location : [Float]?
    var maxPrice : Int?
    var minPrice : Int?
    var notifyOnRestock : [String]?
    var price : Price?
    var priceables : [Priceable]?
    var productType : String?
    var reserved : Int?
    var sold : Int?
    var stock : Int?
    var store : Store?
    var storeDeactivated : Bool?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    var views : Int?
    var isOffer: Bool?
    var offer: Price?
    var approvalPending: Bool?
    

    
    class func newInstance(map: Map) -> Mappable?{
        return Product()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        address <- map["address"]
        available <- map["available"]
        averageRating <- map["averageRating"]
        canReviewUsers <- map["canReviewUsers"]
        categories <- map["categories"]
        characteristics <- map["characteristics"]
        city <- map["city"]
        combinations <- map["combinations"]
       
        descriptionField <- map["description"]
        descriptionAr <- map["descriptionAr"]
        descriptionEn <- map["descriptionEn"]
     
        features <- map["features"]
        image <- map["image"]
        images <- map["images"]
        isActive <- map["isActive"]
        isAvailable <- map["isAvailable"]
        isFeatured <- map["isFeatured"]
        location <- map["location"]
        maxPrice <- map["maxPrice"]
        minPrice <- map["minPrice"]
       
        price <- map["price"]
        priceables <- map["priceables"]
        productType <- map["productType"]
    
        reserved <- map["reserved"]
      
        sold <- map["sold"]
        stock <- map["stock"]
        store <- map["store"]
        storeDeactivated <- map["storeDeactivated"]
        title <- map["title"]
        titleAr <- map["titleAr"]
        titleEn <- map["titleEn"]
        
        views <- map["views"]
        favorites <- map["favorites"]
        notifyOnRestock <- map["notifyOnRestock"]
        isOffer <- map["isOffer"]
        offer <- map["offer"]
        approvalPending <- map["approvalPending"]
    }
    
}

class FeatureProduct: NSObject, Mappable {
    
    var id : String?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    
    class func newInstance(map: Map) -> Mappable?{
        return FeatureProduct()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        title <- map["title"]
        titleAr <- map["titleAr"]
        titleEn <- map["titleEn"]
        
    }
}



class CombinationCharacteristic: NSObject, Mappable {
    
    var id : String?
    var feature : String?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    
    class func newInstance(map: Map) -> Mappable?{
        return CombinationCharacteristic()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        feature <- map["feature"]
        title <- map["title"]
        titleAr <- map["titleAr"]
        titleEn <- map["titleEn"]
        
    }
}



class Combination : NSObject, Mappable{
   
    var id : String?
    var available : Int?
    var characteristics : [String]?
    var features : [String]?
    var image : String?
    var images : [Image]?
    var price : Price?
    var stock : Int?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Combination()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        available <- map["available"]
        characteristics <- map["characteristics"]
        features <- map["features"]
        image <- map["image"]
        images <- map["images"]
        price <- map["price"]
        stock <- map["stock"]
        
    }


}

class Priceable : NSObject, Mappable{
    
    
    var id : String?
    var characteristic : Characteristic?
    var characteristics : [Characteristic]?
    var feature : Feature? 
    var selectedIndex : Int?
   
    class func newInstance(map: Map) -> Mappable?{
        return Priceable()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        characteristics <- map["characteristics"]
        feature <- map["feature"]
        characteristic <- map["characteristic"]
    }

}

class Feature : NSObject, Mappable{
    
    var id : String?
    var howToShow : String?
    var sortOrder : Int?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Feature()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        howToShow <- map["howToShow"]
        sortOrder <- map["sortOrder"]
        title <- map["title"]
        titleAr <- map["titleAr"]
        titleEn <- map["titleEn"]
        
    }

    
}

class Characteristic : NSObject, Mappable{
    
    var id : String?
    var feature : String?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    var combinations : [[CombinationCharacteristic]]?
    var image : String?
    var isSelected = false
    
    class func newInstance(map: Map) -> Mappable?{
        return Characteristic()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        feature <- map["feature"]
        title <- map["title"]
        titleAr <- map["titleAr"]
        titleEn <- map["titleEn"]
        combinations <- map["combinations"]
        image <- map["image"]
        
    }

    
}


class Image : NSObject, Mappable{
    
    var id : String?
    var isDefault : Bool?
    var path : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Image()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        isDefault <- map["isDefault"]
        path <- map["path"]
        
    }
}


class CanReviewUser : NSObject, Mappable{
    
    var id : String?
    var order : String?
    var orderDetail : String?
    var product : String?
    var store : String?
    var user : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return CanReviewUser()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        order <- map["order"]
        orderDetail <- map["orderDetail"]
        product <- map["product"]
        store <- map["store"]
        user <- map["user"]
        
    }
    
}
