//
//  RootOrderModel.swift
//  TailerOnline
//
//  Created by apple on 4/23/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderAPIResponse : NSObject, Mappable{
    
    var data : OrderData?
    var errors : Error?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return OrderAPIResponse()
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

class OrderData : NSObject, Mappable{
    
    var collection : [Order]?
    var pagination : Pagination?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return OrderData()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        collection <- map["collection"]
        pagination <- map["pagination"]
        
    }
    
}


class Order: NSObject, Mappable{
    
    var id : String?
    var createdAt : String?
    var deliveredOrderItemsCount : Int?
    var image : String?
    var images : [Image]?
    var orderItemsCount : Int?
    var orderNumber : String?
    var paymentMethod: String?
    var pendingOrderItemsCount : Int?
    var shippedOrderItemsCount : Int?
    var status : String?
    var total : Price?
   
    var priceables : [Priceable]?
    var product : Product?
    var quantity : Int?
    var totalWithShipping : Price?
    var orderNote: String?
    
    class func newInstance(map: Map) -> Mappable?{
        return Order()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        createdAt <- map["createdAt"]
        deliveredOrderItemsCount <- map["deliveredOrderItemsCount"]
        image <- map["image"]
        images <- map["images"]
        orderItemsCount <- map["orderItemsCount"]
        orderNumber <- map["orderNumber"]
        pendingOrderItemsCount <- map["pendingOrderItemsCount"]
        shippedOrderItemsCount <- map["shippedOrderItemsCount"]
        status <- map["status"]
        total <- map["total"]
        priceables <- map["priceables"]
        product <- map["product"]
        quantity <- map["quantity"]
        totalWithShipping <- map["totalWithShipping"]
        paymentMethod <- map["paymentMethod"]
        orderNote <- map["orderNote"]
    }
}









