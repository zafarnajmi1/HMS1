//
//  DropDown.swift
//  TailerOnline
//
//  Created by apple on 3/12/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import DropDown

extension DropDown {
    
    func setData(btn: UIButton?, dataSource: [String]){
        guard let btn = btn else { return }
    
        self.semanticContentAttribute = .unspecified
        
        self.anchorView = btn
    
        self.bottomOffset = CGPoint(x: 0, y: btn.bounds.height)
        
        self.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textAlignment = .center
            
        }
        
        self.dataSource = dataSource
        
    }
    
    
    
}



