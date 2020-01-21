//
//  CategoryCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var title : UILabel!
    
    
    func setData(model: Category)  {
        let url = model.image?.resizeImage(width: 100, height: 100)
        myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.product)
        self.title.text =  model.title ?? ""
    }
}
