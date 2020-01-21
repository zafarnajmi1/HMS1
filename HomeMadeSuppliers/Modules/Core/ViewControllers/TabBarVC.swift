//
//  TabBarVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/21/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Device_swift

class TabBarVC: UITabBarController {
    
    
   
    var tabItems = [
        (imageName:"HomeBlack", title: "Home".localized),
        (imageName:"SuppliersBlack", title: "Suppliers".localized),
        (imageName:"NotificationBlack", title: "Notifications".localized),
        (imageName:"CartBlack", title: "My Cart".localized)
    ]
    
    
    override func viewDidLoad() {
        setupView()
    }
    
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for (index, tab) in tabItems.enumerated() {
            tabBar.items?[index].title = tab.title
        }
        AppLanguage.updateTabBarDirection(self.tabBar)
        setTabBarSelectedItemIndicatorAppearance()
        AddBottomUnsafeAreaColor()
        
    }

    
    func setupView() {
        
        self.navigationController?.navigationBar.isHidden = true
        switch myDefaultAccount {
        case .guest, .seller:
            if tabItems.count > 3 {
                tabItems.remove(at: 3)
                self.viewControllers?.remove(at: 3)
            }
        default:
            print("Buyer account")
        }
        
        setupTabbarAppearance()
        
        
    }
    
    
    fileprivate func insertTabBarItems() {
        var tabbarItem = UITabBarItem()
        
        for (index,item) in tabItems.enumerated() {
            
            tabbarItem = self.tabBar.items![index]
            tabbarItem.image = UIImage(named: item.imageName)
            tabbarItem.title = item.title
            tabbarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -5)
            
        }
    }
    
    func setupTabbarAppearance() {
        
        
        
        // Sets the default color of the icon of the selected UITabBarItem and Title
        tabBar.isTranslucent = false
        UITabBar.appearance().tintColor = UIColor.white
        tabBar.unselectedItemTintColor = .black
        
        // Sets the default color of the background of the UITabBar
        UITabBar.appearance().barTintColor = UIColor.white
        
        
        
        insertTabBarItems()
        
        setBackgroundShadow()
        setSepratorInTabItems()
    }
    
    func setBackgroundShadow()  {
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.2
    }
    
    
    
    func setSepratorInTabItems() {
        guard let items = self.tabBar.items else {
            return
        }
        
        
        //Get the height of the tab bar
        let tabBarHeight = self.tabBar.bounds.size.height
        
        //Calculate the size of the items
        
        let totalItems = CGFloat(items.count)
        let itemWidth = (tabBar.frame.width) / totalItems
        let itemHeight = tabBar.frame.height
        let itemSize = CGSize(width: itemWidth + 1,height: itemHeight)
        
        for (index, _) in items.enumerated() {
            
            //We don't want a separator on the left of the first item.
            
            if index > 0 {
                
                //Xposition of the item
                
                let xPosition = itemSize.width * CGFloat(index)
                
                /* Create UI view at the Xposition,
                 with a width of 0.5 and height equal
                 to the tab bar height, and give the
                 view a background color
                 */
                let separator = UIView(frame: CGRect(
                    x: xPosition - 0.5, y: 0, width: 0.5, height: tabBarHeight))
                separator.backgroundColor = UIColor.lightGray
                tabBar.insertSubview(separator, at: 1)
            }
        }
        
    }
    
    
    
    
    
    func setTabBarSelectedItemIndicatorAppearance() {
        
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
        // set red as selected background color
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = makeImageWithColorAndSize(color: #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1), size: tabBarItemSize)
        
    }
    
    
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        
        let deviceType = UIDevice.current.deviceType
        
        switch deviceType {
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
            UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height - 25))
        case .simulator:
            print("Check other available cases of DeviceType")
            UIRectFill(CGRect(x: 0, y: 0, width: size.width , height: size.height))
        default:
            UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
}


extension UITabBarController {
    func increaseBadge(indexOfTab: Int, num: String?) {
        
        let tabItem = self.tabBar.items![indexOfTab]
        tabItem.badgeValue = num
        tabItem.badgeColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
        
    }
    //self.tabBarController?.increaseBadge(indexOfTab: 3, num: "34")
}



