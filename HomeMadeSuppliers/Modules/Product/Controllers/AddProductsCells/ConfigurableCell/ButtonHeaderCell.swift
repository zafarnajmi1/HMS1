//
//  ButtonHeaderCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class ButtonHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setTitle("+ Add Option".localized, for: .normal)
    }
}
