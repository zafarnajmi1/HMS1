//
//  PaymentTypeTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/24/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class PaymentTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var payementMethod: UILabel!
    @IBOutlet weak var notesLable: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }

    private func setLocalization () {
        self.paymentMethodLabel.text = "Payement Method:".localized
        self.notesLable.text = "Notes:".localized
    }
    
    func setData(model: OrderDetail?)  {
        guard let orderDetail = model else { return }
        let payement = orderDetail.order?.paymentMethod ?? ""
        
        switch payement {
        case "cashOnDelivery":
            payementMethod.text = "Cash On Delivery".localized
        case "paypal":
             payementMethod.text = "PayPal".localized
        default:
            payementMethod.text = ""
        }
     
        notes.text = orderDetail.order?.orderNote ?? "--"
    }
}
