//
//  ProductListProtocol.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/18/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation

protocol ProductDelegate {
    func didSelect(product: Product)
    func willReplace(product: Product)
    
}
//optional delgate functions
extension ProductDelegate {

    func willReplace(product: Product)  {}
}

protocol PriceAbleDelegate {
    func add(featureId:String, charId: String)
    func remove(featureId:String)
}


protocol CallBackDelegate {

    func reloadData()
}


//optoinals
extension CallBackDelegate {

}


protocol HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: IndexPath?)
}
