//
//  AddImageCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/25/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

protocol AddImageCollectionViewCellDelegate: class {
    func didUploadedImageSuccessfully(imageDic: ImageCollection)
}


class AddImageCollectionViewCell: BaseImagePickerCollectionViewCell {

    @IBOutlet weak var viewAddImage: UIView!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var recomendedSizeLabel: UILabel!
    
    var completionDelegate: AddImageCollectionViewCellDelegate?
    
    var showLoader: Bool = false {
        didSet {
          viewProgress.isHidden = showLoader == true ? false: true
         }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
        setupView()
    }

    private func setLocalization() {
        let prefix =  "Recomended Size:".localized
        self.recomendedSizeLabel.text = "\(prefix) 540x377"
    
    }
    
    
    private func setupView() {
        self.imagePickerDelegate = self
        self.allowsEditingPhotos = false
        self.viewAddImage.addTapGesture { (gesture) in
            self.alertPickerOptions(aspectRatio: CGSize(width: 1000, height: 694))
        }
    }
    
    
}

extension AddImageCollectionViewCell: BaseImagePickerCollectionViewCellDelegate {
    func mySelectedImage(image: UIImage) {
        self.selectedImage.image = image
        self.showLoader = true
        NvProgressLoader.showLoader()
        
//        self.progressLabel.text = ""
//        self.indicatorView.startAnimating()
       
        SocketEventManager.shared.uploadImage(image: image) { (result) in
            
            switch result {
                
            case .progress(let value):
//                DispatchQueue.main.async() {
//                      self.progressLabel.isHidden = false
//                      self.indicatorView.startAnimating()
//                      self.progressLabel.text = "\(Int(value))% complete"
//
//                }
              
                NvProgressLoader.progress(count: Int(value))
                
            case .path(let fileName):
                 NvProgressLoader.hideLoader()
               self.showLoader = false
               //self.indicatorView.stopAnimating()
               
                print("Image = ",fileName)
                let dic = ImageCollection()
                dic.filePath = fileName
                dic.image = image
                dic.isDefault = false
                self.completionDelegate?.didUploadedImageSuccessfully(imageDic: dic)
            }
            
        }
        
    }

    
}
