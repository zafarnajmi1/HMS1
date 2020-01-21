//
//  ViewImageCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/25/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


protocol ViewImageCollectionViewCellDelegate: class {
    func didImageDelete(model: ImageCollection)
    func didMarkAsDefault(model: ImageCollection, index: Int)
}


class ViewImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var tickBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func loadeCell(model: ImageCollection? ) {
        
        if model?.id == nil {
              self.imageView.image = model?.image
        }
        else {
             self.imageView.setPath(image: model?.filePath, placeHolder: AppConstant.placeHolders.product)
        }
        
      
        
        if model?.isDefault == true {
            self.deleteBtn.isHidden = true
            self.tickBtn.backgroundColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
        }
        else {
            self.deleteBtn.isHidden = false
            self.tickBtn.backgroundColor = .gray
        }
    }

}
