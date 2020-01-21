//
//  MyOrderTableViewCell.swift
//  Baqala
//
//  Created by apple on 12/5/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {
 
    //MARK:- outlets
   
    @IBOutlet weak var myContentView: UIView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var orderListIcon: UIImageView!
    @IBOutlet weak var orderImgeShadow: UIImageView!
    @IBOutlet weak var myOrderNumber: UILabel!
    @IBOutlet weak var myTotalProducts: UILabel!
    @IBOutlet weak var myDate: UILabel!
    @IBOutlet weak var myStatus: UILabel!
    @IBOutlet weak var myPrice: UILabel!
    @IBOutlet weak var myBtnView: UIButton!
    
    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var myPriceLabel: UILabel!
    @IBOutlet weak var myTotalProductsLabel: UILabel!
    @IBOutlet weak var myStatusLabel: UILabel!
    
    //MARK:- Properties
  
   
    //MARK:- Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLocalization()
        // Initialization code
     
        self.orderImgeShadow.isHidden = true
    
    }

  
     //MARK:- localization
    func setLocalization()  {
        self.myStatusLabel.text = "Status:".localized
        self.myDateLabel.text = "Date:".localized
        self.myTotalProductsLabel.text = "Total Products:".localized
        self.myPriceLabel.text = "Total Amount:".localized
        self.setViewDirectionByLanguage()
        
        if myDefaultLanguage == .ar {
            orderListIcon.image = UIImage(named: "SliderWithBlackBgAR")
            myPrice.textAlignment = .right
        }
    }
    
    
   //MARK:- Base config
    
    func setData(model: Order)  {
        let image = model.images?.first(where: {$0.isDefault == true})
        self.myImage.setPath(image: image?.path?.resizeImage(width: 544, height: 377), placeHolder: AppConstant.placeHolders.product)
        self.myDate.text = setDateFormatBy( dateString: model.createdAt!)
        self.myTotalProducts.text = "\(model.orderItemsCount ?? 0 )"
        self.myPrice.text = setDefualtCurrency(price: model.total)
        
      
        if model.orderItemsCount ?? 0 > 1 {
            self.orderImgeShadow.isHidden = false
        }
        else{
            self.orderImgeShadow.isHidden = true
        }
        
        let orderLabel = "Order".localized
        let orderNumber = model.orderNumber ?? ""
        self.myOrderNumber.text = "\(orderLabel) # \(orderNumber)"
        
        self.myStatus.text = getformatedStatus(pending: model.pendingOrderItemsCount,
                                               shipped:model.shippedOrderItemsCount ,
                                              delivered:model.deliveredOrderItemsCount)
        

    
    }
    
 
}

func getformatedStatus (pending:Int?, shipped:Int?, delivered:Int?  ) -> String {
   
    var shippedStr = "Shipped".localized
    shippedStr = "\(shippedStr) (\(shipped ?? 0))"

    var completed = "Delivered".localized
    completed = "\(completed) (\(delivered ?? 0))"

    var pendingStr = "Pending".localized
    pendingStr = "\(pendingStr) (\(pending ?? 0))"
    
    //return pendingStr + ", " + shippedStr  + ", " + completed
    return pendingStr + ", " + completed
}
