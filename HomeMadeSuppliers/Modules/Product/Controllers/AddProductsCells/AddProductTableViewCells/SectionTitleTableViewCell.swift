//
//  SectionTitleTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/22/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class SectionTitleTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = "Atrributes".localized
    }

    
    
}
