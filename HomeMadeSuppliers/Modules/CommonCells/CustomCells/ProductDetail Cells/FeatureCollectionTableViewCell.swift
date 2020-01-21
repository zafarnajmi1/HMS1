//
//  FeatureCollectionTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/13/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class FeatureCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var Label: UILabel!

    
    private var priceable: Priceable1?
    private var characteristics = [Characteristic1]()
    private var delegate: FeatureCollectionViewCellDelegate?
    var selectedOptionId: String?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.registerCell(id: BoxCollectionViewCell.id)
    }
    
    
    func setData(priceable: Priceable1? ,_ delegate: FeatureCollectionViewCellDelegate) {
        self.priceable = priceable
        self.characteristics = priceable?.characteristics ?? []
        self.delegate = delegate
        self.selectedOptionId = nil
        let prefix = "Select".localized
        self.Label.text = "\(prefix) \(priceable?.feature?.title ?? "Feature".localized)"
        collectionView.reloadData()
        
        if let selectedIndex = priceable?.selectedIndex {
            let selectedCharacteristic = priceable?.characteristics?[selectedIndex]
            self.selectedOptionId = selectedCharacteristic?.id
        }
        
    }
    
}

extension FeatureCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxCollectionViewCell.id, for: indexPath) as! BoxCollectionViewCell
        let item = characteristics[indexPath.row]
        cell.setData(label: item.title ?? "-")
        
        if selectedOptionId == item.id {
            cell.containterView.backgroundColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
            cell.label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        else {
            cell.containterView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9647058824, alpha: 1)
            cell.label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = characteristics[indexPath.row]
        //unselect
        if selectedOptionId == item.id {
            selectedOptionId = nil
            self.priceable?.selectedIndex = nil
            delegate?.didSelectedItem(characteristic: nil, nil, indexPath.row)
        }
        else {
            self.selectedOptionId = item.id
            delegate?.didSelectedItem(characteristic: item, priceable, indexPath.row)
        }
        
        collectionView.reloadData()
    }
    
}
