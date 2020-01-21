//
//  ButtonTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/29/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn.setTitle("Save".localized, for: .normal)
    }

  
    
}
