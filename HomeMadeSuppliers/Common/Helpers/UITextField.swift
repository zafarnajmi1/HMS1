//
//  UITextFeild.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/27/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


extension UITextField {
    
    func addleftPading(_ value : Int = 12){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: value, height: 45))
        leftView = view
        leftViewMode = .always
        
    }
    func addRightPading(_ value : Int = 12){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: value, height: 45))
        rightView = view
        rightViewMode = .always
    }
    func addleftRightPading(left : Int = 12, right: Int = 12){
        addleftPading(left)
        addRightPading(right)
    }

    // Proof of concept, not tested
    
    @IBInspectable var padding: Int{
        get { return 0 }  // maybe use associated objects, you can't add properties in extensions
        set {
           addleftRightPading(left : newValue, right: newValue)
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}





//// 1
//private var maxLengths = [UITextField: Int]()
//
//// 2
//extension UITextField {
//    
//    // 3
//    @IBInspectable var maxLength: Int {
//        get {
//            // 4
//            guard let length = maxLengths[self] else {
//                return Int.max
//            }
//            return length
//        }
//        set {
//            maxLengths[self] = newValue
//            // 5
//            addTarget(
//                self,
//                action: #selector(limitLength),
//                for: UIControl.Event.editingChanged
//            )
//        }
//    }
//    
//    @objc func limitLength(textField: UITextField) {
//        // 6
//        guard let string = textField.text, string.count > maxLength else {
//                return
//        }
//        
//        let selection = selectedTextRange
//        // 7
//        text = string.substringWith(
//            Range<String.Index>(string.index(string.startIndex, offsetBy: 0) ..< string.index(start, offsetBy: maxLength)
//        )
//        selectedTextRange = selection
//    }
//    
//    private func utf16Range(from range: NSRange) -> Range<String.UTF16Index>? {
//        guard range.location != NSNotFound else { return nil }
//        let start = string.index(string.startIndex, offsetBy: range.location)
//        let end = string.index(start, offsetBy: range.length)
//        return start..<end
//    }
//}
