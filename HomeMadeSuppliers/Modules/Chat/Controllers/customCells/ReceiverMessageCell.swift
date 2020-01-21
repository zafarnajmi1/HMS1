//
//  ReceiverMessageCell.swift
//  Baqala
//
//  Created by Macbook on 06/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class ReceiverMessageCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
    }

    override func layoutSubviews() {
       
    }
   
    func setData(message: MessageModel, _ conversation: Conversation?)  {
        
        content.text = message.content
        if let date = message.createdAt {
            timeAgo.text = setTimeAgoFormatBy(dateString: date)
        }
        let user = conversation?.user
        let url = user?.image?.resizeImage(width: 100, height: 100)
        myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.user)
        
        self.updateConstraintsIfNeeded()
    }
}
