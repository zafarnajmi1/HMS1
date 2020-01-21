//
//  ProductFeatureAPIReasponse.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/28/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation


class ProductFeatureAPIReasponse : BaseAPIResponse {
    
    let data : [FeatureData]?
    
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    required init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        data = try containter.decodeIfPresent([FeatureData].self, forKey: .data)
        //        let superDecoder = try containter.superDecoder()
        try super.init(from: decoder)
    }
    
    
}



class FeatureData : Codable {
    
    var id : String?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    var characteristics : [Characteristic2]?
    var categories : [String]?
    var isSelected = false
   
    enum CodingKeys: String, CodingKey {
        case id = "_id"
      
        case title = "title"
        case titleAr = "titleAr"
        case titleEn = "titleEn"
        case characteristics = "characteristics"
        case categories = "categories"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        titleAr = try values.decodeIfPresent(String.self, forKey: .titleAr)
        titleEn = try values.decodeIfPresent(String.self, forKey: .titleEn)
       // characteristics = try values.decodeIfPresent([Characteristic].self, forKey: .characteristics)
        characteristics = try values.decodeIfPresent([Characteristic2].self, forKey: .characteristics)
        categories = try values.decodeIfPresent([String].self, forKey: .categories)
    }
    init() {
        
    }
    func cloneItem() -> FeatureData{
        let copy = FeatureData()
        copy.id  = id
        copy.title  = title
        copy.titleAr  = titleAr
        copy.titleEn = titleEn
//        copy.characteristics : [Characteristic2]?
        copy.categories = categories
        copy.isSelected = isSelected
        copy.characteristics = [Characteristic2]()
        for item in characteristics ?? []{
            copy.characteristics?.append(item.cloneItem())
        }
        return copy
    }
    
    
}

//extension FeatureData : NSCopying{
//    func copy(with zone: NSZone? = nil) -> Any {
//        let copy = FeatureData()
//        copy.id = self.id
//        copy.characteristics = self.characteristics!.copy
//        return copy
//    }
//
//
//}


class Characteristic2 : Codable {
//    func copy(with zone: NSZone? = nil) -> Any {
//        let copy = Characteristic2()
//        return copy
//    }
    
    
    var id : String?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    var image : String?
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case title = "title"
        case titleAr = "titleAr"
        case titleEn = "titleEn"
        case image = "image"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        titleAr = try values.decodeIfPresent(String.self, forKey: .titleAr)
        titleEn = try values.decodeIfPresent(String.self, forKey: .titleEn)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }
    init() {
        
    }
    
    func cloneItem() -> Characteristic2{
        let copy = Characteristic2()
        copy.id = id
        copy.title = title
        copy.titleAr = titleAr
        copy.titleEn = titleEn
        copy.image = image
        copy.isSelected = isSelected
        return copy
    }
}



struct FeatureData2 : Codable {
    
    let id : String?
    let title : String?
    let titleAr : String?
    let titleEn : String?
    let characteristics : [Characteristic1]?
    let categories : [String]?
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case title = "title"
        case titleAr = "titleAr"
        case titleEn = "titleEn"
        case characteristics = "characteristics"
        case categories = "categories"
    }
     init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        titleAr = try values.decodeIfPresent(String.self, forKey: .titleAr)
        titleEn = try values.decodeIfPresent(String.self, forKey: .titleEn)
        // characteristics = try values.decodeIfPresent([Characteristic].self, forKey: .characteristics)
        characteristics = try values.decodeIfPresent([Characteristic1].self, forKey: .characteristics)
        categories = try values.decodeIfPresent([String].self, forKey: .categories)
    }
    
    
}
protocol Copying {
    init(original: Self)
}

extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}
extension Array where Element: Copying {
    func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        return copiedArray
    }
}
