//
//  LoaderButton.swift
//  Baqala
//
//  Created by apple on 2/28/19.
//  Copyright © 2019 My Technology. All rights reserved.
//

import UIKit


class LoaderButton: UIButton {
    var originalButtonText: String?
    var originalButtonImage: UIImage?
    var orginalBackgroundColor: UIColor?
    
    var activityIndicator: UIActivityIndicatorView!
    var backgroundLoadingColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
    var indicatorLoadingColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    // bloack UI
    func showLoading(view: UIView) {
        originalButtonText = self.titleLabel?.text
        originalButtonImage = self.currentImage
        orginalBackgroundColor = self.backgroundColor
        
        self.setTitle("", for: .normal)
        self.setImage(nil, for: .normal)
        self.backgroundColor = backgroundLoadingColor
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
       
        showSpinning()
        view.isUserInteractionEnabled = false
    }
    
    func hideLoading(view: UIView) {
        self.setTitle(originalButtonText, for: .normal)
        self.setImage(originalButtonImage, for: .normal)
        self.backgroundColor = orginalBackgroundColor
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    //Load without blocking UI
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        originalButtonImage = self.currentImage
        orginalBackgroundColor = self.backgroundColor
        
        self.setTitle("", for: .normal)
        self.setImage(nil, for: .normal)
        self.backgroundColor = backgroundLoadingColor
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
       self.isUserInteractionEnabled = false
    }
   
    
    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        self.setImage(originalButtonImage, for: .normal)
        self.backgroundColor = orginalBackgroundColor
        if (activityIndicator != nil) {
              activityIndicator.stopAnimating()
        }
       self.isUserInteractionEnabled = true
      
    }
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = indicatorLoadingColor
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}


extension UIButton {
    func showLoader(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.color = .darkGray
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}

