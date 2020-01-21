//
//  ManageProductCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/24/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Cosmos

class ManageProductCollectionViewCell: UICollectionViewCell {

    
    //MARK:- outlets
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myPrice: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var soldLable: UILabel!
    @IBOutlet weak var soldValue: UILabel!
    @IBOutlet weak var stockLable: UILabel!
    @IBOutlet weak var stockValue: UILabel!
    @IBOutlet weak var myTitle: UILabel!

    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
   
    @IBOutlet weak var myStatus: UILabel!

    @IBOutlet weak var offerTag: UIImageView!
    @IBOutlet weak var topRatedTag: UIImageView!
    @IBOutlet weak var approvalPendingTag: UIImageView!
    
     @IBOutlet weak var priceLabelTopPosition: NSLayoutConstraint!
    
    
    
     //MARK:-  variables
    var product: Product? {
        didSet {
            self.updateCell(model: product)
        }
    }
   
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
        setupAppearance()
    }
    
    
    
    private func setLocalization() {
        self.stockLable.text = "Stock:".localized
        self.soldLable.text = "Sold:".localized
        self.approvalPendingTag.image = approvalPendingTag.approvalPendingImage
        self.topRatedTag.image = topRatedTag.topRatedImage
    }
    
    
    
    func setupAppearance() {
        let image1 = UIImage(named: "EditWhite")?.withRenderingMode(.alwaysTemplate)
        editBtn.setImage(image1, for: .normal)
        editBtn.tintColor = UIColor.lightGray
        
        let image2 = UIImage(named: "Delete")?.withRenderingMode(.alwaysTemplate)
        deleteBtn.setImage(image2, for: .normal)
        deleteBtn.tintColor = UIColor.lightGray
    }
    
    fileprivate func updateCell(model: Product? ){
        
        let url = model?.image?.resizeImage(width: 600, height: 400)
        self.myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.product)
        self.myTitle.text = model?.title ?? "--"
        self.myPrice.text = setDefualtCurrency(price: model?.price)
        let rating =  model?.averageRating ?? 0
        topRatedTag.isHidden = rating >= 4.5 ? false:true
        self.ratingStar.rating = rating
        self.ratingNumber.text = rating.format1
        self.soldValue.text = "\(model?.sold ?? 0)"
      
        self.offerTag.isHidden = model?.isOffer == true ? false:true
        self.approvalPendingTag.isHidden = model?.approvalPending == true ? false:true
        
        if model?.isOffer == true  {
            self.oldPrice.isHidden = false
            self.offerTag.isHidden = false
            self.priceLabelTopPosition.constant = 26
            self.myPrice.text = setDefualtCurrency(price: product?.offer)
            
            let oldPriceString = setDefualtCurrency(price: product?.price)
            self.oldPrice.attributedText = NSAttributedString(string: oldPriceString,
                                           attributes: [
                                            NSAttributedString.Key.strikethroughStyle:
                                            NSNumber(value: NSUnderlineStyle.single.rawValue)
                ])
            
            if model?.offer == nil {
              self.myPrice.text = setDefualtCurrency(price: product?.price)
              self.oldPrice.text = ""
              self.priceLabelTopPosition.constant = 16
           }
           


        }
        else {
            self.oldPrice.text = ""
            self.oldPrice.isHidden = true
            self.offerTag.isHidden = true
            self.priceLabelTopPosition.constant = 16
          
        }
        
        switch model?.productType {
        case "simple":
           
            if model?.isAvailable == true {
                self.myStatus.text = "Available".localized
            }
            else {
                self.myStatus.text = "Not Available".localized
            }
            self.stockLable.isHidden = true
            self.stockValue.isHidden = true
            
        case "stock":
            self.stockLable.isHidden = false
            self.stockValue.isHidden = false
            
            let totalStock = (model?.sold ?? 0) + (model?.available ?? 0)
            self.stockValue.text = "\(totalStock)"
            
            let postfix = "Remaining".localized
            self.myStatus.text = "\(model?.available ?? 0) \(postfix)"
       case "configurable":
          self.stockLable.isHidden = false
          self.stockValue.isHidden = false
          
          let totalStock = (model?.sold ?? 0) + (model?.available ?? 0)
          self.stockValue.text = "\(totalStock)"
          
          let postfix = "Remaining".localized
          self.myStatus.text = "\(model?.available ?? 0) \(postfix)"
           
            self.myPrice.text = setDefualtCurrency(price: product?.price)
            self.oldPrice.text = ""
            self.priceLabelTopPosition.constant = 16
            
            
        default:
            
            
            
            
            
            return
        }
        
        
        self.shareBtn.onTap {
             self.shareInApp(str: self.product?.image ?? "Home Made Supplier")
        }
    }


}


extension UIImageView {
    var approvalPendingImage:UIImage? {
        let imageName = myDefaultLanguage == .ar ? "ApprovalPendingAR":"ApprovalPending"
        return UIImage(named: imageName)
    }
    
    var topRatedImage:UIImage? {
        let imageName = myDefaultLanguage == .ar ? "TopRatedAR":"TopRated"
        return UIImage(named: imageName)
    }
}
