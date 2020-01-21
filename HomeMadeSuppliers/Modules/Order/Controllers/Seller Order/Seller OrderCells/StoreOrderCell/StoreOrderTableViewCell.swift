//
//  OrderTableViewCell.swift
//  Baqala
//
//  Created by apple on 12/4/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit


class StoreOrderTableViewCell: UITableViewCell {
    //MARK:- outlets
    @IBOutlet weak var myContentView: UIView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myDate: UILabel!
    @IBOutlet weak var myQuantity: UILabel!
    @IBOutlet weak var myStatus: UILabel!
    @IBOutlet weak var myPrice: UILabel!
    @IBOutlet weak var myBtnView: UIButton!
    
    @IBOutlet weak var myPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
   
    //MARK:- Properties
    var sharedVC: UIViewController!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
        // Initialization code
       
    }
    
    //MARK:- base Intialization
    
    func setLocalization()  {
        self.quantityLabel.text = "Quantity:".localized
        self.dateLabel.text = "Date:".localized
        self.statusLabel.text = "Status:".localized
        self.myPriceLabel.text = "Total Amount:".localized
        self.setViewDirectionByLanguage()
    
    }
    
    func setData(model: Order )  {
        let image = model.images?.first(where: {$0.isDefault == true})
        self.myImage.setPath(image: image?.path?.resizeImage(width: 544, height: 377), placeHolder: AppConstant.placeHolders.product)
        self.myTitle.text = model.product?.title ?? ""
        self.myPrice.text = setDefualtCurrency(price: model.totalWithShipping)
        self.myStatus.text = model.status?.capitalized
        self.myQuantity.text = "\(model.quantity ?? 0)"
        self.myDate.text = setDateFormatBy(dateString: model.createdAt!)
        
        
    }
    
    
    
}
