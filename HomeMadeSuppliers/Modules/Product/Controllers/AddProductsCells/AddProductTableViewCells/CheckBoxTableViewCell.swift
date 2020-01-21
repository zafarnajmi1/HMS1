//
//  CheckBoxTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/25/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

protocol CheckBoxTableViewCellDelegate: class {
    func didSelectToggle(cell: CheckBoxTableViewCell,indexPath:IndexPath)
}


class CheckBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var title : UILabel!
    
    var indexPath: IndexPath!
    var feature: FeatureData?
    var charateristic: Characteristic2?
    var checkBoxDelegate: CheckBoxTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   

    func loadCell(feature: FeatureData?, indexPath: IndexPath) {
        self.feature = feature
        self.indexPath = indexPath
        charateristic = feature?.characteristics?[indexPath.row]
        self.title.text = charateristic?.title ?? "--"
        checkBoxButton.isSelected = charateristic?.isSelected == true ? true:false
    }
    
    
    
    @IBAction func checkBoxBtnTapped(sender: UIButton) {
        self.endEditing(true)
        let result = checkBoxButton.toggle()
        print(result)
        self.checkBoxDelegate?.didSelectToggle(cell: self, indexPath: indexPath)
    }
    
}

