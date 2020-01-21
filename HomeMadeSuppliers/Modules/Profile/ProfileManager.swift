//
//  ProfileManager.swift
//  TailerOnline
//
//  Created by apple on 4/2/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper


class ProfileManager: APIBaseManager{

    static let shared = ProfileManager()
    private override init() {}
    
    func changePassword(params: [String:Any], completion:@escaping (Response<UserLoginAPIResponse,String>) -> Void) {
        
        let path = basePath + profile.authChangePassword
        
        
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<UserLoginAPIResponse>) in
            
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
    
    
    func getProfile(completion:@escaping (Response<UserLoginAPIResponse,String>) -> Void) {
        
        let path = basePath + profile.authProfile
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .get,
                                             parameters: nil,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<UserLoginAPIResponse>) in
            
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
    
    
    func editProfile(params:[String:Any] ,completion:@escaping (Response<UserLoginAPIResponse,String>) -> Void) {
        
        let path = basePath + profile.authUpdateProfile
    
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<UserLoginAPIResponse>) in
            
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
                }            }
            
        }
    }
    
    func removeDeliverableCity(params:[String:Any] ,completion:@escaping (Response<UserLoginAPIResponse,String>) -> Void) {
        
        let path = basePath + profile.authRemoveDeveliverable
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<UserLoginAPIResponse>) in
            
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
                }            }
            
        }
    }
    
    func updateStoreDeveliverables(params:[String:Any] ,completion:@escaping (Response<UserLoginAPIResponse,String>) -> Void) {
        
        let path = basePath + profile.authStoreDeveliverables
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<UserLoginAPIResponse>) in
            
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
                }            }
            
        }
    }
    
    
    func updateProfileSettings(params:[String:Any] ,completion:@escaping (Response<UserLoginAPIResponse,String>) -> Void) {
        
        let path = basePath + profile.authUpdateProfileSettings
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<UserLoginAPIResponse>) in
            
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
                }            }
            
        }
    }
    
    
    
    func updateStorePaypalCredentials(params:[String:Any] ,completion:@escaping (Response<UserLoginAPIResponse,String>) -> Void) {
        
        let path = basePath + profile.authUpdateStorePaypalCredentials
        
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params,
                                             encoding: JSONEncoding.default,
                                             headers: authHeader() )
        
        request.responseObject { (response : DataResponse<UserLoginAPIResponse>) in
            
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
    
   
}
