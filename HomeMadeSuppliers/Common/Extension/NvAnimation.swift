//
//  NvAnimation.swift
//  TailerOnline
//
//  Created by apple on 3/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation
import ViewAnimator
import UIKit

extension UIView {
    
    func zoomAnimate() {
        self.isHidden = true
        delay(bySeconds: 0.2) {
            self.isHidden = false
            let animation = AnimationType.zoom(scale: 0.5)
            self.animate(animations: [animation])
        }
       
       
    }
    func zoomAnimateBtn() {
        let animation = AnimationType.zoom(scale: 0.9)
        
        self.animate(animations: [animation])
        
    }
    func topOffsetAnimate() {
//        let animation = AnimationType.from(direction: .top, offset: 30.0)
//        self.animate(animations: [animation], reversed: true, initialAlpha: 0.0, finalAlpha: 1, delay: 0.2, duration: 0.5,completion: nil)
    }
    func offsetAnimate(direction: Direction = .right) {
        let animation = AnimationType.from(direction: direction, offset: 30.0)
        self.animate(animations: [animation])
    }
    func animateFromBottom() {
        let animation = AnimationType.from(direction: .bottom, offset: 100)
        self.animate(animations: [animation], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0.5)
    }
    
    func animateFromTop() {
        let animation = AnimationType.from(direction: .top, offset: 50)
        self.animate(animations: [animation], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0)
    }
    
    func animateZoomIn() {
       // let animation = AnimationType.from(direction: .top, offset: 50)
        let animation = AnimationType.zoom(scale: 0.5)
        self.animate(animations: [animation], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0)
    }
}


