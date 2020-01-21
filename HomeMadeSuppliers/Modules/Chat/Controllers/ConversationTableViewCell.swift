//
//  ConversationTableViewCell.swift
//  TailerOnline
//
//  Created by apple on 3/19/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var mySubTitle: UILabel!
    @IBOutlet weak var myDetail: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var deleteButton: LoaderButton!
    
    
    @IBOutlet weak var myTitleTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var subTitleHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        setLocalization()
    }

    func setData(model: Conversation? )  {
    
        guard let conversation = model else{
            print("conversation record not found")
            return
        }
    
        
        
        if let price = conversation.product?.price {
             self.price.text =  setDefualtCurrency(price: price)
             self.myTitle.text = conversation.product?.title
            myTitleTopAnchor.constant = 16
            subTitleHeight.constant = 18
            self.storeImage.isHidden = true
        }
        else {
            myTitleTopAnchor.constant = 24
            subTitleHeight.constant = 0
            self.storeImage.isHidden = false
            self.price.text = ""
        }
        
        switch myDefaultAccount {
            
        case .seller:
            if let product = conversation.product {
                let path = product.image?.resizeImage(width: 200, height: 200)
                self.myImage.setPath(image: path, placeHolder: AppConstant.placeHolders.store)
                self.myTitle.text = product.title ?? " "
                self.mySubTitle.text = conversation.user?.fullName
            }
            else {
                let path = conversation.user?.image?.resizeImage(width: 200, height: 200)
                self.myImage.setPath(image: path, placeHolder: AppConstant.placeHolders.store)
                myTitle.text = conversation.user?.fullName ?? " "
            }
           
            
        case .buyer:
            
            if let product = conversation.product {
                let path = product.image?.resizeImage(width: 200, height: 200)
                self.myImage.setPath(image: path, placeHolder: AppConstant.placeHolders.store)
                self.myTitle.text = product.title ?? " "
                self.mySubTitle.text = conversation.store?.storeName ?? ""
            }
            else {
                let path = conversation.store?.image?.resizeImage(width: 200, height: 200)
                self.myImage.setPath(image: path, placeHolder: AppConstant.placeHolders.store)
                myTitle.text = conversation.store?.storeName ?? " "
                self.mySubTitle.text =  ""
            }
            
        
            
        default:
            
            print("No Account Selected")
        }
        
       
       
        
        
        if let date  = conversation.lastMessage?.createdAt {
            self.timeAgo.text = setTimeAgoFormatBy(dateString: date)
        }
        
        
        if let mimeType = conversation.lastMessage?.mimeType {
            if mimeType == "text" {
                self.myDetail.text = conversation.lastMessage?.content
            }
            else{
                
                self.myDetail.text = "File".localized //conversation.lastMessage?.mimeType
            }
        }
        else {
            self.myDetail.text = "New conversation started".localized
        }
   
    }

}


extension ConversationTableViewCell {
    private func setLocalization() {
        timeAgo.textAlignment = myDefaultLanguage == .ar ? .left:.right
    }
}
