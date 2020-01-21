//
//  StoreProfileHeaderTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/24/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Cosmos

class StoreProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var ratingValue: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var arriveInLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLocalization()
      myImage.isUserInteractionEnabled = true
    }
    
    private func setLocalization() {
        self.phoneLabel.text = "Phone no:".localized
        self.emailLabel.text = "Email:".localized
        self.arriveInLabel.text = "We Can Arrive In:".localized
    }

    func setData(model: User)  {
      
        let url = model.image?.resizeImage(width: 445, height: 264)
        self.myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.store)
    
        myTitle.text = model.storeName ?? "--"
        address.text = model.address ?? "--"
        phone.text = model.phone ?? "--"
        email.text = model.email ?? "--"
        self.ratingValue.text = "(\(model.averageRating ?? 0))"
        self.ratingStar.rating = model.averageRating ?? 0
        
        myImage.addTapGesture { (gesture) in
            self.showImageVC(singImageURL: model.image)
//            let vc = AppConstant.storyBoard.main.instantiateViewController(withIdentifier: ImagePreviewVC.id) as! ImagePreviewVC
//
//            vc.imageURL = url ?? ""
//            vc.myImage = self.myImage.image
//            vc.modalTransitionStyle = .crossDissolve
//            self.parentVC?.present(vc, animated: true, completion: nil)
        }
    }
    
}
