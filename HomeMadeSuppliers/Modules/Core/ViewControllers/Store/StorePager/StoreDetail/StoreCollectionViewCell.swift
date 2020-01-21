//
//  StoreCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/15/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Cosmos
class StoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myDetail: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!

    var isStoreDetailPage: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(model: Store)  {
        
        let url = model.image?.resizeImage(width: 445, height: 264)
        self.myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.store)
        self.myTitle.text = model.storeName ?? ""
        self.myDetail.text = model.addressExchange ?? ""
        let rating = Double(model.averageRating ?? 0)
        self.ratingNumber.text = rating.format1
        self.ratingStar.rating = rating
       
        
        if model.isBusy {
            let status = "(\(model.availabilitySetting?.capitalized.localized ?? ""))"
            let string = "\(model.storeName ?? "") \(status)"
            self.myTitle.attributedText = string.stringToColor(strValue: status, color: #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1))
        }
        
       
        myImage.addTapGesture { (gesture) in

             self.showImageVC(singImageURL: model.image)
      
            
//            let vc = AppConstant.storyBoard.main.instantiateViewController(withIdentifier: ImagePreviewVC.id) as! ImagePreviewVC
//
//            vc.imageURL = model.image ?? ""
//            vc.myImage = self.myImage.image
//            vc.modalTransitionStyle = .crossDissolve
//            self.parentVC?.present(vc, animated: true, completion: nil)
//            print("echo")
        }
    }
    
    
   
}


