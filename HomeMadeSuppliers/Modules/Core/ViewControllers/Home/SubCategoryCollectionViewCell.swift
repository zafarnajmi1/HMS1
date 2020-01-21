//
//  SubcategoryCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class SubcategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title : UILabel!
    
    
    func setData(model: Category)  {
        self.title.text =  model.title ?? ""
    }
}
