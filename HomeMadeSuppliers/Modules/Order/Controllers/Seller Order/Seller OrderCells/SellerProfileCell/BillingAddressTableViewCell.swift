//
//  BillingAddressTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/24/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class BillingAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  
    func setData(model: Address?) {
        let postFix = "Address:".localized
        let addressType = "\(model?.addressType?.capitalized.localized ?? "") \(postFix)"
        self.title.text = addressType
        self.name.text = "\(model?.firstName ?? "") \(model?.lastName ?? "")"
        self.email.text = model?.email ?? ""
        self.phone.text = model?.phone ?? ""
        
        let addresses = "\(model?.address1 ?? "")\n\(model?.address2 ?? "")"
        self.address.text = addresses
    }
}
