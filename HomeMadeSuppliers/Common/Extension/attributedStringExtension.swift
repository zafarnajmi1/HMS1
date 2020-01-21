//
//  attributedStringExtension.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/27/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
   
    
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
    }
    
    /* Usage : Example
     
     let label = UILabel()
     label.frame = CGRect(x: 60, y: 100, width: 260, height: 50)
     let stringValue = "stackoverflow"
     
     let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
     attributedString.setColorForText(textForAttribute: "stack", withColor: UIColor.black)
     attributedString.setColorForText(textForAttribute: "over", withColor: UIColor.orange)
     attributedString.setColorForText(textForAttribute: "flow", withColor: UIColor.red)
     label.font = UIFont.boldSystemFont(ofSize: 40)
     
     label.attributedText = attributedString
     self.view.addSubview(label)
     
     */
}

extension String {
    func stringToColor(strValue: String , color: UIColor) -> NSAttributedString {
        
        let range = (self as NSString).range(of: strValue)
        let attributedString = NSMutableAttributedString(string:self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        return attributedString
    }
    
    func colorForText(labels: [String], color: UIColor = UIColor.darkGray) -> NSAttributedString {
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        for label in labels {
            attributedString.setColorForText(textForAttribute: label, withColor: color)
        }
    
        
        return attributedString
    }
}
