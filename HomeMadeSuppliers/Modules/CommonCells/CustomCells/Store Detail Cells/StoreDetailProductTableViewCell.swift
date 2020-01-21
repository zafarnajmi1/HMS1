//
//  StoreDetailProductTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/31/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit




class StoreDetailProductTableViewCell: UITableViewCell {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    var store: Store?
    var productList: [Product]?
    var productDelegate: ProductDelegate?
    var callBackDelegate: CallBackDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(id: ProductCollectionViewCell.id)
   
    }

    func setData(list: [Product] ) {
        self.productList = list
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
    
   
    
}

extension StoreDetailProductTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSpace: CGFloat =  4
        let collectionViewSize = collectionView.frame.size.width * 0.50

        return CGSize(width: collectionViewSize - cellSpace , height: 305)
    }
}

extension StoreDetailProductTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as! ProductCollectionViewCell
        let product = productList![indexPath.row]
        cell.loadCell(model: product)
        cell.delegate =  self
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let product = productList![indexPath.row]
        self.productDelegate?.didSelect(product: product)
        
    }
    
   

}

extension StoreDetailProductTableViewCell: CallBackDelegate {
    func reloadData() {
        self.callBackDelegate?.reloadData()
    }
  
}
