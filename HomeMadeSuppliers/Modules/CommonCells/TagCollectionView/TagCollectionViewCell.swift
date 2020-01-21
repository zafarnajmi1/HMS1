//
//  TagCollectionViewCell.swift
//  DynamicHeightCollectionView
//
//  Created by Payal Gupta on 11/02/19.
//  Copyright © 2019 Payal Gupta. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    let remove = " ✖️"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = nil
        self.titleLabel.font = robotoMedium14
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        self.contentView.backgroundColor = #colorLiteral(red: 0.9566419721, green: 0.9607869983, blue: 0.9647976756, alpha: 1)
    }
    
    func setData(model: DeliverableCity,
                 isRemovableCell: Bool)  {
        
        var stringValue = ""
        let cityName = model.city?.title ?? ""
        let price = setDefualtCurrency(price: model.price)
        stringValue = "\(cityName): \(price)"
       
        if isRemovableCell == true {
           stringValue = "\(cityName): \(price) \(remove)"
        }
        
        let attributedString = NSMutableAttributedString(string: stringValue)
        
        attributedString.setColorForText(textForAttribute: price, withColor: #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1))
        
        titleLabel.attributedText = attributedString
    }
}
