//
//  RootOrderDetailModel.swift
//  TailerOnline
//
//  Created by apple on 5/2/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import ObjectMapper


class OrderDetailAPIResponse : NSObject, Mappable{
    
    var data : OrderDetailData?
    var errors : Error?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return OrderDetailAPIResponse()
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


class OrderDetailData : NSObject, Mappable{
    
    var id : String?
    var createdAt : String?
    var deliveredOrderItemsCount : Int?
    var orderDetails : [OrderDetail]?
    var orderItemsCount : Int?
    var orderNumber : String?
  
    var pendingOrderItemsCount : Int?
    var shippedOrderItemsCount : Int?
    var status : String?
    var total : Price?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return OrderDetailData()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        createdAt <- map["createdAt"]
        deliveredOrderItemsCount <- map["deliveredOrderItemsCount"]
        orderDetails <- map["orderDetails"]
        orderItemsCount <- map["orderItemsCount"]
        orderNumber <- map["orderNumber"]
      
        pendingOrderItemsCount <- map["pendingOrderItemsCount"]
        shippedOrderItemsCount <- map["shippedOrderItemsCount"]
        status <- map["status"]
        total <- map["total"]
        
    }
    
}


class OrderDetail : NSObject, Mappable{
    
    var id : String?
    var createdAt : String?
    var image : String?
    var images : [Image]?
    var order : Order?
    var price : Price?
    var priceables : [Priceable]?
    var product : Product?
    var quantity : Int?
    var shipping : String?
    var shippingAmount : Int?
    var status : String?
    var store : Store?
    var total : Int?
    var totalWithShipping : Price?
    var updatedAt : String?
    var user : User?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return OrderDetail()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        createdAt <- map["createdAt"]
        image <- map["image"]
        images <- map["images"]
        order <- map["order"]
        price <- map["price"]
        priceables <- map["priceables"]
        product <- map["product"]
        quantity <- map["quantity"]
        shipping <- map["shipping"]
        shippingAmount <- map["shippingAmount"]
        status <- map["status"]
        store <- map["store"]
        total <- map["total"]
        totalWithShipping <- map["totalWithShipping"]
        updatedAt <- map["updatedAt"]
        user <- map["user"]
       
        
    }
    
}


class StoreOrderDetailAPIResponse : NSObject, Mappable{
    
    var data : OrderDetail?
    var errors : Error?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return StoreOrderDetailAPIResponse()
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
