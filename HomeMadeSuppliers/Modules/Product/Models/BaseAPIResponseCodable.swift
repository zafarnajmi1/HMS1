//
//  BaseAPIResponseCodable.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/29/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

class BaseAPIResponse : Codable {
    let success : Bool?
    let message : String?
    //    let data : [Product]?
    let errors : [String:String]?
    
    private enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case message = "message"
        //        case data = "data"
        case errors = "errors"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        //        data = try values.decodeIfPresent([Product].self, forKey: .data)
        errors = try values.decodeIfPresent(Dictionary.self, forKey: .errors)
    }
    static func decode<T>(data : Data, modelType: T.Type) -> (T?,String?) where T : Decodable {
        do {
            let apiResponse = try JSONDecoder().decode(self, from: data)
            return (apiResponse as? T, nil)
            
        }
        catch {
            return (nil, "")
        }
        
        
    }
    static func decode<T>(dictionary : [String : Any],modelType: T.Type) -> (T?,String?) where T : Decodable {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return decode(data: jsonData, modelType: self) as! (T?, String?)
            
        }
        catch {
            return (nil, "")
        }
        
    }
    
    
}

