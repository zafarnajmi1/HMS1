//
//  StepperTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/27/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class StepperTableViewCell: UITableViewCell {

    @IBOutlet weak var stockLabel: UILabel!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    var quantity = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:-  actions
    @IBAction func plusBtnTapped(_ sender: UIButton) {
        
        quantity = quantity + 1
        counterLabel.text = "\(quantity)"
    }
    
    @IBAction func minusBtnTapped(_ sender: UIButton) {
        if quantity > 1 {
            quantity = quantity - 1
            counterLabel.text = "\(quantity)"
        }
    }
    
    func setData(model: Product?)  {
      
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
            
        default:
            return
        }
    }
}
