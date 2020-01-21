//
//  AddProductModel.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/29/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation

class AddProductParmeters : Codable {
    var locale : String {
        get {
            return myDefaultLanguage.rawValue
        }
    }
    var titleEn : String?
    var titleAr : String?
    var descriptionEn : String?
    var descriptionAr : String?

    var category : String?
    var subcategory : String?
    var categories : [String]?
    
    var price : String?
    var isStockProduct : Bool?
    var productType: String?
    var isAvailable: String?
    var available: String?
    var isOffer: Bool?
    var offer: String?
    
    
   // var priceables : [AddFeatureRequest]?//[String: Any]?//[AddFeatureRequest]?
   // var images : [AddImageRequest]?//[String: Any]?//[AddImageRequest]?
  
    var selectedCategoryTitle: String?
    var selectedSubcategoryTitle: String?
}


class FeatureParemters  {
    var feature : FeatureData?
    var selectedCharacteristic: Characteristic2?
    var isSelected = false
    
    
}

extension FeatureParemters: Equatable {
    static func == (lhs: FeatureParemters, rhs: FeatureParemters) -> Bool {
        return
            lhs.feature?.id == rhs.feature?.id &&
                lhs.selectedCharacteristic?.id == rhs.selectedCharacteristic?.id
    }
}

//extension Characteristic2 {
//    static func == (lhs: Characteristic2, rhs: Characteristic2) -> Bool {
//        return  lhs.id == rhs.id
//    }
//}

extension FeatureData {
    static func == (lhs: FeatureData, rhs: FeatureData) -> Bool {
        return lhs.id == rhs.id
    }
}




// for config product
class Configuration {

    var combination = CombinationParameters()
    var isSelected = false
}

class ConfigProductParameters {
    
    var titleEn : String?
    var titleAr : String?
    var descriptionEn : String?
    var descriptionAr : String?
    
    var category : String?
    var subcategory : String?
    var categories : [String]?
    
    var productType: String?
    var selectedCategoryFeatures: [FeatureData]?
    var combinationList: [CombinationParameters]?
    
    var selectedCategoryTitle: String?
    var selectedSubcategoryTitle: String?
}



class CombinationParameters  {
    var index: Int?
    var price : String?
    var available: String?
    var features = [FeatureData]()
    var images = [ImageCollection]()
    var isOffer = false
    var offer: String?
   
}


class ImageCollection: Codable {
    var filePath: String?
    var image: UIImage?
    var isDefault: Bool?
    var id: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case isDefault = "isDefault"
        case filePath = "filePath"
     
      
    }
    init() {}
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        filePath = try values.decodeIfPresent(String.self, forKey: .filePath)
        isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
        
    }

}
