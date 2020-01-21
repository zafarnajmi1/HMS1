//
//  CartTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/17/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import MarqueeLabel

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var shippingPrice: UILabel!
    @IBOutlet weak var shippingPriceLabel: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var features: MarqueeLabel!
    @IBOutlet weak var removeBtn: UIButton!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var offerTag: UIImageView!
    
    
    var counter = 1
    var cart: Cart?
    var delegate: CallBackDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        shippingPriceLabel.text = "Shipping Amount:".localized
    }

    
    
    func setData(model: Cart, index: Int)  {
        
        //formate
        features.tag = index
        features.type = .continuous
        features.speed = .duration(15.0)
        features.fadeLength = 4.0
        features.trailingBuffer = 8.0
        
    
        
        
        self.cart = model
        let url = model.image?.resizeImage(width: 220, height: 200)
        myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.product)
        title.text = model.product?.title ?? ""
        subtitle.text = model.store?.storeName ?? ""
        price.text = setDefualtCurrency(price: model.price)
        totalPrice.text = setDefualtCurrency(price: model.total)
        shippingPrice.text = setDefualtCurrency(price: model.shippingAmount)
        counterLabel.text = "\(model.quantity ?? 1)"
        counter = model.quantity ?? 1
        
        var formatedfeature = ""
        var labels = [String]()
        if let priceAbles = model.priceables {
            for item in priceAbles {
                let feature = item.feature?.title ?? ""
                let option = item.characteristic?.title ?? ""
                formatedfeature = formatedfeature + "\(feature) : \(option)   "
                labels.append("\(feature) :")
            }
        }
        
        if model.isOffer == true {
            self.offerTag.isHidden = false
        }
        else {
            self.offerTag.isHidden = true
        }
        
        self.features.attributedText = formatedfeature.colorForText(labels: labels , color: #colorLiteral(red: 0.1292741299, green: 0.1332860291, blue: 0.1374364793, alpha: 1))

    
    }
    
    //MARK:-  actions
    @IBAction func plusBtnTapped(_ sender: UIButton) {
        counter = counter + 1
        plusBtn.showLoader(true)
        requesToUpdateCart()

    }
    
    @IBAction func minusBtnTapped(_ sender: UIButton) {
        if counter > 1 {
          
            counter = counter - 1
            minusBtn.showLoader(true)
            requesToUpdateCart()
        }
    }
    
    @IBAction func removeBtnTapped(_ sender: UIButton) {
        self.presentAlert(message: "Do you want to remove this Product?".localized, yes: {
            self.requesToRemoveProduct()
        }, no: nil)
      
    }
    
    func requesToRemoveProduct()  {
        
        guard let cart = cart else {return }
        
        let params = ["id": cart.id!, "product": cart.product!.id!] as [String: Any]
        
        removeBtn.showLoader(true)
        
        CartManager.shared.removeProduct(params: params) { (result) in
            self.removeBtn.showLoader(false)
            
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
    
    func requesToUpdateCart()  {
        
        guard let cart = cart else {return }
        
        let params = ["id": cart.id!,
                      "product": cart.product!.id!,
                      "quantity": counter] as [String: Any]
       
        CartManager.shared.updateQuantity(params: params) { (result) in
            self.plusBtn.showLoader(false)
            self.minusBtn.showLoader(false)
            
            switch result {
            case .sucess(let _):
                //nvMessage.showStatusSuccess(body: root.message ?? "")
                self.delegate?.reloadData()
             case .failure(let error):
               nvMessage.showStatusError(body: error)
               self.delegate?.reloadData()
            }
        }
    }

}
