//
//  ResizeImageExtension.swift
//  Baqala
//
//  Created by apple on 2/28/19.
//  Copyright © 2019 My Technology. All rights reserved.
//
import UIKit

extension UIImage {
  
    func resizeImage(newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func getFileSizeInMB ()-> String {
        
        
        let img1Data: NSData  = NSData(data: self.jpegData(compressionQuality: 0.0)!)
        
        let byteCount = img1Data.length// replace with data.count
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(byteCount))
        print(string)
        
        return string
    }
}

extension UIImageView {
    
    //image text should not be contained
    func flipHorizantal(ImageName: String)  {
        let image = UIImage(named: ImageName)
        let flippedImage = image?.withHorizontallyFlippedOrientation()
        self.image = flippedImage
    }
    
    
    func setPath(image: String?, placeHolder: String? )  {
        let url = URL(string: image ?? "")
        let placeholder =  UIImage(named: placeHolder ?? "")
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func setPath(image: String?, placeHolder: UIImage )  {
        let url = URL(string: image ?? "")
       // let placeholder =  UIImage(named: placeHolder ?? "")
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func setPath(image: String?, placeHolder: String?, completion: @escaping( _ uiImage: UIImage?) -> Void)  {
        let url = URL(string: image ?? "")
        let placeholder =  UIImage(named: placeHolder ?? "")
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: nil) { (image, _, _, _) in
            completion(image)
        }
    }
}

