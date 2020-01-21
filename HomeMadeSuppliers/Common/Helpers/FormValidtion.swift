//
//  FormValidtion.swift
//  Baqala
//
//  Created by apple on 2/4/19.
//  Copyright © 2019 My Technology. All rights reserved.
//

import Foundation


func isValid(email: String)->Bool {
   
    let  emailregX =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let  nsValue = NSPredicate(format:"SELF MATCHES %@", emailregX)
    
    return  nsValue.evaluate(with: email)
}

func isvalid(phone: String) -> Bool {
    let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: phone)
    return result
}

extension Array {
    func getElement(at index: Int) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
