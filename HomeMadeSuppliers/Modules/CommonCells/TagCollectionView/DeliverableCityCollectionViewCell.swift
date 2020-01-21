//
//  DeliverableCityCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/27/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class DeliverableCityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var myContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(model: DeliverableCity1)  {
      label.text = model.city?.title ?? ""
      value.text = model.price?.showPrice?.formattedText
    }
    
    func setData(model: DeliverableCity)  {
        label.text = model.city?.title ?? ""
        value.text = setDefualtCurrency(price: model.price)
    }
}
