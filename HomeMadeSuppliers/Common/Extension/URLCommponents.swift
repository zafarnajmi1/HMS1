//
//  URLCommponents.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/12/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation


//"Query Params Example- by nvd"

extension URL {
    /// Returns a new URL by adding the query items, or nil if the URL doesn't support it.
    /// URL must conform to RFC 3986.
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            // URL is not conforming to RFC 3986 (maybe it is only conforming to RFC 1808, RFC 1738, and RFC 2732)
            return nil
        }
        // append the query items to the existing ones
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        
        // return the url from new url components
        return urlComponents.url
    }
}

//let baseURL = URL(string: "https://example.com/")!
//let queryItems = [URLQueryItem(name: "page", value: nil),
//                  URLQueryItem(name: "keyword", value: "emglish tarzan"),
//                  URLQueryItem(name: "id", value: "33")]
//let completeURL = baseURL.appending(queryItems)!
//let completeURLString = "\(completeURL)"
//print(completeURLString)
////https://example.com/?page&keyword=emglish%20tarzan&id=33
