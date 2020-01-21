//
//  BaseImagePickerVC.swift
//  TailerOnline
//
//  Created by apple on 4/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//
import UIKit
import CropViewController

protocol BaseImagePickerVCDelegate: class {
    func mySelectedImage(image: UIImage)
}


class BaseImagePickerVC: UIViewController {
    
    var imagePickerDelegate: BaseImagePickerVCDelegate?
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
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }))
        
        
        alert.addAction(UIAlertAction(title: alertPicker.camera , style: .default , handler:{ (UIAlertAction)in
            
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            self.present(vc, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: alertPicker.cancel , style: .cancel , handler:{ (UIAlertAction)in
            
             print("Cancel")
            
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}


extension BaseImagePickerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
//                       cropController.modalPresentationStyle = .fullScreen
                       cropController.delegate = self
                       
       
                       cropController.aspectRatioPreset = .presetCustom;
                       cropController.customAspectRatio = photoAspectRatio!//CGSize(width: photo, height: 100)
                       cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
                       //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
                       cropController.aspectRatioPickerButtonHidden = true
                   
                       // -- Uncomment this line of code to place the toolbar at the top of the view controller --
                       //cropController.toolbarPosition = .top
                   
                       cropController.rotateButtonsHidden = true
                       cropController.rotateClockwiseButtonHidden = true
                   
                       cropController.resetButtonHidden = true

                       picker.dismiss(animated: true, completion: {
                           
                           let window = UIApplication.shared.keyWindow
                           cropController.modalPresentationStyle = .fullScreen
                           window?.rootViewController?.present(cropController, animated: true, completion: nil)

                       })
           //                }
       }
   
}



extension BaseImagePickerVC : CropViewControllerDelegate{
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        self.croppedRect = cropRect
//        self.croppedAngle = angle
        
        imagePickerDelegate?.mySelectedImage(image: image)
        cropViewController.dismiss(animated: true, completion: nil)
//        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
}



