//
//  StoreOrderDetailTableViewCell.swift
//  TailerOnline
//
//  Created by apple on 5/8/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class StoreOrderDetailTableViewCell: UITableViewCell {

    //MARK:-  Outlets
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var features: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }
    
    
    private func setLocalization() {
        self.quantityLabel.text = "Quantity:".localized
        self.dateLable.text = "Date:".localized
        self.statusLabel.text = "Status:".localized
        
    }
    
    func setData(model: OrderDetail)  {
        
        let image = model.images?.first(where: {$0.isDefault == true})
        self.myImage.setPath(image: image?.path?.resizeImage(width: 540, height: 200), placeHolder: AppConstant.placeHolders.product)
        
        self.title.text = model.product?.title ?? ""
        self.quantity.text = "\(model.quantity ?? 0)"
        self.price.text = setDefualtCurrency(price: model.totalWithShipping)
        self.date.text = setDateFormatBy(dateString: model.createdAt!)
        self.status.text = model.status?.capitalized.localized ?? ""
        self.features.attributedText = formatedfeatures(features: model.priceables)
        
        
        switch model.status?.lowercased() {
        case "confirmed":
            statusBtn.isEnabled = true
            let btnTitle = "ship".capitalized.localized
            self.statusBtn.setTitle( btnTitle , for: .normal)
        case "shipped":
            statusBtn.isEnabled = true
            //statusBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            //statusBtn.setTitleColor(.darkGray, for: .normal)
           // statusBtn.setTitle("Shipped".localized, for: .normal)
            statusBtn.setTitle("Delivered".capitalized.localized, for: .normal)
        case "completed":
            statusBtn.isEnabled = false
            statusBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            statusBtn.setTitleColor(.darkGray, for: .normal)
            statusBtn.setTitle("Completed".localized, for: .normal)
        default:
            statusBtn.isHidden = true
        }
       
    }
    
}

