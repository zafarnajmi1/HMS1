//
//  MyOrderDetailTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/24/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class MyOrderDetailTableViewCell: UITableViewCell {
    
    //MARK:-  Outlets
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var features: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var storeLable: UILabel!
    @IBOutlet weak var store: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }
    
    
    func loadCell(model: OrderDetail)  {
        
        let image = model.images?.first(where: {$0.isDefault == true})
        self.myImage.setPath(image: image?.path?.resizeImage(width: 220, height: 200), placeHolder: AppConstant.placeHolders.product)
        
        
        self.title.text = model.product?.title ?? ""
        self.quantity.text = "\(model.quantity ?? 0)"
        self.price.text = setDefualtCurrency(price: model.totalWithShipping)
        self.store.text = model.store?.storeName
        self.status.text = model.status?.capitalized.localized ?? ""
        
        self.features.attributedText = formatedfeatures(features: model.priceables)
        
        
        switch model.status?.lowercased() {
        case "confirmed":
            statusBtn.isEnabled = false
            statusBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            let btnTitle = model.status?.capitalized
            self.statusBtn.setTitle( btnTitle , for: .normal)
            statusBtn.setTitleColor(.darkGray, for: .normal)
            statusBtn.isHidden = true
        case "shipped":
            //            statusBtn.isEnabled = true
            //            statusBtn.backgroundColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
            statusBtn.isEnabled = false
            statusBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            let btnTitle = model.status?.capitalized
            statusBtn.setTitleColor(.darkGray, for: .normal)
            statusBtn.setTitle(btnTitle, for: .normal)
            statusBtn.isHidden = true
        case "completed":
            statusBtn.isEnabled = false
            statusBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            statusBtn.setTitleColor(.darkGray, for: .normal)
            statusBtn.setTitle("Completed".localized, for: .normal)
            statusBtn.isHidden = true
        default:
            statusBtn.isHidden = true
        }
    }
    
}

extension MyOrderDetailTableViewCell {
    private func setLocalization() {
        self.quantityLabel.text = "Quantity:".localized
        self.storeLable.text = "Store Name:".localized
        self.statusLabel.text = "Status:".localized
    }
}




// utility
func formatedfeatures(features:[Priceable]?) -> NSAttributedString {
    var formatedfeature = ""
    var labels = [String]()
    
    guard let priceables = features else {
        return formatedfeature.colorForText(labels: labels)
    }
    
    for item in priceables {
        let feature = item.feature?.title ?? ""
        let option = item.characteristic?.title ?? ""
        formatedfeature = formatedfeature + "\(feature): \(option)  "
        labels.append("\(feature):")
    }
    
    return formatedfeature.colorForText(labels: labels)
}
