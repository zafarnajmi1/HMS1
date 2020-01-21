//
//  ProductDetailAPIResponse.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/22/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation





class ProductDetailAPIResponse : BaseAPIResponse {
    
    let data : ProductDetail?
    

    enum CodingKeys: String, CodingKey {
        case data
    }
    required init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        data = try containter.decodeIfPresent(ProductDetail.self, forKey: .data)
        //        let superDecoder = try containter.superDecoder()
        try super.init(from: decoder)
    }


}


class ProductDetail : Codable {

    let id : String?
    let address : String?
    let available : Int?
    let averageRating : Double?
    let canReviewUsers : [CanReviewUser1]?
    let categories : [Category1]?
    let characteristics : [Characteristic1]?
    let city : String?
    let combinations : [Combination1]?
    let descriptionField : String?
    let descriptionAr : String?
    let descriptionEn : String?
    let favorites : [String]?
    let features : [Category1]?
    let image : String?
    let images : [Image1]?
    let isActive : Bool?
    let isAvailable : Bool?
    let isFeatured : Bool?
    let location : [Float]?
    let maxPrice : Int?
    let minPrice : Int?
    let notifyOnRestock : [String]?
    let price : Price1?
    let priceables : [Priceable1]?
    let productType : String?
    let reserved : Int?
    let sold : Int?
    let stock : Int?
    let store : Store1?
    let storeDeactivated : Bool?
    let title : String?
    let titleAr : String?
    let titleEn : String?
    let views : Int?
    let isOffer : Bool?
    let offer : Price1?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case address = "address"
        case available = "available"
        case averageRating = "averageRating"
        case canReviewUsers = "canReviewUsers"
        case categories = "categories"
        case characteristics = "characteristics"
        case city = "city"
        case combinations = "combinations"
        case descriptionField = "description"
        case descriptionAr = "descriptionAr"
        case descriptionEn = "descriptionEn"
        case favorites = "favorites"
        case features = "features"
        case image = "image"
        case images = "images"
        case isActive = "isActive"
        case isAvailable = "isAvailable"
        case isFeatured = "isFeatured"
        case location = "location"
        case maxPrice = "maxPrice"
        case minPrice = "minPrice"
        case notifyOnRestock = "notifyOnRestock"
        case price = "price"
        case priceables = "priceables"
        case productType = "productType"
        case reserved = "reserved"
        case sold = "sold"
        case stock = "stock"
        case store = "store"
        case storeDeactivated = "storeDeactivated"
        case title = "title"
        case titleAr = "titleAr"
        case titleEn = "titleEn"
        case views = "views"
        case isOffer = "isOffer"
        case offer = "offer"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        available = try values.decodeIfPresent(Int.self, forKey: .available)
        averageRating = try values.decodeIfPresent(Double.self, forKey: .averageRating)
        canReviewUsers = try values.decodeIfPresent([CanReviewUser1].self, forKey: .canReviewUsers)
        categories = try values.decodeIfPresent([Category1].self, forKey: .categories)
        characteristics = try values.decodeIfPresent([Characteristic1].self, forKey: .characteristics)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        combinations = try values.decodeIfPresent([Combination1].self, forKey: .combinations)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        descriptionAr = try values.decodeIfPresent(String.self, forKey: .descriptionAr)
        descriptionEn = try values.decodeIfPresent(String.self, forKey: .descriptionEn)
        favorites = try values.decodeIfPresent([String].self, forKey: .favorites)
        features = try values.decodeIfPresent([Category1].self, forKey: .features)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        images = try values.decodeIfPresent([Image1].self, forKey: .images)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        isAvailable = try values.decodeIfPresent(Bool.self, forKey: .isAvailable)
        isFeatured = try values.decodeIfPresent(Bool.self, forKey: .isFeatured)
        location = try values.decodeIfPresent([Float].self, forKey: .location)
        maxPrice = try values.decodeIfPresent(Int.self, forKey: .maxPrice)
        minPrice = try values.decodeIfPresent(Int.self, forKey: .minPrice)
        notifyOnRestock = try values.decodeIfPresent([String].self, forKey: .notifyOnRestock)
        price = try values.decodeIfPresent(Price1.self, forKey: .price)
        priceables = try values.decodeIfPresent([Priceable1].self, forKey: .priceables)
        productType = try values.decodeIfPresent(String.self, forKey: .productType)
        reserved = try values.decodeIfPresent(Int.self, forKey: .reserved)
        sold = try values.decodeIfPresent(Int.self, forKey: .sold)
        stock = try values.decodeIfPresent(Int.self, forKey: .stock)
        store = try values.decodeIfPresent(Store1.self, forKey: .store)
        storeDeactivated = try values.decodeIfPresent(Bool.self, forKey: .storeDeactivated)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        titleAr = try values.decodeIfPresent(String.self, forKey: .titleAr)
        titleEn = try values.decodeIfPresent(String.self, forKey: .titleEn)
        views = try values.decodeIfPresent(Int.self, forKey: .views)
        isOffer = try values.decodeIfPresent(Bool.self, forKey: .isOffer)
        offer = try values.decodeIfPresent(Price1.self, forKey: .offer)
    }


}


