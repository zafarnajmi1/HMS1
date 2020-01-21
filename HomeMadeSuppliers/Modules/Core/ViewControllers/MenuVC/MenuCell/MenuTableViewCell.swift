//
//  MenuTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/21/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    
    //MARK:-  outlet
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:-  data intialization
    func  setData(model: MenuModel) {
        self.myTitle.text = model.name
        self.myImage.image = UIImage(named: model.image)
    }
    
}
