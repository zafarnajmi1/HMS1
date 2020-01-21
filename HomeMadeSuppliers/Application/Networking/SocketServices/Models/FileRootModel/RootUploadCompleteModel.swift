//
//  RootUploadCompleteModel.swift
//  TailerOnline
//
//  Created by apple on 4/18/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//
import ObjectMapper

class RootUploadCompleteModel: NSObject, Mappable{
    
    var data : UploadCompleteDataModel?
    var errors : Error?
    var message : String?
    var success : Bool?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return RootUploadCompleteModel()
    }
    required init?(map: Map){}
    override init(){}
    
    func mapping(map: Map)
    {
        data <- map["data"]
        errors <- map["errors"]
        message <- map["message"]
        success <- map["success"]
        
    }
    
}


class UploadCompleteDataModel: NSObject, Mappable{

    var fileName : String?
    var pointer : String?
    var progress : Double?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return UploadCompleteDataModel()
    }
    required init?(map: Map){}
    override init(){}
    
    func mapping(map: Map)
    {
        fileName <- map["fileName"]
        pointer <- map["pointer"]
        progress <- map["progress"]
       
        
    }
    
}