struct DeliverableCity1 : Codable {
    
    let id : String?
    let city : City1?
    let price : Price1?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case city
        case price
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        city = try values.decodeIfPresent(City1.self, forKey: .city)
        price = try values.decodeIfPresent(Price1.self, forKey: .price)
    }
    
    
}

struct City1 : Codable {
    
    let id : String?
    let title : String?
    let titleAr : String?
    let titleEn : String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title = "title"
        case titleAr = "titleAr"
        case titleEn = "titleEn"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        titleAr = try values.decodeIfPresent(String.self, forKey: .titleAr)
        titleEn = try values.decodeIfPresent(String.self, forKey: .titleEn)
    }
    
    
}



struct Store1 : Codable {

    let id : String?
    let address : String?
    let availabilitySetting : String?
    let city : City1?
    let deliverableCities : [DeliverableCity1]?
    let domesticShipping : Price1?
    let image : String?
    let internationalShipping : Price1?
    let locationSetting : Bool?
    let storeName : String?
    let storeNameAr : String?
    let storeNameEn : String?


    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case address = "address"
        case availabilitySetting = "availabilitySetting"
        case city
        case deliverableCities = "deliverableCities"
        case domesticShipping
        case image = "image"
        case internationalShipping
        case locationSetting = "locationSetting"
        case storeName = "storeName"
        case storeNameAr = "storeNameAr"
        case storeNameEn = "storeNameEn"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        availabilitySetting = try values.decodeIfPresent(String.self, forKey: .availabilitySetting)
        city = try values.decodeIfPresent(City1.self, forKey: .city)
        deliverableCities = try values.decodeIfPresent([DeliverableCity1].self, forKey: .deliverableCities)
        domesticShipping = try values.decodeIfPresent(Price1.self, forKey: .domesticShipping)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        internationalShipping = try values.decodeIfPresent(Price1.self, forKey: .internationalShipping)
        locationSetting = try values.decodeIfPresent(Bool.self, forKey: .locationSetting)
        storeName = try values.decodeIfPresent(String.self, forKey: .storeName)
        storeNameAr = try values.decodeIfPresent(String.self, forKey: .storeNameAr)
        storeNameEn = try values.decodeIfPresent(String.self, forKey: .storeNameEn)
    }

    
}


struct Priceable1 : Codable {

    let id : String?
    var characteristics : [Characteristic1]?
    let feature : Feature1?
    var selectedIndex: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case characteristics = "characteristics"
        case feature
    }
     init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        characteristics = try values.decodeIfPresent([Characteristic1].self, forKey: .characteristics)
        feature =  try values.decodeIfPresent(Feature1.self, forKey: .feature)
    }
    
    
}

struct Feature1 : Codable {

    let id : String?
    let howToShow : String?
    let sortOrder : Int?
    let title : String?
    let titleAr : String?
    let titleEn : String?


    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case howToShow = "howToShow"
        case sortOrder = "sortOrder"
        case title = "title"
        case titleAr = "titleAr"
        case titleEn = "titleEn"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        howToShow = try values.decodeIfPresent(String.self, forKey: .howToShow)
        sortOrder = try values.decodeIfPresent(Int.self, forKey: .sortOrder)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        titleAr = try values.decodeIfPresent(String.self, forKey: .titleAr)
        titleEn = try values.decodeIfPresent(String.self, forKey: .titleEn)
    }


}

struct Combination1 : Codable {

    let _id : String?
    let available : Int?
    let characteristics : [String]?
    let features : [String]?
    let image : String?
    let images : [Image1]?
    let price : Price1?
    let stock : Int?
    let offer : Price1?
    let isOffer: Bool?

