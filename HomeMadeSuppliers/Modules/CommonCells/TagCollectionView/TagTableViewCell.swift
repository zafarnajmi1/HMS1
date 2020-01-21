//
//  TagTableViewCell.swift
//  DynamicHeightCollectionView
//
//  Created by Payal Gupta on 11/02/19.
//  Copyright © 2019 Payal Gupta. All rights reserved.
//

import UIKit


protocol TagListDelegate {
    func itemSelected(toggle: Bool, city:DeliverableCity)
}


class TagTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var vcRefrence: UIViewController?
    var callBack: (() -> Void)?
    var deliverableCityList = [DeliverableCity]()
    
    var isRemovableCell = true
    let remove = " ✖️"
    
    var singleSelection = false
    var selectionIndex: Int?
    
   
    
    
    override func awakeFromNib() {
        collectionView.delegate = self
        collectionView.dataSource = self
    
    }
    
    func setData(model: [DeliverableCity],
                 isRemovableCell: Bool ) {
        self.deliverableCityList = model
        self.isRemovableCell = isRemovableCell
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
    
    
   
    
    
    
    
    func requestToRemoveCity(id: String, completion:@escaping ((UserLoginAPIResponse) -> Void ))  {
        
        let params: [String: Any] = ["deliverable": id]
        
        vcRefrence?.showNvLoader()
        ProfileManager.shared.removeDeliverableCity(params: params) { (result) in
            self.vcRefrence?.hideNvloader()
            switch result {
            case .sucess(let rootModel):
                
                completion(rootModel)
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
    }
}

extension TagTableViewCell: UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.deliverableCityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
       
        let model = self.deliverableCityList[indexPath.row]
        cell.setData(model: model, isRemovableCell: isRemovableCell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let model = self.deliverableCityList[indexPath.row]
        let cityName = model.city?.title ?? ""
        let price = setDefualtCurrency(price: model.price)
        var stringValue = "\(cityName): \(price)"
        if isRemovableCell == true {
              stringValue = "\(cityName): \(price) \(remove)"
        }
       
        let stringWidth = stringValue.size(withAttributes:[.font:robotoMedium14]).width
        let cellWidth = stringWidth + 20 //spacing
        return CGSize(width: cellWidth, height: 30.0)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = self.deliverableCityList[indexPath.row]
        
        if singleSelection == true && selectionIndex == indexPath.row {
            
        }
        
        if isRemovableCell == true {
            
            //API Request
            requestToRemoveCity(id: model.id! ) { (rootModel) in
                
                AppSettings.shared.setUser(model: rootModel.user!)
                
                nvMessage.showSuccess(body: "Removed Successfully".localized, closure: {
                    
                    //Remove Items
                    self.deliverableCityList.remove(at: indexPath.row)
                    self.collectionView.reloadData()
                    //Reset If Empty
                    if self.deliverableCityList.count == 0 {
                        self.callBack?()
                    }
                })
            }
        }
        
    }
        
    
}




