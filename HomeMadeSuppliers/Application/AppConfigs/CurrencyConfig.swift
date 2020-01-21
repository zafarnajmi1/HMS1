//
//  CurrencyConfig.swift
//  TailerOnline
//
//  Created by apple on 3/12/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//


import Foundation


enum currencyType:String {
    case usd
    case aed
}
//selected default
var myDefaultCurrency = currencyType.aed


var myDefaultCurrencySymple: String {
    get {
        switch myDefaultCurrency {
        case .usd:
            return "$"
        default: //.aed
            return "AED"
        }
    }
}

func setDefualtCurrency(price: Price?) -> String {
    guard let myPrice = price else { return "" }
    
    switch myDefaultCurrency {
    case .usd:
        let currency = myPrice.usd!
        let symbole = currency.symbol ?? "symbole"
        let formatedAmount = currency.formatedAmount ?? "--"
        return "\(symbole)\(formatedAmount)"
    
    default: // aed
        let currency = myPrice.aed!
        let symbole = currency.symbol ?? "symbole"
        let formatedAmount = currency.formatedAmount ?? "--"
        return "\(symbole)\(formatedAmount)"
    }
}




func setAedCurrency(price: Price?) -> String {
    guard let myPrice = price else { return "" }

        let currency = myPrice.aed!
        let symbole = currency.symbol ?? "symbole"
        let formatedAmount = currency.formatedAmount ?? "--"
        return "\(symbole)\(formatedAmount)"
    
}





//func setDefaultCurrency(body : Price)-> String  {
//    let result = myDefaultCurrency == .usd ? "$\(body.usdS ?? "")":"AED\(body.aedS ?? "")"
//    return result
//}
//
//func setDefaultCurrency(body : GrandTotal)-> String  {
//    let result = myDefaultCurrency == .usd ? "$\(body.usd ?? 0)":"AED\(body.aed ?? 0)"
//    return result
//}

//func setDefaultAmount(body : GrandTotal)-> String  {
//    let result = myDefaultCurrency == .usd ? "\(body.usd ?? 0)":"\(body.aed ?? 0)"
//    return result
//}
//
//func setDefaultCurrency(price : Float)-> String  {
//    let formatted = String(format: "%.1f", price)
//    let result = myDefaultCurrency == .usd ? "$\(formatted )":"AED\(formatted)"
//
//    return result
//}
//func setDefaultCurrency(price : Double)-> String  {
//    let formatted = String(format: "%.1f", price)
//    let result = myDefaultCurrency == .usd ? "$\(formatted )":"AED\(formatted)"
//
//    return result
//}

//func setDefaultCurrency(body : PriceInt)-> String  {
//    let result = myDefaultCurrency == .usd ? "$\(body.usd ?? 0)":"AED\(body.aed ?? 0)"
//    return result
//}

//func setDefaultCurrency(price : Double)-> String  {
//    let formatted = String(format: "%.1f", price)
//    let result = myDefaultCurrency == .usd ? "$ \(formatted )":"AED \(formatted)"
//
//    return result
//}



func setRating (body: Float) -> String {
    let formatted = String(format: "%.1f", body)
    return formatted
}

//
//extension Double {
//    /// Convert `Double` to `Decimal`, rounding it to `scale` decimal places.
//    ///
//    /// - Parameters:
//    ///   - scale: How many decimal places to round to. Defaults to `0`.
//    ///   - mode:  The preferred rounding mode. Defaults to `.plain`.
//    /// - Returns: The rounded `Decimal` value.
//
//    func roundedDecimal(to scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
//        var decimalValue = Decimal(self)
//        var result = Decimal()
//        NSDecimalRound(&result, &decimalValue, scale, mode)
//        return result
//    }
//
//    func roundedDecimal(to scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) -> String {
//        var decimalValue = Decimal(self)
//        var result = Decimal()
//        NSDecimalRound(&result, &decimalValue, scale, mode)
//
//        return "\(result)"
//    }
//}
