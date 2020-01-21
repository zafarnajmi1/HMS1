//
//  StoreManager.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/30/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireObjectMapper

class StoreManager: APIBaseManager {
    
    static let shared = StoreManager()
    
    func fetchStoreList(queryItems: [URLQueryItem]?,
                        completion: @escaping (Response<StoreAPIResponse,String>) -> Void) {
       
        let  basePathURL = URL(string: basePath + front.stores)!
        var completePath = "\(basePathURL)"
        if let queryItems = queryItems {
          let completeURL =  basePathURL.appending(queryItems)!
          completePath =  "\(completeURL)"
        }
        
       
        print(completePath)
        
        // make calls with the session manager
        let request = sessionManager.request(completePath,
                                             method: .get,
                                             parameters: nil ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<StoreAPIResponse>) in
            
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            
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
    
    func fetchStoreDetailBy(id: String,
                        completion: @escaping (Response<StoreDetailAPIResponse,String>) -> Void) {
        
        let params: Parameters = ["_id": id]
        let path = basePath + front.storeDetail
       
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<StoreDetailAPIResponse>) in
            
            print("ws Error: \(String(describing: response.error))")
            print("ws Response: \(String(describing: response.response))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("ws Data: \(utf8Text)")
            }
            
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
    
    func storeReviews(params: [String: Any],
                        completion: @escaping (Response<ReviewsAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.authStoreReviews
        
        
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

    
    func submitReview(params: [String: Any],
                      completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
        
        
        let path = basePath + front.authStoreSubmitReview
        
        
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
}



extension Dictionary {
    
    func printRecords() {
        
        for (name, path) in self {
            print("\(name)=\(path)")
        }
        
    }
}
