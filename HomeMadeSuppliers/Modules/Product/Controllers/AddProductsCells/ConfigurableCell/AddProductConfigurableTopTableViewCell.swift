//
//  AddProductConfigurableTopTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DropDown


protocol AddProductConfigurableTopTableViewCellDelegate: class {
    func didSelect(category: Category?)
    func didSelect(subcategory: Category?)
    func didEnter(productName: String?)
    func didEnter(productNameAR: String?)
}



class AddProductConfigurableTopTableViewCell: UITableViewCell {

    //MARK:-  outlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productNameARLabel: UILabel!
    
    
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var subcategoryBtn: UIButton!
    
    @IBOutlet weak var category : UITextField!
    @IBOutlet weak var subcategory : UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productNameEnView: UIView!
    @IBOutlet weak var productNameAR: UITextField!
    @IBOutlet weak var productNameARView: UIView!
    
    @IBOutlet weak var productAvailabiltyDownArrowPinWidth: NSLayoutConstraint!
    
    // class variables
    private let categoryDropDown = DropDown()
    private let subcategoryDropDown = DropDown()
  
    
    private var categories = [Category]()
    private var subcategories = [Category]()
    private var parameters: ConfigProductParameters?
    
    // var selectedCategory: Category?
    // var selectedSubcategory: Category?
    
    var delegate: AddProductConfigurableTopTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLocalization()
        self.productName.delegate =  self
        self.productNameAR.delegate = self
    }
    
    func loadCell(productType: ProductType ,
                  product: ConfigProductParameters?,
                  delegate:  AddProductConfigurableTopTableViewCellDelegate?,
                  isEditProduct: Bool = false, localeType: LocaleType = .en )  {
       //setter
        self.delegate = delegate
        self.parameters = product
        
        setupDropDrowns()
        
        //update textfields
        if let product = self.parameters {
            self.productName.text = product.titleEn
            self.category.text = product.selectedCategoryTitle
            self.subcategory.text = product.selectedSubcategoryTitle
            self.productNameAR.text = product.titleAr
           
        }
        

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
        
        
        //self.productNameARView.isHidden = isEditProduct == true ? false:true
    }
    
    
    func setupDropDrowns() {
        setupCategoryDropDown()
        setupSubcategoryDropDown(selectedCategory: nil)
     }
}

 //MARK:-  localization
private extension AddProductConfigurableTopTableViewCell {
    private func setLocalization() {
        self.categoryLabel.text = "Select Category".localized
        self.subcategoryLabel.text = "Select Subcategory".localized
        self.productNameLabel.text = "Product Name".localized
        self.productNameARLabel.text = "Product Name (Arabic)".localizedCapitalized
        self.category.placeholder = "Category".localized
        self.subcategory.placeholder = "Subcategory".localized
        self.productName.placeholder = "Product Name".localized
        self.productNameAR.placeholder = "Product Name (Arabic)".localized
        
        AppLanguage.updateTextFieldsDirection([
            category, subcategory, productName, productNameAR
        ])
    }
}



//MARK:-  setup drownDowns
extension AddProductConfigurableTopTableViewCell {
    
    
    
    
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
    
    
    
   
    //MARK:-  dropdown actions
    
    @IBAction func categoryBtnTapped(_ sender: UIButton) {
        self.endEditing(true)
        categoryDropDown.show()
    }
    
    @IBAction func subcategoryBtnTapped(_ sender: UIButton) {
        self.endEditing(true)
        subcategoryDropDown.show()
      
    }
}


//MARK:-  tableview custom delegates
extension AddProductConfigurableTopTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case productName:
            self.delegate?.didEnter(productName: textField.text!)
        case productNameAR:
            self.delegate?.didEnter(productNameAR: textField.text!)
        default:
            return
        }
    }
    
}


