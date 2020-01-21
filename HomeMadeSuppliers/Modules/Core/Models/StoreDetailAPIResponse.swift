//
//  StoreDetailAPIResponse.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/31/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import ObjectMapper


class StoreDetailAPIResponse : NSObject, Mappable{
    
    var store : Store?
    var errors : Error?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return StoreDetailAPIResponse()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        store <- map["data"]
        errors <- map["errors"]
        message <- map["message"]
        success <- map["success"]
        
    }
    
}


