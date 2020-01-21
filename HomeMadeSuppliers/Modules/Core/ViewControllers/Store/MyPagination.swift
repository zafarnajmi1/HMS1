//
//  MyPagination.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/30/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation

class MyPagination {
    static let shared = MyPagination()
   
    
    var perPage: Int {
        get { return 50 }
    }

    
    func checkFetchMore(model : Pagination?) -> Bool {
        guard let pagination = model else {
            return false
        }
        
        if pagination.page! < pagination.pages! {
            return true
        }
        else{
            return false
        }
     
    }
}
