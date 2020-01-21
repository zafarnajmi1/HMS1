//
//  AddProductConfigurableCheckBoxTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

protocol AddProductConfigurableCheckBoxTableViewCellDelegate: class {
    func didSelectToggle(cell: AddProductConfigurableCheckBoxTableViewCell, indexPath: IndexPath)
}


class AddProductConfigurableCheckBoxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var title : UILabel!
    
    var indexPath: IndexPath!
    var feature: FeatureData?
    var cellDelegate: AddProductConfigurableCheckBoxTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadCell(feature:FeatureData?, indexPath: IndexPath,
                  delegate: AddProductConfigurableCheckBoxTableViewCellDelegate? ) {
        self.cellDelegate = delegate
        self.indexPath = indexPath
        self.feature = feature
        self.title.text = feature?.title ?? "--"
        checkBoxButton.isSelected = self.feature?.isSelected == true ? true:false
    }
    
    
    
    @IBAction func checkBoxBtnTapped(sender: UIButton) {
        self.endEditing(true)
        let result = checkBoxButton.toggle()
        print(result)
        self.cellDelegate?.didSelectToggle(cell: self, indexPath: self.indexPath)
    }
    
    
}
