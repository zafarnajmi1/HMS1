//
//  ReviewsAPIResponse.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/25/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import ObjectMapper

class ReviewsAPIResponse : NSObject, Mappable{
    
    var data : ReviewCollection?
    var errors : Error?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ReviewsAPIResponse()
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

class ReviewCollection : NSObject, Mappable{
    
    var reviews : [Review]?
    var pagination : Pagination?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ReviewCollection()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        reviews <- map["collection"]
        pagination <- map["pagination"]
        
    }
    
}

class Review : NSObject, Mappable{
    
    var id : String?
    var comment : String?
    var createdAt : String?
    var product : Product?
    var rating : Double?
    var ratingStr: String {
        get {return "\(rating ?? 0.0)"}
    }
    var user : User?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Review()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["_id"]
        comment <- map["comment"]
        createdAt <- map["createdAt"]
        product <- map["product"]
        rating <- map["rating"]
        user <- map["user"]
        
    }
    
}
