//
//  CartAPIResponse.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/17/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import ObjectMapper


class CartAPIResponse : NSObject, Mappable{
    
    var data : CartData?
    var errors : Error?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return CartAPIResponse()
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

class CartData : NSObject, Mappable{
    
    var cart : [Cart]?
    var pricesObject : PricesObject?
    var product: String?
    
    class func newInstance(map: Map) -> Mappable?{
        return CartData()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        cart <- map["cart"]
        pricesObject <- map["pricesObject"]
        product <- map["product"]
    }
    
}

class PricesObject : NSObject, Mappable{
    
    var shipping : Price?
    var subtotal : Price?
    var total : Price?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return PricesObject()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        shipping <- map["shipping"]
        subtotal <- map["subtotal"]
        total <- map["total"]
        
    }
    
}

class Cart : NSObject, Mappable{
    
    var id : String?
    var characteristics : [AnyObject]?
    var createdAt : String?
    var features : [AnyObject]?
    var image : String?
    var images : [Image]?
    var price : Price?
    var priceables : [Priceable]?
    var product : Product?
    var quantity : Int?
    var shipping : AnyObject?
    var shippingAmount : Price?
    var store : Store?
    var total : Price?
    var totalWithShipping : Price?
    var updatedAt : String?
    var user : String?
    var isOffer: Bool?
    var offer: Price?
    
    class func newInstance(map: Map) -> Mappable?{
        return Cart()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        characteristics <- map["characteristics"]
        createdAt <- map["createdAt"]
        features <- map["features"]
        image <- map["image"]
        images <- map["images"]
        price <- map["price"]
        priceables <- map["priceables"]
        product <- map["product"]
        quantity <- map["quantity"]
        shipping <- map["shipping"]
        shippingAmount <- map["shippingAmount"]
        store <- map["store"]
        total <- map["total"]
        totalWithShipping <- map["totalWithShipping"]
        updatedAt <- map["updatedAt"]
        user <- map["user"]
        isOffer <- map["isOffer"]
        offer <- map["offer"]
    }
    
}
