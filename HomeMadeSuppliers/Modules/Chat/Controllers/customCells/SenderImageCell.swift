//
//  SenderImageCell.swift
//  Baqala
//
//  Created by Macbook on 06/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class SenderImageCell: UITableViewCell {

    @IBOutlet weak var lblsenderimageTime: UILabel!
    @IBOutlet weak var senderimage: UIImageView!
    @IBOutlet weak var deleteBtn: LoaderButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
        senderimage.isUserInteractionEnabled = true
    }

    func setData(message: MessageModel)  {
        
        let url = message.content?.resizeImage(width: 400, height: 400)
        senderimage.setPath(image: url, placeHolder: AppConstant.placeHolders.store)
        if let date = message.createdAt {
            self.lblsenderimageTime.text = setTimeAgoFormatBy(dateString: date)
        }
        self.updateConstraintsIfNeeded()
        
        
        senderimage.addTapGesture { (gesture) in
            self.showImageVC(singImageURL: message.content)
//            let vc = AppConstant.storyBoard.main.instantiateViewController(withIdentifier: ImagePreviewVC.id) as! ImagePreviewVC
//
//            vc.imageURL = url ?? ""
//            vc.myImage = self.senderimage.image
//            vc.modalTransitionStyle = .crossDissolve
//            self.parentVC?.present(vc, animated: true, completion: nil)
        }
        
        
    }
   

}
