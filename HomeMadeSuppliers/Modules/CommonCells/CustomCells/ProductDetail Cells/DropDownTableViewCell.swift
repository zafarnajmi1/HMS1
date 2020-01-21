//
//  DropDownTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/13/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DropDown

class DropDownTableViewCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var Label: UILabel!
    
    // class variables
    let featureDropDown = DropDown()
    private var list = [Characteristic1]()
    private var priceable: Priceable1?
    
    private var selectedCharacteristic: Characteristic1?
    
    //accessable
    var selectedOptionId: String?
    var delegate: FeatureCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         setLocalization()
    }
    
    
    func setData(priceable: Priceable1? ,_ delegate: FeatureCollectionViewCellDelegate) {
        self.priceable = priceable
        self.delegate = delegate
        self.dropDownDataSource(priceable?.characteristics)
        let prefix = "Select".localized
        self.Label.text = "\(prefix) \(priceable?.feature?.title ?? "Feature".localized)"
        self.textField.text = ""
        
        if let selectedIndex = priceable?.selectedIndex {
            self.selectedCharacteristic = priceable?.characteristics?[selectedIndex]
            self.textField.text = self.selectedCharacteristic?.title ?? ""
            self.selectedOptionId = self.selectedCharacteristic?.id
        }
        
      
        
    }
    
    
    
    fileprivate func dropDownDataSource(_ characteristics: [Characteristic1]?) {
        
        let placeholder = "Select".localized
        var ds = [placeholder]
        textField.placeholder = placeholder
        
        if let dataSource = characteristics {
            self.list = dataSource
            let titles = dataSource.compactMap{$0.title}
            ds.append(contentsOf: titles)
        }
        
        featureDropDown.setData(btn: btn, dataSource: ds)
        dropDownActionHandler()
    }
    
    fileprivate func dropDownActionHandler() {
        
        featureDropDown.selectionAction = {[unowned self](index: Int, item: String) in
            if index == 0 {
                self.textField.text = ""
                self.selectedCharacteristic = nil
                self.selectedOptionId = nil
                self.priceable?.selectedIndex = nil
                self.delegate?.didSelectedItem(characteristic: nil, self.priceable, index)
                
            }
            else {
                self.selectedCharacteristic = self.list[index - 1]
                self.textField.text = item
                self.selectedOptionId = self.selectedCharacteristic?.id
                self.delegate?.didSelectedItem(characteristic: self.selectedCharacteristic, self.priceable, index-1)
            }
            
        }
    }
    
    
    
    
    //MARK:-  actions
    @IBAction func DropdownAction(_ sender: UIButton) {
        featureDropDown.show()
    }
    
}

extension DropDownTableViewCell {
    func setLocalization () {
        AppLanguage.updateTextFieldsDirection([textField])
    }
}
