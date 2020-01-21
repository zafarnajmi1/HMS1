//
//  ProductInfoTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/13/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Cosmos
import Lightbox

protocol ProductInfoTableViewCellDelegate {
    
    func didUpdate(quantity: Int )
}

class ProductInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var categorySuper: UILabel!
    @IBOutlet weak var categorySub: UILabel!
    @IBOutlet weak var inStock: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var supplierLabel: UILabel!
    @IBOutlet weak var supplier: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var notifyBtn: UIButton!
    @IBOutlet weak var notifyView: UIView!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var resetView: UIView!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageConrtol: UIPageControl!
    
    @IBOutlet weak var topRatedTag: UIImageView!
    @IBOutlet weak var offerTag: UIImageView!
    @IBOutlet weak var oldPrice: UILabel!
    
    var viewController: UIViewController?
    var quantity = 1
    var availableQunty: Int?
    var stepperDelegate: StepperCollectionViewCellDelegate?
    var cellDelegate: ProductInfoTableViewCellDelegate?
    var product: ProductDetail?
    var imageList:[Image1] = []
    var imageCounter = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLacalization()
        collectionView.registerCell(id: ImageCollectionViewCell.id)
       
    }
    
     //MARK:-  localization
    func setLacalization () {
        self.supplierLabel.text = "Supplier :".localized
        self.topRatedTag.image = self.topRatedTag.topRatedImage
        AppLanguage.updateLabelsDirection([supplier, name, supplierLabel, notifyLabel, address])
    }
    
     //MARK:-   initialziation
    func loadCell(model: ProductDetail, _ vc: UIViewController, quantity: Int, combination: Combination1? )  {
        //defaul handling
        notifyView.isHidden = true
        
        self.quantity = quantity
        counterLabel.text = "\(quantity)"
        
        //initialize
        self.viewController = vc
        self.product = model
        
        self.imageList = model.images ?? []
        pageConrtol.numberOfPages = self.imageList.count
        collectionView.reloadData()
        setTimer()
        
        let url = model.image?.resizeImage(width: 620, height: 600)
        self.myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.product)
        
        let rating = model.averageRating ?? 0
        self.topRatedTag.isHidden = rating >= 4.5 ? false:true
        ratingStar.rating = rating
        ratingNumber.text = "(\(rating))"
        
        name.text = model.title ?? ""
        showCategories(model: model.categories)
        
        price.text = model.price?.showPrice?.formattedText
        supplier.text = model.store?.storeName ?? ""
        address.text = model.store?.address ?? ""
        
        
        self.updateLablesByProductType()
        self.updateDefaultProductPriceByOffer()
        
        
        
        
        
        if let favList = model.favorites {
            let user = AppSettings.shared.user
            if favList.contains(where: {$0 == user?.id}) {
                favBtn.isSelected = true
            }
        }
        
        if let notifyList = model.notifyOnRestock {
            let user = AppSettings.shared.user
            if notifyList.contains(where: {$0 == user?.id}) {
                notifyBtn.isSelected = true
            }
        }
        
        if let combination = combination {
            self.updateStepper(combination: combination ,resetQuantity: false)
            
            
        }
        
        //MARK:-  actions
        
        notifyView.addTapGesture { (tap) in
            self.requestToNotifyRestockProduct()
        }
        notifyBtn.addTapGesture { (tap) in
            self.requestToNotifyRestockProduct()
        }
    }
    
    fileprivate func updateDefaultProductPriceByOffer () {
        
        guard let model = self.product else {
            return
        }
        
        if model.isOffer == true {
            self.offerTag.isHidden = false
            
            
            if model.offer == nil {
                self.price.text = model.price?.showPrice?.formattedText
                self.oldPrice.text = ""
            }
            else {
                self.price.text = model.offer?.showPrice?.formattedText
                self.oldPrice.isHidden = false
                let oldPriceString = model.price?.showPrice?.formattedText
                self.oldPrice.attributedText = NSAttributedString(string: oldPriceString ?? "", attributes: [NSAttributedString.Key.strikethroughStyle:
                    NSNumber(value: NSUnderlineStyle.single.rawValue)
                ])
            }
            
            
        }
        else {
            self.offerTag.isHidden = true
            self.oldPrice.isHidden = true
            self.price.text = model.price?.showPrice?.formattedText
        }
        
    }
    
    
    
    func showCategories(model: [Category1]?) {
        
        guard let categories = model else{ return }
        
        for (index, item) in categories.enumerated() {
            switch index {
            case 0:
                categorySuper.text = item.title ?? ""
            case 1:
                categorySub.text = item.title ?? ""
            default:
                return
            }
        }
        
    }
    
    fileprivate func updateLablesByProductType () {
        guard let product = self.product else{
            return
        }
        
        switch product.productType {
        case "simple":
            if product.isAvailable == true {
                self.inStock.text = "Available".localized
            }
            else {
                self.inStock.text = "Not Available".localized
            }
        case "stock":
            let prefix = "In Stock :".localized
            let qty = product.available ?? 0
            let string = "\(prefix) \(qty)"
            if myDefaultAccount == .buyer {
                notifyView.isHidden = qty == 0 ? false:true
            }
            
            self.inStock.attributedText = string.stringToColor(strValue: prefix, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            self.availableQunty = product.available ?? 0
        case "configurable":
            let prefix = "In Stock :".localized
            let qty = product.available ?? 0
            let string = "\(prefix)  \(qty)"
            if myDefaultAccount == .buyer {
                notifyView.isHidden = qty == 0 ? false:true
            }
            
            self.inStock.attributedText = string.stringToColor(strValue: prefix, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            self.availableQunty = product.available ?? 0
            
            
            self.oldPrice.isHidden = true
            self.price.text = product.price?.showPrice?.formattedText
            //        if self.product?.price?.aed == nil {
            //            self.price.text = product.offer?.showPrice?.formattedText
            //        }
            
        default:
            return
        }
        
        
        
    }
    
    
    
    
}


// For Configurable

extension ProductInfoTableViewCell {
    
    func updateStepper(combination: Combination1, resetQuantity: Bool = true ) {
        
        let prefix = "In Stock : ".localized
        let string = "\(prefix) \(combination.available ?? 0)"
        
        let url = combination.image?.resizeImage(width: 620, height: 600)
        self.myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.product)
        
        
        
        self.inStock.attributedText = string.stringToColor(strValue: prefix, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        self.availableQunty = combination.available ?? 0
        
        if resetQuantity == true  &&  self.quantity > combination.available ?? 0 {
            quantity = 1
            counterLabel.text = "\(quantity)"
            self.cellDelegate?.didUpdate(quantity: quantity)
            nvMessage.showStatusWarning(title: "Alert".localized, body: "quantity is reset")
        }
        
        
        if combination.isOffer == true {
            self.offerTag.isHidden = false
            self.price.text = combination.offer?.showPrice?.formattedText
            self.oldPrice.isHidden = false
            let oldPriceString = combination.price?.showPrice?.formattedText
            self.oldPrice.attributedText = NSAttributedString(string: oldPriceString ?? "", attributes: [NSAttributedString.Key.strikethroughStyle:
                NSNumber(value: NSUnderlineStyle.single.rawValue)
            ])
            
            
        }
        else {
            self.offerTag.isHidden = true
            self.oldPrice.isHidden = true
            self.price.text = combination.price?.showPrice?.formattedText
        }
        
        
        
        
        if myDefaultAccount == .buyer {
            notifyView.isHidden = availableQunty == 0 ? false:true
        }
        resetView.isHidden = false
        
        
        self.imageList = combination.images ?? []
        self.pageConrtol.numberOfPages = self.imageList.count
        self.collectionView.reloadData()
        setTimer()
    }
    
    func isvalidQunatiy() -> Bool {
        if availableQunty != nil && quantity > availableQunty ?? 0 {
            return false
        }
        return true
    }
}



//MARK:-  api request
extension ProductInfoTableViewCell {
    
    
    func requestToFavoriteProduct()  {
        guard  let id = product?.id else { return }
        favBtn.showLoader(true)
        ProductManager.shared.favoriteToggleProduct(id: id) { (result) in
            self.favBtn.showLoader(false)
            switch result {
            case .sucess( _):
                self.toggle(button: self.favBtn)
                
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
    
    func requestToNotifyRestockProduct()  {
        guard  let id = product?.id else { return }
        notifyBtn.showLoader(true)
        ProductManager.shared.notifyOnRestockProduct(id: id) { (result) in
            self.notifyBtn.showLoader(false)
            switch result {
            case .sucess(_):
                self.toggle(button: self.notifyBtn)
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
    
}

//MARK:-  actions
extension  ProductInfoTableViewCell {
    
    
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        
        let url = product?.image?.resizeImage(width: 620, height: 600)
        self.myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.product)
        
        let prefix = "In Stock : ".localized
        let qty = self.product?.available ?? 0
        let string = "\(prefix) \(qty)"
        self.inStock.attributedText = string.stringToColor(strValue: prefix, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        self.availableQunty = self.product?.available ?? 0
        self.quantity = 1
        self.counterLabel.text = "\(self.quantity)"
        self.stepperDelegate?.resetFeaturesSelection()
        self.updateDefaultProductPriceByOffer()
        self.resetView.isHidden = true
    }
    
    
    
    
    
    @IBAction func plusBtnTapped(_ sender: UIButton) {
        
        if availableQunty == nil {
            quantity = quantity + 1
            counterLabel.text = "\(quantity)"
        }
        else if quantity < availableQunty ?? 0 {
            quantity = quantity + 1
            counterLabel.text = "\(quantity)"
        }
        
        cellDelegate?.didUpdate(quantity: quantity)
    }
    
    @IBAction func minusBtnTapped(_ sender: UIButton) {
        if quantity > 1 {
            quantity = quantity - 1
            counterLabel.text = "\(quantity)"
        }
        cellDelegate?.didUpdate(quantity: quantity)
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
    
    func toggle(button: UIButton)  {
        if button.isSelected == true {
            button.isSelected = false
        }
        else {
            button.isSelected = true
        }
    }
    
}




//MARK:-  collection view implementation

extension ProductInfoTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.frame.size.width
        let height = self.collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
}



extension ProductInfoTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageList.count > 0 ? imageList.count:1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.id, for: indexPath) as? ImageCollectionViewCell
            else{
                return UICollectionViewCell()
        }
        
        if imageList.count > 0 {
            let image = imageList[indexPath.row]
            cell.myImage.setPath(image: image.path?.resizeImage(width: 600, height: 600),
                                 placeHolder: AppConstant.placeHolders.product)
        }
        else {
            cell.myImage.setPath(image: nil, placeHolder: AppConstant.placeHolders.product)
        }
        
        
        
        //  cell.myimage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if imageList.count > 0 {
            let images = self.imageList.compactMap({$0.path})
            self.showImageVC(imagesURL: images, startIndex: indexPath.row, singImageURL: nil)
        }
        else {
            print(" no image exist")
        }
        
        
    }
}
extension ProductInfoTableViewCell : UIScrollViewDelegate{
    
    @IBAction func onClick_pager(_ sender: UIPageControl) {
        let page = sender.currentPage
        collectionView.scrollToPage(index: page, animated: true, after: 0)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        print("Image Preview DidEndScrollingAnimation")
        previewEndScrolling()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: nil, afterDelay: 0.3)
        print("Image Preview ScrollViewDidScroll")
    }
    func previewEndScrolling() {
        let page = collectionView.contentOffset.x / pageConrtol.frame.width
        pageConrtol.currentPage = Int(page)
    }
    
    
    
    func setTimer() {
        //        let _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    
    
    @objc func autoScroll() {
        
        if imageCounter < self.imageList.count {
            let indexPath = IndexPath(item: imageCounter, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            imageCounter = imageCounter + 1
        }
        else {
            imageCounter = 0
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
}
