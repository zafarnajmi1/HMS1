//
//  AddProductTopTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/25/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DropDown


 //MARK:-

protocol AddProductTopTableViewCellDelegate: class {
    func didSelect(category: Category?)
    func didSelect(subcategory: Category?)
    func didSelect(productAvailablity: String?)
    func didEnter(productName: String?)
    func didEnter(productNameAR: String?)
    func didEnter(productPrice: String?)
    func didEnter(productOfferPrice: String?, isOffer: Bool)
    func didEnter(productStock: String?)
}

class AddProductTopTableViewCell: UITableViewCell {

   
     //MARK:-  outlets
    
    //labels
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var productNameENLabel: UILabel!
    @IBOutlet weak var productNameARLabel: UILabel!
    @IBOutlet weak var enterPriceLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var productOfferPriceLabel: UILabel!
   

    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var subcategoryBtn: UIButton!
    @IBOutlet weak var category : UITextField!
    @IBOutlet weak var subcategory : UITextField!
    
    @IBOutlet weak var productAvailabilityBtn: UIButton!
    @IBOutlet weak var productAvailablity: UITextField!
    @IBOutlet weak var productAvailabilityView: UIView!
    
    @IBOutlet weak var productNameEnView: UIView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productNameAR: UITextField!
    @IBOutlet weak var productNameARView: UIView!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productOfferPrice: UITextField!
    @IBOutlet weak var productOfferPriceView: UIView!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var checkBoxtitle : UILabel!
    
    @IBOutlet weak var attributeTitle: UILabel!
    @IBOutlet weak var productStockLabel: UILabel!
    @IBOutlet weak var productStock: UITextField!
    @IBOutlet weak var productStockView: UIView!
   
    
    
   
    
    // class variables
    private let categoryDropDown = DropDown()
    private let subcategoryDropDown = DropDown()
    private let productAvailablityDropDown = DropDown()

    private var categories = [Category]()
    private var subcategories = [Category]()
    private var parameters: AddProductParmeters?
    
   // var selectedCategory: Category?
   // var selectedSubcategory: Category?

    var delegate: AddProductTopTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setLocalization()
        
        
        // Initialization code
        self.productName.delegate =  self
        self.productNameAR.delegate =  self
        self.productPrice.delegate = self
        self.productOfferPrice.delegate = self
        self.productAvailablity.delegate = self
        self.productStock.delegate = self
    }
    
    func loadCell(productType: ProductType , product: AddProductParmeters?,
                  isEditProduct: Bool = false, localeType: LocaleType = .en)  {
        self.parameters = product
        
        switch productType {
        case .stock:
           productStockView.isHidden = false
           productAvailabilityView.isHidden = true
         
        default:
            productStockView.isHidden = true
            productAvailabilityView.isHidden = false
        }
        setupDropDrowns()
        
       if localeType == .en && isEditProduct ==  true {
           self.productNameARView.isHidden = true
           self.productNameEnView.isHidden = false
       }
       else if localeType == .ar && isEditProduct == true {
           self.productNameARView.isHidden = false
           self.productNameEnView.isHidden = true
       }
       else {
           self.productNameARView.isHidden = true
           self.productNameEnView.isHidden = false
       }
//        self.productNameARView.isHidden = isEditProduct == true ? false:true
       
        
        //update textfields
        if let parameters = parameters {
            self.productName.text = parameters.titleEn
            self.productNameAR.text = parameters.titleAr
            self.productPrice.text = parameters.price
            self.category.text = parameters.selectedCategoryTitle
            self.subcategory.text = parameters.selectedSubcategoryTitle
            self.productOfferPrice.text = parameters.offer
           
            
            switch productType {
            case .simple:
                self.productAvailablity.text = parameters.isAvailable
            case .stock:
                self.productStock.text = parameters.available
            default:
                return
            }
            
            if parameters.isOffer == true {
                self.checkBoxButton.isSelected = true
                self.productOfferPriceView.isHidden = false
            }
            else {
                self.checkBoxButton.isSelected = false
                self.productOfferPriceView.isHidden = true
            }
            
        }
       
    }
    
    
    func setupDropDrowns() {
        setupCategoryDropDown()
        setupSubcategoryDropDown(selectedCategory: nil)
        setupProductAvailabilityDropDown()
        
    }
}


