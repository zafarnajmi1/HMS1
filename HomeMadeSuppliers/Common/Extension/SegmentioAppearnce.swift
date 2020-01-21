//
//  SegmentioAppearnce.swift
//  TailerOnline
//
//  Created by apple on 3/18/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Segmentio


//extension UICollectionViewFlowLayout { // For RTL scrolling
//
//open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
//    return true
//}
//}

extension Segmentio {
    
    func setupSegmentio( content: [SegmentioItem]) {
//        if myDefaultLanguage == .ar {
//             self.semanticContentAttribute = .forceRightToLeft
//        }
//        else {
//            self.semanticContentAttribute = .forceLeftToRight
//        }
//
        
        let bottomIndicator = SegmentioIndicatorOptions(
            type: .bottom,
            ratio: 1,
            height: 0,
            color: #colorLiteral(red: 0.3019607843, green: 0.7254901961, blue: 0.3294117647, alpha: 1)
        )
        let vLine = SegmentioVerticalSeparatorOptions(ratio: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        let hLine = SegmentioHorizontalSeparatorOptions(type: SegmentioHorizontalSeparatorType.bottom, height: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        
        let myFont = robotoMedium16
        
        let segmentStates = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                titleFont: myFont ,
                titleTextColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            ),
            selectedState: SegmentioState(
                backgroundColor: #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1),
                titleFont: myFont ,
                titleTextColor: .white
            ),
            highlightedState: SegmentioState( //Hold tapped
                backgroundColor: #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1),
                titleFont: myFont ,
                titleTextColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            )
        )
        
        
        let options = SegmentioOptions(
            backgroundColor:  #colorLiteral(red: 0.9764705882, green: 0.9803921569, blue: 0.9882352941, alpha: 1),
            segmentPosition: .dynamic,
            scrollEnabled: true,
            indicatorOptions: bottomIndicator,
            horizontalSeparatorOptions: hLine,
            verticalSeparatorOptions: vLine,
            imageContentMode: .center,
            labelTextAlignment: .center,
            segmentStates: segmentStates
        )
        
        self.setup(
            content: content,
            style: SegmentioStyle.onlyLabel,
            options: options
        )
    }
    
    
}
