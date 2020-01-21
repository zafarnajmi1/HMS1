//
//  ThemeSetup.swift
//  TailerOnline
//
//  Created by apple on 3/1/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit




enum Theme: Int {
    
    case myDefault
    
    var primaryColor: UIColor {
        switch self {
        case .myDefault:
            return #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
        }
    }
    
    
    //Customizing the Navigation Bar
    var barStyle: UIBarStyle {
        switch self {
        case .myDefault:
            return .blackTranslucent
        }
    }
    

    
    var backgroundColor: UIColor {
        switch self {
        case .myDefault:
              return .green
        
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .myDefault:
            return .green
        }
    }
    
   
    
    
    //MARK: - Statusr Bar
    var statusBarBgColor: UIColor {
        switch self {
        case .myDefault:
            return #colorLiteral(red: 0.6784566045, green: 0.005774720572, blue: 0.00143332174, alpha: 1)
        }
    }
    
    //MARK: - Statusr Bar
    var navigationBarBgColor: UIColor {
        switch self {
        case .myDefault:
            return #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
        }
    }
    
}



var myDefaultTheme = Theme.myDefault
