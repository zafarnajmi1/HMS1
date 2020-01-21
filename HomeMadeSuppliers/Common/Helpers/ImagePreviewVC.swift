//
//  ImagePreviewVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 8/19/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import ImageScrollView

class ImagePreviewVC: UIViewController {
    
     @IBOutlet weak var imageScrollView: ImageScrollView!
    
    var imageURL : String = ""
    var myImage: UIImage?
    @IBOutlet weak var attachedimage: UIImageView! 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        attachedimage.setPath(image: imageURL, placeHolder: AppConstant.placeHolders.store)
        imageScrollView.setup()
        imageScrollView.imageScrollViewDelegate = self
        imageScrollView.imageContentMode = .aspectFit
        imageScrollView.initialOffset = .center
       
        if let image = myImage {
            imageScrollView.display(image: image)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func onClick_cross(_ sender : Any){
        dismiss(animated: true, completion: nil)
    }
    
   
    
}

extension UIImage {
    
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        
        self.init(data: imageData)
    }
    
}


extension ImagePreviewVC: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        print("Did change orientation")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}
