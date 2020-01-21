//
//  RatingReviewTableViewCell.swift
//  TailerOnline
//
//  Created by apple on 3/12/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Cosmos

class RatingReviewTableViewCell: UITableViewCell {

     //MARK:-  outlets
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myDetail: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var sperator: UIView!
     //MARK:-  my life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }


    func setData(model: Review)  {
       let url = model.user?.image?.resizeImage(width: 200, height: 200)
       myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.user)
       myTitle.text = model.user?.fullName
       myDetail.text = model.comment
        let rating = model.rating ?? 0
       stars.rating = rating
       ratingNumber.text = rating.format1
       timeAgo.text = setTimeAgoFormatBy(dateString: model.createdAt!)
       
    }
    
}
