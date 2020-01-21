//
//  ProductCollectionTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/13/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class ProductCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var productList = [Product]()
    var productDelegate: ProductDelegate?
    var callBackDelegate: CallBackDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.registerCell(id: ProductCollectionViewCell.id)
    }

    func setData(list: [Product]? ) {
        self.productList = list ?? []
        setupProductCellLayout()
    }
    
    func setupProductCellLayout() {
         //layout setup
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 200, height: 295)
        
        self.collectionView.reloadData()
    }
    
    
}


extension ProductCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as! ProductCollectionViewCell
        let product = productList[indexPath.row]
        cell.loadCell(model: product)
        cell.delegate =  self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let product = productList[indexPath.row]
        self.productDelegate?.didSelect(product: product)
        
    }

}


extension ProductCollectionTableViewCell: CallBackDelegate {
    func reloadData() {
       
    }
    
   
}
