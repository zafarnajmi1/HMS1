//
//  StepperCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/15/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

protocol StepperCollectionViewCellDelegate: class {
    func resetFeaturesSelection()
    
}

class StepperCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var oldPriceLabel: UILabel!
    
    
    
    var quantity = 1
    var availableQunty: Int?
    var delegate: StepperCollectionViewCellDelegate?
    var product: ProductDetail?
    
    //MARK:-  actions
    @IBAction func plusBtnTapped(_ sender: UIButton) {
        
        if availableQunty == nil {
            quantity = quantity + 1
            counterLabel.text = "\(quantity)"
        }
        else if quantity < availableQunty ?? 0 {
            quantity = quantity + 1
            counterLabel.text = "\(quantity)"
        }
       
    }
    
    @IBAction func minusBtnTapped(_ sender: UIButton) {
        if quantity > 1 {
            quantity = quantity - 1
            counterLabel.text = "\(quantity)"
        }
    }
    
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        let prefix = "In Stock : ".localized
        let qty = self.product?.available ?? 0
        let string = "\(prefix) \(qty)"
        self.stockLabel.attributedText = string.stringToColor(strValue: prefix, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        self.availableQunty = self.product?.available ?? 0
        self.quantity = 1
        self.counterLabel.text = "\(self.quantity)"
        self.delegate?.resetFeaturesSelection()
        self.resetView.isHidden = true
        self.updateDefaultProductPriceByOffer()
    }
    
    func setData(model: ProductDetail?)  {
        priceLabel.text = model?.price?.showPrice?.formattedText
        self.product = model
        
        switch model?.productType {
        case "simple":
            if model?.isAvailable == true {
                self.stockLabel.text = "Available".localized
            }
            else {
                self.stockLabel.text = "Not Available".localized
            }
        case "stock", "configurable":
            let prefix = "In Stock : ".localized
            let qty = model?.available ?? 0
            let string = "\(prefix) \(qty)"
            self.stockLabel.attributedText = string.stringToColor(strValue: prefix, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            self.availableQunty = model?.available ?? 0
        default:
            return
        }
        
        self.updateDefaultProductPriceByOffer()
    }
    
    fileprivate func updateDefaultProductPriceByOffer () {
        
        guard let model = self.product else {
            return
        }
        
        if model.isOffer == true {
            
            self.priceLabel.text = model.offer?.showPrice?.formattedText
            self.oldPriceLabel.isHidden = false
            let oldPriceString = model.price?.showPrice?.formattedText
            self.oldPriceLabel.attributedText = NSAttributedString(string: oldPriceString ?? "", attributes: [NSAttributedString.Key.strikethroughStyle:
                NSNumber(value: NSUnderlineStyle.single.rawValue)
                ])
            
            
            
            if model.offer == nil {
                self.priceLabel.text = model.price?.showPrice?.formattedText
                self.oldPriceLabel.text = ""
            }
            
            
        }
        else {
            self.oldPriceLabel.isHidden = true
            self.priceLabel.text = model.price?.showPrice?.formattedText
        }
        
    }
    
    
    
    
    
    func updateStepper(combination: Combination1) {
        
        let prefix = "In Stock : ".localized
        let string = "\(prefix) \(combination.available ?? 0)"
        self.priceLabel.text = combination.price?.showPrice?.formattedText
        self.stockLabel.attributedText = string.stringToColor(strValue: prefix, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        self.availableQunty = combination.available ?? 0
       
        quantity = 1
        counterLabel.text = "\(quantity)"
        resetView.isHidden = false
       
        self.updatePriceBy(combination: combination)
    }
    
    fileprivate func updatePriceBy(combination: Combination1) {
        
        if combination.isOffer == true {
            self.priceLabel.text = combination.offer?.showPrice?.formattedText
            self.oldPriceLabel.isHidden = false
            let oldPriceString = combination.price?.showPrice?.formattedText
            self.oldPriceLabel.attributedText = NSAttributedString(string: oldPriceString ?? "", attributes: [NSAttributedString.Key.strikethroughStyle:
                NSNumber(value: NSUnderlineStyle.single.rawValue)
                ])
            
            
        }
        else {
            self.oldPriceLabel.isHidden = true
            self.priceLabel.text = combination.price?.showPrice?.formattedText
        }
        
        
        
    }
    
    
    func isvalidQunatiy() -> Bool {
         if availableQunty != nil && quantity > availableQunty ?? 0 {
            return false
        }
        return true
    }
}
