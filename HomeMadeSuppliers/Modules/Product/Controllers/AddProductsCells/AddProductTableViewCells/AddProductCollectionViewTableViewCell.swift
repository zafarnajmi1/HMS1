//
//  AddProductCollectionViewTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/25/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit




class AddProductCollectionViewTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionview: UICollectionView!
    
    var imageList = [ImageCollection]()
    var product: ProductDetail?
    var addImageDelegate: AddImageCollectionViewCellDelegate?
    var viewImageDelegate: ViewImageCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionview.registerCell(id: AddImageCollectionViewCell.id)
        collectionview.registerCell(id: ViewImageCollectionViewCell.id)
        collectionview.dataSource = self
        collectionview.delegate = self

    }

    
    
}

//MARK:-  collectionview layout
extension AddProductCollectionViewTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width =  180
        let height = 150
        return CGSize(width: width , height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 8, left: 8, bottom: 8, right: 8)
    }
}



extension AddProductCollectionViewTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        // dynamic cell- > view Image List
        //static cell-> add image
        return imageList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
       
        // static cell
        if indexPath.row  == 0 {
            let cell = collectionview.dequeueReusableCell(withReuseIdentifier: AddImageCollectionViewCell.id, for: indexPath) as! AddImageCollectionViewCell
            cell.completionDelegate = self
            return cell
            
        }
        else {  // dynamic cell
            let cell = collectionview.dequeueReusableCell(withReuseIdentifier: ViewImageCollectionViewCell.id, for: indexPath) as! ViewImageCollectionViewCell
            let row = indexPath.row - 1
            let model = imageList[row]
            cell.loadeCell(model: model)
            cell.deleteBtn.onTap {
                let msg = "Do you want to delete this image?"
                UIApplication.shared.keyWindow?.rootViewController?.presentAlert(message: msg, yes: {
                    self.viewImageDelegate?.didImageDelete(model: model)
                }, no: nil)
            }
            cell.tickBtn.onTap {
              
                self.viewImageDelegate?.didMarkAsDefault(model: model,index: row)
            }
            return cell
        }
        
       
    
        
        
    }
    
    
}


extension AddProductCollectionViewTableViewCell: AddImageCollectionViewCellDelegate {
    func didUploadedImageSuccessfully(imageDic: ImageCollection) {
                self.addImageDelegate?.didUploadedImageSuccessfully(imageDic: imageDic)
    }
}
