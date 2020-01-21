//
//  DeliverableCityTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/27/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


protocol deliveryOptionDelegate {
    func didSelect(selectedCity: DeliverableCity1?)
}

class DeliverableCityTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var seprator: UIView!
  
    private var deliverableCityList = [DeliverableCity1]()
    private var domesticPrice: String?
    private var globalPrice: String?
    private var selectionIndex: Int?
    
    var delegate: deliveryOptionDelegate?
    var selectionEnabled = true
    
    override func awakeFromNib() {
        collectionView.registerCell(id: DeliverableCityCollectionViewCell.id)
       // collectionView.registerCell(id: GlobalDeliveryCollectionViewCell.id)
        
    }
    
    func setData(model: Store1, selectedCity: DeliverableCity1? = nil) {

        self.deliverableCityList = model.deliverableCities ?? []
        self.domesticPrice = model.domesticShipping?.showPrice?.formattedText
        self.globalPrice = model.internationalShipping?.showPrice?.formattedText
        self.selectionIndex = nil
        
        if selectedCity != nil {
            if let index = self.deliverableCityList.firstIndex(where: {$0.id == selectedCity?.id }) {
                self.selectionIndex = index
            }
        }
        
        
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
    }
    
  
    
}


extension DeliverableCityTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        if deliverableCityList.count == 0 {
            let cellMarginLR: CGFloat =  0
            let cellWidth = collectionView.bounds.size.width
            return CGSize(width: cellWidth - cellMarginLR , height: 32)
        }
        else {
            let cellMarginLR: CGFloat = 4
            let cellWidth = collectionView.bounds.size.width * 0.50
            return CGSize(width: cellWidth - cellMarginLR , height: 32)
        }
        
    
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    

}


extension DeliverableCityTableViewCell: UICollectionViewDataSource,
    UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return deliverableCityList.count == 0 ? 1: deliverableCityList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeliverableCityCollectionViewCell.id, for: indexPath) as! DeliverableCityCollectionViewCell
       
        
        if selectionIndex == indexPath.row {
                  cell.myContentView.layer.borderColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
                  self.selectionIndex = indexPath.row
                 
        }
        else {
              cell.myContentView.layer.borderColor = #colorLiteral(red: 0.7960784314, green: 0.8, blue: 0.8039215686, alpha: 1)
        }
        
        
        
        if deliverableCityList.count > 0 {
            let model = self.deliverableCityList[indexPath.row]
            cell.setData(model: model)
        }
        else { // domestic Price
            cell.label.text = "All Over The UAE".localized
            cell.value.text = domesticPrice
            cell.myContentView.layer.borderColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
        }
        
      
        
        return cell
    }
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if selectionEnabled == false { return }
        
        //selection implementation
         let cell = collectionView.cellForItem(at: indexPath) as! DeliverableCityCollectionViewCell
         if deliverableCityList.count > 0 {
            let model = self.deliverableCityList[indexPath.row]
            delegate?.didSelect(selectedCity: model )
         }
        
        
        cell.myContentView.layer.borderColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
        self.selectionIndex = indexPath.row
        collectionView.reloadData()
       
       
        
     }
    
    
}
