//
//  SettingManager.swift
//  TailerOnline
//
//  Created by apple on 4/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class SettingManger: APIBaseManager {
    
    static let shared = SettingManger()
    
    func fetchSettings(completion: @escaping (Response<SettingAPIResponse,String>) -> Void) {
        
        let path = basePath + front.settings
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .get,
                                             parameters: nil,
                                             encoding: JSONEncoding.default,
                                             headers: nil )
        
        request.responseObject { (response : DataResponse<SettingAPIResponse>) in
            
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
    
    
    func fetchSettingPage(queryItems:[URLQueryItem]?,  completion: @escaping (Response<SettingPageAPIResponse,String>) -> Void) {
      
        
        let  basePathURL = URL(string: basePath + front.page)!
        var completePath = "\(basePathURL)"
        if let queryItems = queryItems {
            let completeURL =  basePathURL.appending(queryItems)!
            completePath =  "\(completeURL)"
        }
        
        
       
        // make calls with the session manager
        let request = sessionManager.request(completePath,
                                             method: .get,
                                             parameters: nil,
                                             encoding: JSONEncoding.default,
                                             headers: nil )
        
        request.responseObject { (response : DataResponse<SettingPageAPIResponse>) in
            
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
    
    func contactUs(params:[String: Any], completion:@escaping (Response<UserLoginAPIResponse, String>) -> Void){
        
        let path = basePath + front.contactus
        // make calls with the session manager
        let request = sessionManager.request(path,
                                             method: .post,
                                             parameters: params,
                                             encoding: JSONEncoding.default,
                                             headers: nil )
        
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
