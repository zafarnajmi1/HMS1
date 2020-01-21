//
//  LigtBoxImageViewExtension.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/22/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Lightbox
import UIKit


extension UIView {
    
    
    func showImageVC(imagesURL: [String] = [], startIndex: Int = 0, singImageURL: String? ) {
        
           var imageURLs = [LightboxImage]()
        
           if let path = singImageURL {
               imageURLs.append(LightboxImage(imageURL: (path.toURL)!))
           }
        
        //for array
           for image in imagesURL {
               imageURLs.append(LightboxImage(imageURL: (image.toURL)!))
           }
        
        
           
           let controller = LightboxController(images: imageURLs, startIndex: startIndex)
           controller.dynamicBackground = true
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            controller.modalPresentationStyle = .fullScreen
            window.rootViewController?.present(controller, animated: true, completion: nil)
        }
           
        
    }
    
    
}
