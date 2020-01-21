//
//  StoreTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/29/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Cosmos

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myDetail: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(model: Store)  {
        let url = model.image?.resizeImage(width: 445, height: 264)
        self.myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.store)
        self.myTitle.text = model.storeName ?? ""
        self.myDetail.text = model.addressExchange ?? ""
        let rating = model.averageRating ?? 0
        self.ratingNumber.text = rating.format1
        self.ratingStar.rating = rating
        if model.isBusy {
            let status = "(\(model.availabilitySetting?.capitalized.localized ?? ""))"
            let string = "\(model.storeName ?? "") \(status)"
            self.myTitle.attributedText = string.stringToColor(strValue: status, color: #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1))
        }
    }
    
}

