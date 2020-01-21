//
//  MenuTableViewCell.swift
//  TailerOnline
//
//  Created by apple on 3/7/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


protocol MenuHeaderTableViewCellDelegate: class {
    func headerBtnTapped()
}

class MenuHeaderTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var myImageBg: UIImageView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var headerBtn: UIButton!
    
    var delegate : MenuHeaderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        name.text = "Profile"
       
    }
    
    func setData(model: User?, _ delegate: MenuHeaderTableViewCellDelegate? ) {
        self.delegate = delegate
        
        let url = model?.image?.resizeImage(width: 300, height: 300)
        
        
        switch myDefaultAccount {
        case .buyer:
            let userName = "\(model?.firstName ?? "") \(model?.lastName ?? "")"
            name.text = userName
            email.text = model?.email ?? " "
          
            myImage.setPath(image: url, placeHolder: AppConstant.placeHolders.user)
            headerBtn.isEnabled = false
        case .seller:
            name.text =  model?.storeName ?? " "
            email.text = model?.email ?? " "
            myImage.setPath(image:url, placeHolder: AppConstant.placeHolders.store)
            headerBtn.isEnabled = false
        default: //guest
            myImage.image = UIImage(named: AppConstant.placeHolders.store)
            name.text = "Guest user".localized
            email.text = "Please login".localized
            headerBtn.isEnabled = true
           
        }
    }
    
    @IBAction func menuHeaderBtnTapper(_ sender: UIButton) {
        
          self.delegate?.headerBtnTapped()
      }
    
}