private extension AddProductTopTableViewCell {
    private func setLocalization() {
        self.categoryLabel.text = "Select Category".localized
        self.subcategoryLabel.text = "Select Subcategory".localized
        self.availabilityLabel.text = "Availability".localized
        self.enterPriceLabel.text = "Enter Price".localized
        self.productNameENLabel.text = "Product Name".localized
        self.productNameARLabel.text = "Product Name (Arabic)".localized
        self.productOfferPriceLabel.text = "Offer Price".localized
        self.attributeTitle.text = "Select Attributes".localized
        self.checkBoxtitle.text = "Add Offer".localized
        self.category.placeholder = "Category".localized
        self.subcategory.placeholder = "Subcategory".localized
        self.productAvailablity.placeholder = "Availability".localized
        self.productName.placeholder = "Product Name".localized
        self.productNameAR.placeholder = "Product Name (Arabic)".localized
        self.productStock.placeholder = "Enter Stock".localized
        self.productOfferPrice.placeholder = "Offer Price".localized
        self.productPrice.placeholder = "Enter Price".localized
        
        AppLanguage.updateTextFieldsDirection([
            category, subcategory, productName, productNameAR,
            productAvailablity, productPrice, productStock,
            productOfferPrice
        
        ])
        
    }
}



//MARK:-  setup drownDowns
extension AddProductTopTableViewCell {
    
    
    
    
    func setupCategoryDropDown(){
        
        var items = ["Category".localized]
        let superCateogries = AppSettings.shared.settingData?.categories
        
        let titls = superCateogries?.compactMap{$0.title} ?? []
        items.append(contentsOf: titls)
        
        categoryDropDown.setData(btn: categoryBtn, dataSource: items)
        categoryDropDown.selectionAction = {[unowned self](index: Int, item: String) in
            if index == 0 {
                self.category.text = ""
                self.subcategory.text = ""
                self.parameters?.selectedCategoryTitle = nil
                self.parameters?.selectedSubcategoryTitle = nil
                self.parameters?.subcategory = nil
                self.delegate?.didSelect(category: nil)
                self.setupSubcategoryDropDown(selectedCategory: nil)
                return
            }
            
            self.parameters?.selectedSubcategoryTitle = nil
            self.parameters?.subcategory = nil
            self.category.text = item
            self.subcategory.text = ""
            self.parameters?.selectedCategoryTitle = item
            
            let selectedCategory = superCateogries?[index-1]
            self.setupSubcategoryDropDown(selectedCategory: selectedCategory)
            self.delegate?.didSelect(category: selectedCategory)
           
        }
        
    }
    
    func setupSubcategoryDropDown(selectedCategory: Category?){
        
        guard let subcategory = selectedCategory else { return }
        
        var items = ["Subcategory".localized]
        let subcategories = subcategory.children
        let titles = subcategories?.compactMap{$0.title!} ?? []
        items.append(contentsOf: titles)
        
        subcategoryDropDown.setData(btn: subcategoryBtn, dataSource: items)
        subcategoryDropDown.selectionAction = {[unowned self](index: Int, item: String) in
            if index == 0 {
                self.subcategory.text = ""
                self.parameters?.selectedSubcategoryTitle = nil
                self.parameters?.subcategory = nil
                self.delegate?.didSelect(subcategory: nil)
                return
            }
            self.subcategory.text = item
            self.parameters?.selectedSubcategoryTitle = item
            let selectedSubcategory = subcategories?[index-1]
            self.delegate?.didSelect(subcategory: selectedSubcategory)
        }
        
    }
    
    
    
    func setupProductAvailabilityDropDown(){
        let ds = ["Yes".localized,"No".localized]
        productAvailablityDropDown.setData(btn: productAvailabilityBtn, dataSource: ds)
        productAvailablityDropDown.selectionAction = {[unowned self](index: Int, item: String) in
            self.productAvailablity.text = item
            self.delegate?.didSelect(productAvailablity: item)
        }
        
    }
    
      //MARK:-  dropdown actions
    @IBAction func productAvailablityBtnTapped(_ sender: UIButton) {
        productAvailablityDropDown.show()
    }
    
    @IBAction func categoryBtnTapped(_ sender: UIButton) {
        categoryDropDown.show()
    }
    
    @IBAction func subcategoryBtnTapped(_ sender: UIButton) {
        subcategoryDropDown.show()
    }
}


 //MARK:-  actions
extension AddProductTopTableViewCell {
    @IBAction func checkBoxBtnTapped(sender: UIButton) {
        self.endEditing(true)
        let result = checkBoxButton.toggle()
        self.parameters?.isOffer = result
        self.productOfferPriceView.isHidden = checkBoxButton.isSelected == true ? false:true
    }
}




//MARK:-  tableview custom delegates
extension AddProductTopTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case productName:
             self.delegate?.didEnter(productName: textField.text!)
        case productPrice:
            self.delegate?.didEnter(productPrice: textField.text!)
        case productStock:
            self.delegate?.didEnter(productStock: textField.text!)
        case productNameAR:
            self.delegate?.didEnter(productNameAR:textField.text!)
        case productOfferPrice:
            self.delegate?.didEnter(productOfferPrice: textField.text!, isOffer: self.parameters?.isOffer ?? false)
        default:
            return
        }
    }
    
}

