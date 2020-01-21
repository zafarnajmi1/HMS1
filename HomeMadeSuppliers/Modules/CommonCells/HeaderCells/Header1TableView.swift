//
//  Header1TableView.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/12/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class Header1TableView: UITableViewHeaderFooterView {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(title: String) {
        self.title.text = title
    }
}