    enum CodingKeys1: String, CodingKey {
        case _id = "_id"
        case available = "available"
        case characteristics = "characteristics"
        case features = "features"
        case image = "image"
        case images = "images"
        case price = "price"
        case stock = "stock"
        case isOffer = "isOffer"
        case offer = "offer"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        available = try values.decodeIfPresent(Int.self, forKey: .available)
        characteristics = try values.decodeIfPresent([String].self, forKey: .characteristics)
        features = try values.decodeIfPresent([String].self, forKey: .features)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        images = try values.decodeIfPresent([Image1].self, forKey: .images)
        price =  try values.decodeIfPresent(Price1.self, forKey: .price)
        stock = try values.decodeIfPresent(Int.self, forKey: .stock)
        offer =  try values.decodeIfPresent(Price1.self, forKey: .offer)
        isOffer = try values.decodeIfPresent(Bool.self, forKey: .isOffer)

    }


}


struct Currency1 : Codable {
    let amount : Double?
    let rate : Double?
    let symbol : String?
    let formattedAmount : String?
    var formattedText : String? {
        get {
            if let symbol = symbol, let formattedAmount = formattedAmount{
                return "\(symbol)\(formattedAmount)"
            }
            return nil
            
        }
    }
    
    enum CodingKeys: String, CodingKey {
        
        case amount = "amount"
        case rate = "rate"
        case symbol = "symbol"
        case formattedAmount = "formatedAmount"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        rate = try values.decodeIfPresent(Double.self, forKey: .rate)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        formattedAmount = try values.decodeIfPresent(String.self, forKey: .formattedAmount)
    }
    
}

struct Price1 : Codable {
    let aed : Currency1?
    let usd : Currency1?
    var showPrice : Currency1? {
        get {
            if myDefaultCurrency == .usd{
                return usd
            }
            else{
                return aed
            }
            
        }
    }
    
    enum CodingKeys: String, CodingKey {
        
        case aed = "aed"
        case usd = "usd"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aed = try values.decodeIfPresent(Currency1.self, forKey: .aed)
        usd = try values.decodeIfPresent(Currency1.self, forKey: .usd)
    }
    
}

struct Image1 : Codable {

    let id : String?
    let isDefault : Bool?
    let path : String?


    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case isDefault = "isDefault"
        case path = "path"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
        path = try values.decodeIfPresent(String.self, forKey: .path)
    }


}

struct Characteristic1 : Codable {
    
    var id : String?
    var feature : String?
    var title : String?
    var titleAr : String?
    var titleEn : String?
    var combinations : [[Characteristic1]]?
    var image : String?
    var selectedIndex: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case feature = "feature"
        case title = "title"
        case titleAr = "titleAr"
        case titleEn = "titleEn"
        case combinations = "combinations"
        case image = "image"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        feature = try values.decodeIfPresent(String.self, forKey: .feature)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        titleAr = try values.decodeIfPresent(String.self, forKey: .titleAr)
        titleEn = try values.decodeIfPresent(String.self, forKey: .titleEn)
        combinations = try values.decodeIfPresent([[Characteristic1]].self, forKey: .combinations)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }


}

struct Category1 : Codable {

    let id : String?
    let title : String?
    let titleAr : String?
    let titleEn : String?


    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title = "title"
        case titleAr = "titleAr"
        case titleEn = "titleEn"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        titleAr = try values.decodeIfPresent(String.self, forKey: .titleAr)
        titleEn = try values.decodeIfPresent(String.self, forKey: .titleEn)
    }


}


struct CanReviewUser1 : Codable {

    let id : String?
    let combination : String?
    let order : String?
    let orderDetail : String?
    let product : String?
    let store : String?
    let user : String?


    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case combination = "combination"
        case order = "order"
        case orderDetail = "orderDetail"
        case product = "product"
        case store = "store"
        case user = "user"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        combination = try values.decodeIfPresent(String.self, forKey: .combination)
        order = try values.decodeIfPresent(String.self, forKey: .order)
        orderDetail = try values.decodeIfPresent(String.self, forKey: .orderDetail)
        product = try values.decodeIfPresent(String.self, forKey: .product)
        store = try values.decodeIfPresent(String.self, forKey: .store)
        user = try values.decodeIfPresent(String.self, forKey: .user)
    }


}
