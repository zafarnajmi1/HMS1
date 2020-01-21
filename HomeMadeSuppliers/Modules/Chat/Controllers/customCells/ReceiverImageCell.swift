//
//  CellReceiverImage.swift
//  Baqala
//
//  Created by Macbook on 06/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class ReceiverImageCell: UITableViewCell {

    @IBOutlet weak var lblreciverImagetime: UILabel!
    @IBOutlet weak var reciverimage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
        reciverimage.isUserInteractionEnabled = true
        userImage.isUserInteractionEnabled = true
    }

    func setData(message: MessageModel, conversation: Conversation?)  {
        let url = message.content?.resizeImage(width: 400, height: 400)
        reciverimage.setPath(image: url, placeHolder: AppConstant.placeHolders.store)
       
        let user = conversation?.user
        let userURL = user?.image?.resizeImage(width: 100, height: 100)
        userImage.setPath(image: userURL, placeHolder: AppConstant.placeHolders.user)
        
        if let date  = message.createdAt {
            self.lblreciverImagetime.text = setTimeAgoFormatBy(dateString: date)
        }
        self.updateFocusIfNeeded()
        
        reciverimage.addTapGesture { (gesture) in
            self.openImageVC(url: url, image: self.reciverimage.image)
        }
        
        
    }
   

   fileprivate func openImageVC(url: String? , image: UIImage?) {
    self.showImageVC(singImageURL: url)
            
//        let vc = AppConstant.storyBoard.main.instantiateViewController(withIdentifier: ImagePreviewVC.id) as! ImagePreviewVC
//
//        vc.imageURL = url ?? ""
//        vc.myImage = image
//        vc.modalTransitionStyle = .crossDissolve
//        self.parentVC?.present(vc, animated: true, completion: nil)
       
    }
}
