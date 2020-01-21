//
//  CartManager.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/20/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import Alamofire

class CartManager: APIBaseManager {
    static let shared = CartManager()
    
    
    func addProductToCart(params:[String: Any],
                          completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
        
        
        let path = basePath + cart.authCartAddProduct
        
        
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
    
    
    func fetchCartList(completion: @escaping (Response<CartAPIResponse,String>) -> Void) {
        
        
        let path = basePath + cart.authCart
        
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .get,
                                             parameters: nil ,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<CartAPIResponse>) in
            //----------Console Dubug-----------------//
            print("ws url: \(path)")
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
    
    func removeProduct(params: [String: Any],
                               completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
        
        
        let path = basePath + cart.authCartProductRemove
        
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
    
    func updateQuantity(params: [String: Any],
                    completion: @escaping (Response<ProductAPIResponse,String>) -> Void) {
        
        
        let path = basePath + cart.authCartUpdate
        
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
