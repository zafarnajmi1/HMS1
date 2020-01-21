//
//  HeaderCollectionReusableView.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/12/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DropDown

protocol HeaderCollectionReusableViewDelegate: class {
    func didSelect(_ category: Category?)
}


class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dropdownBtn: UIButton!
    @IBOutlet weak var dropDownView: UIView!
    
    @IBOutlet weak var dropdownViewWidth: NSLayoutConstraint!
    
    var delegate: HeaderCollectionReusableViewDelegate?
    
    let categoryDropDown = DropDown()
    var categoryList = [Category]()
   
    func setupDropDown()  {
        let width: CGFloat = (AppSettings.screenWidth / 2) - 18
        dropdownViewWidth.constant = width
        dropDownView.layoutIfNeeded()
        let categories = AppSettings.shared.settingData?.categories
        self.dropDownDataSource(categories)
        self.textField.placeholder = "All Categories".localized
    }
    
    
    
    fileprivate func dropDownDataSource(_ categories: [Category]?) {
        
        let placeholder = "All Categories".localized
        var ds = [placeholder]
        textField.placeholder = placeholder
        
        if let dataSource = categories {
            self.categoryList = dataSource
            let titles = dataSource.compactMap{$0.title}
            ds.append(contentsOf: titles)
        }
        
        categoryDropDown.setData(btn: dropdownBtn, dataSource: ds)
        dropDownActionHandler()
    }
    
    fileprivate func dropDownActionHandler() {
        
        categoryDropDown.selectionAction = {[unowned self](index: Int, item: String) in
            if index == 0 {
                self.textField.text = ""
                self.delegate?.didSelect(nil)
             }
            else {
                let selectedCategory = self.categoryList[index - 1]
                self.textField.text = item
                self.delegate?.didSelect(selectedCategory)
             }
            
        }
    }
    
    
    
    //MARK:-  actions
    @IBAction func DropdownAction(_ sender: UIButton) {
        categoryDropDown.show()
    }
}
