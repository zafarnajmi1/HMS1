//
//  BaseImagePickerCollectionViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/25/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import CropViewController

protocol BaseImagePickerCollectionViewCellDelegate: class {
    func mySelectedImage(image: UIImage)
}


class BaseImagePickerCollectionViewCell: UICollectionViewCell {
    
    var imagePickerDelegate: BaseImagePickerCollectionViewCellDelegate?
    var allowsEditingPhotos = false
    var photoAspectRatio : CGSize?
    struct alertPicker {
        static var title = "Title"
        static var message = "Please Select an Option"
        static var camera = "Camera"
        static var photo = "Photo Library"
        static var cancel = "Cancel"
    }
    
    
    func alertPickerOptions(aspectRatio : CGSize? = nil) {
        photoAspectRatio = aspectRatio
        let alert = UIAlertController(title: alertPicker.message, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: alertPicker.photo, style: .default , handler:{ (UIAlertAction)in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = false//self.allowsEditingPhotos
            vc.delegate = self
           
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }))
        
        
        alert.addAction(UIAlertAction(title: alertPicker.camera , style: .default , handler:{ (UIAlertAction)in
            
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            //vc.allowsEditing = false
            vc.delegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: alertPicker.cancel , style: .cancel , handler:{ (UIAlertAction)in
            
            print("Cancel")
            
        }))
        
      UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}




extension BaseImagePickerCollectionViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage  {
            
            print(image.size)
            if photoAspectRatio == nil {
                imagePickerDelegate?.mySelectedImage(image: image)
                // print out the image size as a test
                
                picker.dismiss(animated: true)
//                return
            }
            else{
                cropImage(image: image, picker)
//                return
            }
            
            
        }

//        else if let image = info[.originalImage] as? UIImage  {
//            imagePickerDelegate?.mySelectedImage(image: image)
//            // print out the image size as a test
//            print(image.size)
//            picker.dismiss(animated: true)
//            return
//        }
//        else{
            picker.dismiss(animated: true, completion: nil)
//        }

    }
    func cropImage(image : UIImage,_ picker: UIImagePickerController){
        let cropController = CropViewController(croppingStyle: CropViewCroppingStyle.default, image: image) as CropViewController
                //cropController.modalPresentationStyle = .fullScreen
                cropController.delegate = self
                
                
                // Uncomment this if you wish to provide extra instructions via a title label
                //cropController.title = "Crop Image"
            
                // -- Uncomment these if you want to test out restoring to a previous crop setting --
                //cropController.angle = 90 // The initial angle in which the image will be rotated
                //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
            
                // -- Uncomment the following lines of code to test out the aspect ratio features --
                cropController.aspectRatioPreset = .presetCustom; //Set the initial aspect ratio as a square
                cropController.customAspectRatio = photoAspectRatio!//CGSize(width: photo, height: 100)
                cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
                //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
                cropController.aspectRatioPickerButtonHidden = true
            
                // -- Uncomment this line of code to place the toolbar at the top of the view controller --
                //cropController.toolbarPosition = .top
            
                cropController.rotateButtonsHidden = true
                cropController.rotateClockwiseButtonHidden = true
            
                cropController.resetButtonHidden = true
        //        cropController.aspectRatioPreset
                //cropController.doneButtonTitle = "Title"
                //cropController.cancelButtonTitle = "Title"
                
//                self.image = image
                
                //If profile picture, push onto the same navigation stack
//                if croppingStyle == .circular {
//                    if picker.sourceType == .camera {
//                        picker.dismiss(animated: true, completion: {
//                            self.present(cropController, animated: true, completion: nil)
//                        })
//                    } else {
//                        picker.pushViewController(cropController, animated: true)
//                    }
//                }
//                else
//                { //otherwise dismiss, and then present from the main controller
//        let parent = picker.parent
                    picker.dismiss(animated: true, completion: {
                        
                        let window = UIApplication.shared.keyWindow
                        cropController.modalPresentationStyle = .fullScreen
                        window?.rootViewController?.present(cropController, animated: true, completion: nil)
//                        parent?.present(cropController, animated: true, completion: nil)
                        //self.navigationController!.pushViewController(cropController, animated: true)
                    })
//                }
    }

}
extension BaseImagePickerCollectionViewCell : CropViewControllerDelegate{
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        self.croppedRect = cropRect
//        self.croppedAngle = angle
        
        imagePickerDelegate?.mySelectedImage(image: image)
        cropViewController.dismiss(animated: true, completion: nil)
//        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
}



