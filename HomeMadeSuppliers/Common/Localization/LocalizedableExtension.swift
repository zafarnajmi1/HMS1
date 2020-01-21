//
//  LocalizaedableExtension.swift
//  Baqala
//
//  Created by Macbook on 12/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    var localized: String {
    
        let path = Bundle.main.path(forResource: myDefaultLanguage.rawValue, ofType: "lproj")
        let bundle = Bundle(path: path!)
       
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}


class AppLanguage {
   
    static func updateUIScreenDirection()  {
        switch myDefaultLanguage.rawValue {
        case "ar":
            UIView.appearance().semanticContentAttribute = .forceRightToLeft //ar
            UITableViewCell.appearance().semanticContentAttribute = .forceRightToLeft
            UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
            UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
        default: // .en
            UIView.appearance().semanticContentAttribute = .forceLeftToRight //en
            UITableViewCell.appearance().semanticContentAttribute = .forceLeftToRight
            UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
            UITabBar.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    static func updateLabelsDirection(_ labels: [UILabel])  {
        
        switch myDefaultLanguage.rawValue {
        case "ar":
            for label in labels {
                label.textAlignment = .right
            }
        default: // .en
            for label in labels {
                label.textAlignment = .left
            }
        }
    }
    
    static func updateTextFieldsDirection(_ textFields: [UITextField])  {
        
        switch myDefaultLanguage.rawValue {
        case "ar":
            for tf in textFields {
                tf.textAlignment = .right
            }
        default: // .en
            for tf in textFields {
                tf.textAlignment = .left
            }
        }
    }
    
    static func updateTextViewsDirection(_ textViews: [UITextView])  {
        
        switch myDefaultLanguage.rawValue {
        case "ar":
            for tf in textViews {
                tf.textAlignment = .right
            }
        default: // .en
            for tf in textViews {
                tf.textAlignment = .left
            }
        }
    }
    
    static func updateNavigationBarSementic(vc: UIViewController) {
        
        if myDefaultLanguage == .ar {
        vc.navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
        vc.navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
    }
    
    static func updateTabBarDirection(_ tabBar: UITabBar)  {
        switch myDefaultLanguage.rawValue {
        case "ar":
            tabBar.semanticContentAttribute = .forceRightToLeft
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        default: // .en
            UIView.appearance().semanticContentAttribute = .forceLeftToRight //en
            tabBar.semanticContentAttribute = .forceLeftToRight
        }
    }
}



extension UIViewController {
   
    func setViewDirectionByLanguage()  {
        
        switch myDefaultLanguage.rawValue {
        case "ar":
             UIView.appearance().semanticContentAttribute = .forceRightToLeft //ar
             UITableViewCell.appearance().semanticContentAttribute = .forceRightToLeft
        default: // .en
             UIView.appearance().semanticContentAttribute = .forceLeftToRight //en
             UITableViewCell.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    func setTextFieldDirectionByLanguage(textFields: [UITextField])  {
        
        switch myDefaultLanguage.rawValue {
        case "ar":
            for tf in textFields {
                tf.textAlignment = .right
            }
            UIView.appearance().semanticContentAttribute = .forceRightToLeft //ar
            UITableViewCell.appearance().semanticContentAttribute = .forceRightToLeft
            
        default: // .en
           
            for tf in textFields {
                tf.textAlignment = .left
            }
            
            UIView.appearance().semanticContentAttribute = .forceLeftToRight //en
            UITableViewCell.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    func setTextViewDirectionByLanguage(textViews: [UITextView])  {
        
        switch myDefaultLanguage.rawValue {
        case "ar":
            for tf in textViews {
                tf.textAlignment = .right
            }
            
            UIView.appearance().semanticContentAttribute = .forceLeftToRight //en
            UITableViewCell.appearance().semanticContentAttribute = .forceLeftToRight
        default: // .en
            for tf in textViews {
                tf.textAlignment = .left
            }
            UIView.appearance().semanticContentAttribute = .forceLeftToRight //en
            UITableViewCell.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    func setLabelDirectionByLanguage(Labels: [UILabel])  {
        
        switch myDefaultLanguage.rawValue {
        case "ar":
            for label in Labels {
                label.textAlignment = .right
            }
        default: // .en
            for label in Labels {
                label.textAlignment = .left
            }
        }
    }
}

extension UITableViewCell {
   
    func setViewDirectionByLanguage()  {
       
        switch myDefaultLanguage.rawValue {
        case "ar":
            UIView.appearance().semanticContentAttribute = .forceRightToLeft //ar
            UITableViewCell.appearance().semanticContentAttribute = .forceRightToLeft
        default: // .en
            UIView.appearance().semanticContentAttribute = .forceLeftToRight //en
            UITableViewCell.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    func setTextFieldDirectionByLanguage(textFields: [UITextField])  {
       
        switch myDefaultLanguage.rawValue {
        case "ar":
            for tf in textFields {
                tf.textAlignment = .right
            }
        default: // .en
            for tf in textFields {
                tf.textAlignment = .left
            }
        }
    }
    
    func setLabelDirectionByLanguage(Labels: [UILabel])  {
        
        switch myDefaultLanguage.rawValue {
        case "ar":
            for label in Labels {
                label.textAlignment = .right
            }
        default: // .en
            for label in Labels {
                label.textAlignment = .left
            }
        }
     
    }
    
    func setTextViewDirectionByLanguage(textViews: [UITextView])  {
       
        switch myDefaultLanguage.rawValue {
        case "ar":
            for tf in textViews {
                tf.textAlignment = .right
            }
        default: // .en
            for tf in textViews {
                tf.textAlignment = .left
            }
        }
    }
}
