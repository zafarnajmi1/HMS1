//
//  DropDownView.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DropDown


protocol DropDownViewDelegate: class {
    func didSelectToggle(cell: DropDownView)
}



class DropDownView: UIView {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var Label: UILabel!
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "DropDownView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
   //accessable
   
    var combinationFeature: FeatureData?
    var configuration : Configuration?
    
    // class variables
    let featureDropDown = DropDown()
    private var delegate: DropDownViewDelegate?
    private var list = [Characteristic2]()
   
    
    func loadCell(configuration: Configuration? ,combinationFeature: FeatureData?, delegate: DropDownViewDelegate?) {

        
       
        self.delegate = delegate
       
        self.configuration = configuration
        self.combinationFeature = combinationFeature
      
        guard let feature = self.combinationFeature else {
            nvMessage.showError(body: "Feature object not found".localized)
            return
        }
        
        self.Label.text = feature.title ?? " "
       
        if let charteristic = feature.characteristics?.filter({$0.isSelected == true}).first {
            self.textField.text = charteristic.title ?? ""
        }
        else {
            self.textField.placeholder = feature.title ?? ""
        }
        
        
      

 
        //self.selectedFeature = object
        self.dropDownDataSource(feature)
    }
    
    

    
    
    fileprivate func dropDownDataSource(_ feature: FeatureData?) {
       
        let prefix = "Select".localized
        let placeHolder =  "\(prefix) \(feature?.title ?? "")"
       // self.textField.placeholder = placeHolder
      
        var characteristics: [Characteristic2]?
        characteristics = feature?.characteristics
        
        var ds = [placeHolder]
       
        
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
//                for char in self.combinationFeature?.characteristics ?? [] {
//                    char.isSelected = false
//                }
                self.combinationFeature?.characteristics?.forEach({$0.isSelected = false})
             
                self.delegate?.didSelectToggle(cell: self)
                
            }
            else {
                self.combinationFeature?.characteristics?.forEach({$0.isSelected = false})
                self.combinationFeature?.characteristics?[index - 1].isSelected = true
                self.textField.text = item
                self.delegate?.didSelectToggle(cell: self)
            }
            
        }
    }
    
    
    
    
    //MARK:-  actions
    @IBAction func DropdownAction(_ sender: UIButton) {
        featureDropDown.show()
        
    }
}

