//
//  CellSenderMessage.swift
//  Baqala
//
//  Created by Macbook on 06/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class SenderMessageCell: UITableViewCell {

    @IBOutlet weak var lblsenderMessage: UILabel!
    @IBOutlet weak var lblsenderTime: UILabel!
    @IBOutlet weak var deleteBtn: LoaderButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
    }

    func setData(message: MessageModel)  {
        
        lblsenderMessage.text = message.content
        if let date = message.createdAt {
            lblsenderTime.text = setTimeAgoFormatBy(dateString: date)
        }
        
        self.updateConstraintsIfNeeded()
    }

}
