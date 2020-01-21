//
//  SubmitReviewTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/13/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Cosmos

class SubmitReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var reviewLabel: UILabel!
    
    
    var delegate: CallBackDelegate?
    var productId: String?
    var isProductRequest = true
    var storeId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }


    @IBAction func  submitBtn(_ sender: UIButton) {
        
        
        if isProductRequest == true && formIsvalid() == true {
            requestToSubmitProductReview()
            return
        }
        if isProductRequest == false && formIsvalid() == true  {
            requestToSubmitStoreReview()
            return
        }
        
    }
    
    func formIsvalid() -> Bool {
        
        if comment.text!.trim.count < 3  {
            let msg = "Comments must be minimum 3 characters".localized
            nvMessage.showError(title: "Submit Review".localized, body: msg)
            return false
        }
        
        return true
    }
    
    
    func requestToSubmitProductReview(){
        
        guard let productId = productId else {
            nvMessage.showError(body: "Product Id Not Found".localized)
            return
        }
        
        let params = ["_id": productId,
                      "rating": ratingStar.rating,
                      "comment": comment.text!] as [String: Any]
       
        submitBtn.showLoader(true)
       
        ProductManager.shared.submitReview(params: params) { (result) in
            
            self.submitBtn.showLoader(false)
            
            switch result {
            
            case .sucess(let root):
                nvMessage.showSuccess(body: root.message ?? "", closure: {
                    self.comment.text = ""
                    self.ratingStar.rating = 0
                    self.submitBtn.isEnabled = false
                    self.delegate?.reloadData()
                })
            
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
    
    func requestToSubmitStoreReview(){
        
        guard let productId = productId else {
            nvMessage.showError(body: "Product Id Not Found".localized)
            return
        }
        
        guard let storeId = storeId else {
            nvMessage.showError(body: "Store Id Not Found".localized)
            return
        }
        
        let params = ["product": productId,
                      "_id": storeId,
                      "rating": ratingStar.rating,
                      "comment": comment.text!] as [String: Any]
        
        submitBtn.showLoader(true)
        
        StoreManager.shared.submitReview(params: params) { (result) in
            
            self.submitBtn.showLoader(false)
            
            switch result {
                
            case .sucess(let root):
                nvMessage.showSuccess(body: root.message ?? "", closure: {
                    self.delegate?.reloadData()
                })
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
}
