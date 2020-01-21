//
//  CustomIndicatorView.swift
//  TailerOnline
//
//  Created by apple on 3/28/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


class MyIndicator: UIView {
    
    let imageView = UIImageView()
    
    init(onView: UIView) {
        super.init(frame: onView.frame)
     
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.centerXAnchor.constraint(equalTo: onView.centerXAnchor).isActive = true
//        imageView.centerYAnchor.constraint(equalTo: onView.centerYAnchor).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 50)
//        imageView.heightAnchor.constraint(equalToConstant: 50)
        
        imageView.frame.size = CGSize(width: 100, height: 100)
        imageView.center = onView.center
        imageView.image = AppConstant.images.logo
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
       
        
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2001551798)
        
         onView.addSubview(self)
        
//        self.translatesAutoresizingMaskIntoConstraints = false
//        self.topAnchor.constraint(equalTo: onView.topAnchor).isActive = true
//        self.leftAnchor.constraint(equalTo: onView.leftAnchor).isActive = true
//        self.rightAnchor.constraint(equalTo: onView.rightAnchor).isActive = true
//        self.bottomAnchor.constraint(equalTo: onView.bottomAnchor).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func startAnimating() {
        isHidden = false
        rotate()
    }
    
    func stopAnimating() {
        isHidden = true
        removeRotation()
    }
    
    private func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func removeRotation() {
        self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
