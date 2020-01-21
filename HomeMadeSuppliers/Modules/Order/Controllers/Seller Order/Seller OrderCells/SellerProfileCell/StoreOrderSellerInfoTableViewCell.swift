//
//  StoreOrderSellerInfoTableViewCell.swift
//  Baqala
//
//  Created by apple on 12/4/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class StoreOrderSellerInfoTableViewCell: UITableViewCell {

    //MARK:- outlets
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
   
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    private var delegate: CallBackDelegate?
    private var orderDetailId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        // Initialization code
        
    }
    
   
    //MARK:- base initialization
    
    func setData(model: OrderDetail, _ delegate: CallBackDelegate)  {
        self.orderDetailId = model.id
        self.delegate = delegate
        let user = model.user
    
        self.myImage.setPath(image: user?.image?.resizeImage(width: 200, height: 200),
                             placeHolder: AppConstant.placeHolders.user)
        
        self.userName.text = user?.fullName ?? ""
        self.email.text = user?.email ?? ""
        self.phone.text = user?.phone ?? ""
       
        self.cancelBtn.setTitle( "Cancel".localized , for: .normal)
        
        
        
       // let paymentMethod = model.order?.paymentMethod?.lowercased()
        let status = model.status?.lowercased()
        
        if  status == "confirmed" {
            cancelBtn.isHidden = false
        } else {
            cancelBtn.isHidden = true
        }
        
        
         //MARK:-  action
        cancelBtn.onTap {
            
            self.parentVC?.presentAlert(message: "Do you want to cancel this order?".localized, yes: {
                 self.requestToCancelOrder()
            }, no: nil)
            
        }
    }
    
    
    
    func requestToCancelOrder()  {
        guard let id = orderDetailId else {
            nvMessage.showError(body: "Order Detail id not found".localized)
            return
        }
        
        cancelBtn.showLoader(true)
        OrderManager.shared.cancelOrder(id: id) { (result) in
            self.cancelBtn.showLoader(false)
            
            switch result {
                
            case .sucess(let root):
                let title = "Order Detail".localized
                
                nvMessage.showSuccess(title: title, body: root.message ?? "", closure: {
                      self.cancelBtn.isHidden = true
                      self.delegate?.reloadData()
                })
               
              
            case .failure(let error):
                nvMessage.showError(body: error)
                
            }
        }
    }
}
