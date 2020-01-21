//
//  API_List.swift
//  TailerOnline
//
//  Created by apple on 3/28/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation


//globle use in application
// example AppNetwork.current.baseURL

internal struct AppNetwork {
    
    //used in APIBaseManager
    
    private  struct domainType {
        static let dev =  "https://www.projects.mytechnology.ae/homemade-supplier"
        //static let staging = "http://www.homemadesupplier.ae"
        static let production = "http://www.homemadesuppliers.com"
    }
    
    
    private struct apiBaseURLType {
        
        static let dev =  "\(domainType.dev)/\(myDefaultLanguage.rawValue)/api/"
        static let production = "\(domainType.production)/\(myDefaultLanguage.rawValue)/api/"
        
       
    }
    
    private struct assetPathType {
        
        static let dev =   "\(domainType.dev)/assets/temp/"
        static let production = "\(domainType.production)/temp/"
    
    }
  
    private struct socketPathType {
        
        static let dev =   "/homemade-supplier/socket.io"
        static let production = "/socket.io"
        
    }

    internal struct current {
        static let baseURL = apiBaseURLType.production
        static let domain = domainType.production
        static let assetsTemp = assetPathType.production
        static let socketURL = domainType.production
        static let socketPath = socketPathType.production
    }
    
}


//exmaple
//AppNetwork.current.baseURL

extension String {
    
    func resizeImage(width: Int = 300, height: Int = 300) -> String? {
        let url = "\(AppNetwork.current.domain)/resize-image?source=\(self)&width=\(width)&height=\(height)"
        return url
    }
}





internal enum Response<RootModel, Error> {
    case sucess(RootModel)
    case failure(Error)
}

internal enum APIResponse<RootModel, Error> {
    case resultSuccess(RootModel)
    case resultFailure(RootModel)
    case failure(Error)
   
}


internal enum UploadResponse<progress,completion> {
    case progress(Double)
    case path(String)
}



