//
//  NotificationTableViewCell.swift
//  TailerOnline
//
//  Created by apple on 3/11/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    //MARK:-  outlet
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var mySubtitle: UILabel!
    @IBOutlet weak var unseenView: UIView!
    @IBOutlet weak var removeBtn: UIButton!
    
    //MARK:- Properties
    var sharedViewController: UIViewController?
    
     //MARK:- my lfie cycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
        if myDefaultLanguage == .ar {
            UITableView.appearance().semanticContentAttribute = .forceRightToLeft
          }else{
           UITableView.appearance().semanticContentAttribute = .forceLeftToRight
          }
    }
    
    //MARK:-  Initialization code
    func  setData(model: NotificationModel)  {
        myTitle.text = model.title ?? "--"
        mySubtitle.text = model.descriptionField ?? "--"
        let url = model.sender?.image?.resizeImage(width: 400, height: 400)
        myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.user)
        timeAgo.text  = setTimeAgoFormatBy(dateString: model.createdAt!)
        
        
        if model.seen == true {
            unseenView.isHidden = true
        }
        else {
            unseenView.isHidden = true
        }
    }
    
}
