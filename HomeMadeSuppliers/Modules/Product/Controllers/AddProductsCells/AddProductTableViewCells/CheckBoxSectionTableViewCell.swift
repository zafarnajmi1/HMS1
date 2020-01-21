//
//  CheckBoxSectionTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/25/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

protocol CheckBoxSectionTableViewCellDelegate: class {
    func didSelectToggle(header: CheckBoxSectionTableViewCell ,section:Int)
}


class CheckBoxSectionTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var title : UILabel!
    
    var section: Int!
    var feature: FeatureData?
    var checkBoxDelegate: CheckBoxSectionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadHeader(feature:FeatureData?, section: Int) {
        self.section = section
        self.feature = feature
        self.title.text = feature?.title ?? "--"
        checkBoxButton.isSelected = self.feature?.isSelected == true ? true:false
    }
    
  
    
    @IBAction func checkBoxBtnTapped(sender: UIButton) {
        self.endEditing(true)
        let result = checkBoxButton.toggle()
        print(result)
        self.checkBoxDelegate?.didSelectToggle(header: self, section: section)
    }

    
}
