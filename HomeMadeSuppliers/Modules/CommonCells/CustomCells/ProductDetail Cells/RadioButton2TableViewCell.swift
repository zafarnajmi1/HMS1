//
//  RadioButton2TableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/14/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DLRadioButton

class RadioButton2TableViewCell: UITableViewCell {
    
    @IBOutlet weak var domesticBtn: DLRadioButton!
    @IBOutlet weak var internationBtn: DLRadioButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        domesticBtn.isSelected = true
    }

    
    @IBAction func internationalBtnTapped (_ sender: UIButton) {
        internationBtn.isSelected = true
        domesticBtn.isSelected = false
        
       
        
    }
    
    @IBAction func domesticBtnTapped (_ sender: UIButton) {
       internationBtn.isSelected = false
       domesticBtn.isSelected = true
       
        
    }
    
   
    
}
