//
//  SelectCityTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/28/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class SelectCityTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var price: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        price.placeholder = myDefaultCurrencySymple + "0.0"
    }

    
    @IBAction func checkBtnTapped(sender: UIButton ) {
        let status = self.checkBtn.toggle()
        if status == false {
            price.text = ""
        }
    }
    
    func  setData(model: City) {
        myTitle.text = model.title
        
        let userSeletedCities = AppSettings.shared.user?.deliverableCities
        
        if let obj = userSeletedCities?.first(where: {$0.city?.title == model.title}) {
              self.checkBtn.isSelected = true
              self.price.text = setDefualtCurrency(price: obj.price).numaric
            
        }
        else {
            checkBtn.isSelected = false
        }
    }
}

extension UIButton {
    
    func toggle() -> Bool  {
        if self.isSelected == true {
            self.isSelected = false
            return false
        }
        else {
            self.isSelected = true
            return true
        }
    }
}
