//
//  EmptyTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/29/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
