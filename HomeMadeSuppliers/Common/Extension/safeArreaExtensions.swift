//
//  safeArreaExtensions.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/22/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

extension UIViewController {
    func AddBottomUnsafeAreaColor(){
        let window = UIApplication.shared.keyWindow
        let bottomPadding : CGFloat = window?.safeAreaInsets.bottom ?? 0
        let screenFrame = UIScreen.main.bounds
        let bottomView = UIView(frame: CGRect(x: 0, y: screenFrame.height-bottomPadding, width: screenFrame.width, height: bottomPadding))
        bottomView.backgroundColor = #colorLiteral(red: 0.9566419721, green: 0.9607869983, blue: 0.9647976756, alpha: 1)
        view.addSubview(bottomView)
    }
}
