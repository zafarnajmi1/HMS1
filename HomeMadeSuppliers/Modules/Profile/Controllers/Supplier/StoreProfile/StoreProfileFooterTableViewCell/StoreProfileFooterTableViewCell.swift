//
//  StoreProfileFooterTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/24/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class StoreProfileFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var about: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.aboutLabel.text = "About Supplier:".localized
    }

  
    func setData(model: User)  {
    
        about.text = model.descriptionField ?? "--"
        
    }
}
