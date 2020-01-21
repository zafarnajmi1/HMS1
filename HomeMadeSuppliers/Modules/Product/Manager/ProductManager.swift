//
//  ProductManager.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/14/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import Alamofire


class ProductManager: APIBaseManager {
    static let shared = ProductManager()
    
    
    
    func fetchManageProductList(queryItems: [URLQueryItem]?, defaultSort: Bool = true ,
                             completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
           
           
            
           
          let  basePathURL = URL(string: basePath + front.authProduct)!
           var completePath = "\(basePathURL)"
           if let queryItems = queryItems {
             let completeURL =  basePathURL.appending(queryItems)!
             completePath =  "\(completeURL)"
           }
           
          
          
        
        
          
           // make calls with the session manager
           let request = sessionManager.request(completePath,
                                                method: .get,
                                                parameters: nil ,
                                                encoding: JSONEncoding.default,
                                                headers: authHeader() )
           
           request.responseObject { (response : DataResponse<ProductAPIResponse>) in
               //----------Console Dubug-----------------//
               print("ws url: \(completePath)")
               print("ws Error: \(String(describing: response.error))")
               print("ws Response: \(String(describing: response.response))")
               if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                   print("ws Data: \(utf8Text)")
               }
               //----------Console Dubug-----------------//
               
               switch response.result {
               case .success(_):
                   
                   let object = response.result.value
                   
                   if (object?.success)! {
                       completion(.sucess(object!))
                   }
                   else {
                       let error = object?.message
                       completion(.failure(error!))
                   }
                   
                   
               case .failure(let error):
                   let error = error.localizedDescription
                   if error.contains(AppConstant.error.objectMapper) {
                       completion(.failure(AppConstant.error.serverIssue))
                   }
                   else {
                       completion(.failure(error))
                   }
               }
               
               
           }
       }
    
    
    
    func fetchProductList(params: [String: Any], defaultSort: Bool = true ,
                          completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.productSearch
        
        var dic = params
        if defaultSort == true {
              dic.updateValue("latest", forKey: "sortOrder")
        }
      
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: dic ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<ProductAPIResponse>) in
            //----------Console Dubug-----------------//
            print("ws url: \(path)")
            print("ws params: \(params.printRecords())")
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            //----------Console Dubug-----------------//
            
            switch response.result {
            case .success(_):
                
                let object = response.result.value
                
                if (object?.success)! {
                    completion(.sucess(object!))
                }
                else {
                    let error = object?.message
                    completion(.failure(error!))
                }
                
                
            case .failure(let error):
                let error = error.localizedDescription
                if error.contains(AppConstant.error.objectMapper) {
                    completion(.failure(AppConstant.error.serverIssue))
                }
                else {
                    completion(.failure(error))
                }
            }
            
            
        }
    }
    
   
    
    func deleteProductBy(productId: String,
                       completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.authProductDelete
      
          let params: [String: Any] = ["_id": productId]
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<ProductAPIResponse>) in
            //----------Console Dubug-----------------//
            print("ws url: \(path)")
            print("ws params: \(params.printRecords())")
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            //----------Console Dubug-----------------//
            
            switch response.result {
            case .success(_):
                
                let object = response.result.value
                
                if (object?.success)! {
                    completion(.sucess(object!))
                }
                else {
                    let error = object?.message
                    completion(.failure(error!))
                }
                
                
            case .failure(let error):
                let error = error.localizedDescription
                if error.contains(AppConstant.error.objectMapper) {
                    completion(.failure(AppConstant.error.serverIssue))
                }
                else {
                    completion(.failure(error))
                }
            }
            
            
        }
    }
    
    func favoriteToggleProduct(id: String,
                          completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.authProductFavorite
        let params:[String: Any] = ["_id": id]
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<ProductAPIResponse>) in
            //----------Console Dubug-----------------//
            print("ws url: \(path)")
            print("ws params: \(params.printRecords())")
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            //----------Console Dubug-----------------//
            
            switch response.result {
            case .success(_):
                
                let object = response.result.value
                
                if (object?.success)! {
                    completion(.sucess(object!))
                }
                else {
                    let error = object?.message
                    completion(.failure(error!))
                }
                
                
            case .failure(let error):
                let error = error.localizedDescription
                if error.contains(AppConstant.error.objectMapper) {
                    completion(.failure(AppConstant.error.serverIssue))
                }
                else {
                    completion(.failure(error))
                }
            }
            
            
        }
    }
    
    func notifyOnRestockProduct(id: String,
                               completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.authProductNotifyOnRestock
        let params:[String: Any] = ["_id": id]
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<ProductAPIResponse>) in
            //----------Console Dubug-----------------//
            print("ws url: \(path)")
            print("ws params: \(params.printRecords())")
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            //----------Console Dubug-----------------//
            
            switch response.result {
            case .success(_):
                
                let object = response.result.value
                
                if (object?.success)! {
                    completion(.sucess(object!))
                }
                else {
                    let error = object?.message
                    completion(.failure(error!))
                }
                
                
            case .failure(let error):
                let error = error.localizedDescription
                if error.contains(AppConstant.error.objectMapper) {
                    completion(.failure(AppConstant.error.serverIssue))
                }
                else {
                    completion(.failure(error))
                }
            }
            
            
        }
    }
    
    func submitReview(params: [String: Any],
                               completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.authProductSubmitReview
      
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<ProductAPIResponse>) in
            //----------Console Dubug-----------------//
            print("ws url: \(path)")
            print("ws params: \(params.printRecords())")
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            //----------Console Dubug-----------------//
            
            switch response.result {
            case .success(_):
                
                let object = response.result.value
                
                if (object?.success)! {
                    completion(.sucess(object!))
                }
                else {
                    let error = object?.message
                    completion(.failure(error!))
                }
                
                
            case .failure(let error):
                let error = error.localizedDescription
                if error.contains(AppConstant.error.objectMapper) {
                    completion(.failure(AppConstant.error.serverIssue))
                }
                else {
                    completion(.failure(error))
                }
            }
            
            
        }
    }

    func productDetail(id: String,
                      completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.authProductDetail
        let params:[String: Any] = ["_id": id]
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<ProductAPIResponse>) in
            //----------Console Dubug-----------------//
            print("ws url: \(path)")
            print("ws params: \(params.printRecords())")
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            //----------Console Dubug-----------------//
            
            switch response.result {
            case .success(_):
                
                let object = response.result.value
                
                if (object?.success)! {
                    completion(.sucess(object!))
                }
                else {
                    let error = object?.message
                    completion(.failure(error!))
                }
                
                
            case .failure(let error):
                let error = error.localizedDescription
                if error.contains(AppConstant.error.objectMapper) {
                    completion(.failure(AppConstant.error.serverIssue))
                }
                else {
                    completion(.failure(error))
                }
            }
            
            
        }
    }
    
    
    func productReviews(params: [String: Any],
                      completion: @escaping (Response<ReviewsAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.authProductReviews
        
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<ReviewsAPIResponse>) in
            //----------Console Dubug-----------------//
            print("ws url: \(path)")
            print("ws params: \(params.printRecords())")
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            //----------Console Dubug-----------------//
            
            switch response.result {
            case .success(_):
                
                let object = response.result.value
                
                if (object?.success)! {
                    completion(.sucess(object!))
                }
                else {
                    let error = object?.message
                    completion(.failure(error!))
                }
                
                
            case .failure(let error):
                let error = error.localizedDescription
                if error.contains(AppConstant.error.objectMapper) {
                    completion(.failure(AppConstant.error.serverIssue))
                }
                else {
                    completion(.failure(error))
                }
            }
            
            
        }
    }

    
    
    
    
    func productDetail(productID : String, completionHandler: @escaping (Response<ProductDetailAPIResponse,String>) -> Void){
        let params = ["_id": productID]
        
        
        print("Parameters :\(params)")
        let path = basePath + front.authProductDetail
        
        print("Fetch Products Details:\(path)")
        
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader())
        
        request.response { (response ) in
            
            #if DEBUG
            print("Fetch ProductDetail Error: \(String(describing: response.error))")
            print("Fetch ProductDetail Response : \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Fetch ProductDetail Data: \(utf8Text)")
            }
            #endif
            
            
           
            
            
            if let error = checkError(Response: response){
                completionHandler (.failure(error))
                return
            }
          
            do {
                let apiResponse = try JSONDecoder().decode(ProductDetailAPIResponse.self, from: response.data!)
                if apiResponse.success ?? false {
                    completionHandler (.sucess(apiResponse))
                 }
                else {
                    completionHandler (.failure(apiResponse.message ?? "Unkow Error"))
                }
               
            }
            catch let error {
                
                print("Fetch ProductDetail Failed :\(error)")
                let error = "Something went wrong, please try again later".localized
                completionHandler (.failure(error))
            }
            
         }
        
    }
    
    
    
    func fetchProductFeatureCharacteristics(completion: @escaping (Response<ProductFeatureAPIReasponse,String>) -> Void) {
        
        
        let path = basePath + front.featuresCharacteristics
        print("Fetch Products Details:\(path)")
        
        let request = sessionManager.request(path,
                                             method: .get,
                                             parameters: nil ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader())
        
        request.response { (response ) in
            
            #if DEBUG
            print("Fetch ProductDetail Error: \(String(describing: response.error))")
            print("Fetch ProductDetail Response : \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Fetch ProductDetail Data: \(utf8Text)")
            }
            #endif
            
            
            
            
            
            if let error = checkError(Response: response){
                completion (.failure(error))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(ProductFeatureAPIReasponse.self, from: response.data!)
                if apiResponse.success ?? false {
                    completion (.sucess(apiResponse))
                }
                else {
                    completion (.failure(apiResponse.message ?? "Unkow Error"))
                }
                
            }
            catch let error {
                
                print("Fetch ProductDetail Failed :\(error)")
                let error = "Something went wrong, please try again later".localized
                completion (.failure(error))
            }
            
        }
        
    }
    
    
    func addProduct(params: [String: Any] ,completion: @escaping (Response<BaseAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.authProductStore
        print("Fetch Products Details:\(path)")
        
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader())
        
        request.response { (response ) in
            
            #if DEBUG
            print("Fetch ProductDetail Error: \(String(describing: response.error))")
            print("Fetch ProductDetail Response : \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Fetch ProductDetail Data: \(utf8Text)")
            }
            #endif
            
            
            
            
            
            if let error = checkError(Response: response){
                completion (.failure(error))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(BaseAPIResponse.self, from: response.data!)
                if apiResponse.success ?? false {
                    completion (.sucess(apiResponse))
                }
                else {
                    completion (.failure(apiResponse.message ?? "Unkow Error"))
                }
                
            }
            catch let error {
                
                print("Fetch ProductDetail Failed :\(error)")
                let error = "Something went wrong, please try again later".localized
                completion (.failure(error))
            }
            
        }
        
    }
    
    func updateProduct(params: [String: Any] ,completion: @escaping (Response<BaseAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.authProductUpdate
        print("Fetch Products Details:\(path)")
        
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader())
        
        request.response { (response ) in
            
            #if DEBUG
            print("Fetch ProductDetail Error: \(String(describing: response.error))")
            print("Fetch ProductDetail Response : \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Fetch ProductDetail Data: \(utf8Text)")
            }
            #endif
            
            
            
            
            
            if let error = checkError(Response: response){
                completion (.failure(error))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(BaseAPIResponse.self, from: response.data!)
                if apiResponse.success ?? false {
                    completion (.sucess(apiResponse))
                }
                else {
                    completion (.failure(apiResponse.message ?? "Unkow Error"))
                }
                
            }
            catch let error {
                
                print("Fetch ProductDetail Failed :\(error)")
                let error = "Something went wrong, please try again later".localized
                completion (.failure(error))
            }
            
        }
        
    }
    
  
}

public func checkError(Response: DefaultDataResponse) -> String?
{
    
    if Response.error != nil {
        
        return Response.error?.localizedDescription
   
    }
    else{
        return nil
    }
    
    
}
