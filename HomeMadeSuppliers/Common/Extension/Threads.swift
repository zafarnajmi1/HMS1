//
//  Threads.swift
//  Delivigo
//
//  Created by Muhammad Naveed on 9/9/18.
//  Copyright © 2018 Muhammad Naveed. All rights reserved.
//

import Foundation
import UIKit

public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}
/*
 1: sleep(4)
 print("done")//Do stuff here
 2:handyswift
 
 delay(bySeconds: 1.5, dispatchLevel: .background) {
 // delayed code that will run on background thread
 }
 Delaying code on the main thread is even simpler:
 
 delay(bySeconds: 1.5) {
 // delayed code, by default run in main thread
 }*/
