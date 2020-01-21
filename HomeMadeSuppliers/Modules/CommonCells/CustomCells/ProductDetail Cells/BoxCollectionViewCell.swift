//
//  BoxCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/13/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class BoxCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containterView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(label: String ) {
        self.label.text = label
    }
    
    
    
}
