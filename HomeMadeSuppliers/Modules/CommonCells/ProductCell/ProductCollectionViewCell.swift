//
//  ProductCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/31/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Cosmos





protocol ProductCollectionViewCellDelegate: class {
    func buyNowBtnTapped(billAmount: Price?)
}


class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myStatus: UILabel!
    @IBOutlet weak var myPrice: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var supplierLable: UILabel!
    @IBOutlet weak var supplier: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var offerTag: UIImageView!
    @IBOutlet weak var topRatedTag: UIImageView!
    //default postion = 0
    //newPosition 43:0
    @IBOutlet weak var cartButtonTopPosition: NSLayoutConstraint!
    @IBOutlet weak var ImageHeightPosition: NSLayoutConstraint!
    @IBOutlet weak var oldPrice: UILabel!
    //default position = 5 
    @IBOutlet weak var priceLabelTopPosition: NSLayoutConstraint!
    
    var product: Product?
    var delegate: CallBackDelegate?
    var quantity = 1
   
    override func prepareForReuse() {
    
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         setupLocalization()
    }
    
  
}

extension ProductCollectionViewCell {
    
    func setupLocalization(){
        self.supplierLable.text = "Supplier :".localized
        self.topRatedTag.image = self.topRatedTag.topRatedImage
        AppLanguage.updateLabelsDirection([myTitle, supplier, address])
    }
    
}

 //MARK:-   support method
extension ProductCollectionViewCell {
    
    
    
    func loadCell(model: Product)  {
        // capture model into class veriable
        product = model
        
        let url = model.image?.resizeImage(width: 540, height: 377)
        self.myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.product)
        
        
        self.myTitle.text = model.title
        self.myPrice.text = setDefualtCurrency(price: model.price)
        let rating =  model.averageRating ?? 0
        self.topRatedTag.isHidden = rating >= 4.5 ? false: true
        self.ratingStar.rating = rating
        self.ratingNumber.text = rating.format1
        self.supplier.text = model.store?.storeName ?? ""
        self.address.text = model.store?.addressExchange ?? ""
        
        self.updateLabelsByOffer()
        self.updateLabelsByProductType()
        self.updateFavButton()
        //tap handler
        cartButtonActionHandler()
    }
    
    fileprivate func updateLabelsByProductType() {
        
        switch product?.productType {
        case "simple":
            if product?.isAvailable == true {
                self.myStatus.text = "Available".localized
                cartBtn.isHidden = false
            }
            else {
                self.myStatus.text = "Not Available".localized
                cartBtn.isHidden = true
            }
        case "stock":
            let prefix = "In Stock : ".localized
            let qty = product?.available ?? 0
            let string = "\(prefix) \(qty)"
            self.myStatus.attributedText = string.stringToColor(strValue: prefix, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        case "configurable":
            let prefix = "In Stock : ".localized
            let qty = product?.available ?? 0
            let string = "\(prefix) \(qty)"
            self.myStatus.attributedText = string.stringToColor(strValue: prefix, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
//            self.oldPrice.text =  ""
//            if self.myPrice.text?.count ?? 0 == 0 {
//                self.myPrice.text = "  "
//            }
            
            self.myPrice.text = setDefualtCurrency(price: product?.price)
            self.oldPrice.text = ""
            self.priceLabelTopPosition.constant = 5
            
        default:
            return
        }
        
    }
    
    
    fileprivate func updateFavButton() {
       
        if let favList = self.product?.favorites {
            let user = AppSettings.shared.user
            
            if favList.contains(where: {$0 == user?.id}) {
                favBtn.isSelected = true
            }
            else {
                favBtn.isSelected = false
            }
        }
        else {
            favBtn.isSelected = false
        }
    }
    
    fileprivate func updateLabelsByOffer() {
        guard let product = self.product else {
            return
        }
        
        
       
        
        
        
        if product.isOffer == true  {
            self.oldPrice.isHidden = false
            self.offerTag.isHidden = false
            self.priceLabelTopPosition.constant = 16
            self.myPrice.text = setDefualtCurrency(price: product.offer)
            
            let oldPriceString = setDefualtCurrency(price: product.price)
            self.oldPrice.attributedText = NSAttributedString(string: oldPriceString,
                                           attributes: [
                                            NSAttributedString.Key.strikethroughStyle:
                                            NSNumber(value: NSUnderlineStyle.single.rawValue)
                ])
            
            if product.offer == nil {
                self.myPrice.text = setDefualtCurrency(price: product.price)
                self.oldPrice.text = ""
                self.priceLabelTopPosition.constant = 5
            }
           

        }
        else {
            self.oldPrice.text = ""
            self.oldPrice.isHidden = true
            self.offerTag.isHidden = true
            self.priceLabelTopPosition.constant = 5
          
        }
        
       
    }
    
    
   
}


//MARK:- api request
extension ProductCollectionViewCell {
    
    func requestToFavoriteProduct()  {
        guard  let id = product?.id else { return }
        favBtn.showLoader(true)
        ProductManager.shared.favoriteToggleProduct(id: id) { (result) in
            self.favBtn.showLoader(false)
            switch result {
            case .sucess(let _):
                self.favoriteToggle()
                self.delegate?.reloadData()
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
}

 //MARK:- navigation
extension ProductCollectionViewCell {
    
    func moveToProductFeatureVC()  {
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: ProductFeatureVC2.id ) as! ProductFeatureVC2
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.product = self.product
        vc.delegate = self
        self.parentVC?.present(vc, animated: true, completion: nil)
    }
}


 //MARK:- actions/ tap handlers
extension ProductCollectionViewCell {
    
    
   
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
    
    @IBAction func favBtnTapped(_ sender: UIButton) {
        
        switch myDefaultAccount {
        case .buyer:
            requestToFavoriteProduct()
        case .seller:
            favBtn.isEnabled = false
        default:
            AppSettings.guestLogin(view: self.contentView)
        }
        
    }
    
    
    func favoriteToggle()  {
        if favBtn.isSelected == true {
            favBtn.isSelected = false
        }
        else {
            favBtn.isSelected = true
        }
    }
    
    
    fileprivate func cartButtonActionHandler() {
        
        if  myDefaultAccount == .seller  {
               self.cartBtn.isHidden = true
        }
        else {
            self.cartBtn.isHidden = false
        }
        
        //MARK:-  actions
        shareBtn.onTap {
            self.shareInApp(str: self.product?.image ?? "Home Made Supplier")
        }
        
        cartBtn.onTap {
            switch myDefaultAccount {
                
            case .buyer:
                if self.product?.store?.isBusy == true {
                    AppSettings.storeIsBusyAlert(view: self.contentView)
                }
                else {
                    self.moveToProductFeatureVC()
                }
            case .seller:
                self.cartBtn.isHidden = true
            case .guest:
                AppSettings.guestLogin(view: self.contentView)
            default:
                return
            }
        }
    }
    
}


 //MARK:- ProductCollectionViewCellDelegate
extension ProductCollectionViewCell: ProductCollectionViewCellDelegate {
    func buyNowBtnTapped(billAmount: Price?) {
        moveToCheckout(price: billAmount)
    }
    
    func moveToCheckout(price: Price?) {
        
        let s = AppConstant.storyBoard.checkout
        let vc = s.instantiateViewController(withIdentifier: CheckOutVC.id) as! CheckOutVC
        vc.totalBilAmount = price
        vc.isFromBuyNow = true
        self.parentVC?.navigationController?.pushViewController(vc, animated: true)
    }
}
