//
//  AddProductConfigurationTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DropDown


protocol AddProductConfigurationTableViewCellDelegate: class {
    func didUpdate(configuration: Configuration?, indexPath: IndexPath)
}



class AddProductConfigurationTableViewCell: UITableViewCell {
    @IBOutlet weak var enterStockLabel: UILabel!
    @IBOutlet weak var enterPriceLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    
    @IBOutlet weak var dropdownStackView: UIStackView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var stock: UITextField!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var offerPrice: UITextField!
    @IBOutlet weak var offerPriceView: UIView!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var checkBoxtitle : UILabel!
    
    
    
    weak var configuration: Configuration?
    
    private var indexPath: IndexPath!
    private var delegate : AddProductConfigurationTableViewCellDelegate?
    
    var addImageDelegate: AddImageCollectionViewCellDelegate?
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //self.isNewCell = true
        // self.imageList = []
        //  self.dropDownFeatures = []
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLocalization()
        
        collectionview.registerCell(id: AddImageCollectionViewCell.id)
        collectionview.registerCell(id: ViewImageCollectionViewCell.id)
        self.price.delegate = self
        self.stock.delegate = self
        self.offerPrice.delegate = self
        self.endEditing(true)
        collectionview.dataSource = self
        collectionview.delegate = self
        
    }
    
    func loadCell(configuration: Configuration?,
                  delegate: AddProductConfigurationTableViewCellDelegate?,
                  indexPath: IndexPath )  {
        
        self.delegate = delegate
        self.indexPath = indexPath
        self.configuration = configuration
        
        if let combination = self.configuration?.combination {
            self.price.text = combination.price ?? ""
            self.stock.text = combination.available ?? ""
            self.offerPrice.text = combination.offer ?? ""
            
            //self.configuration?.combination?.features = self.combination?.features
            self.collectionview.reloadData()
            
        }
        else {
            self.price.text = ""
            self.stock.text = ""
            self.offerPrice.text = ""
            self.collectionview.reloadData()
        }
        
        if configuration?.combination.isOffer == true {
            self.checkBoxButton.isSelected = true
            self.offerPriceView.isHidden = false
        }
        else {
            self.checkBoxButton.isSelected = false
            self.offerPriceView.isHidden = true
        }
        
        
        
        
        
        self.setupFeatureCharateristics()
    }
    
    
}

//MARK:- localization
private extension AddProductConfigurationTableViewCell {
    private func setLocalization() {
        self.enterStockLabel.text = "Enter Stock".localized
        self.enterPriceLabel.text = "Enter Price".localized
        self.offerPriceLabel.text = "Offer Price".localized
        self.checkBoxtitle.text = "Add Offer".localized
        self.offerPrice.placeholder = "Offer Price".localized
        self.stock.placeholder = "Enter Stock".localized
        self.price.placeholder = "Enter Price".localized
        AppLanguage.updateTextFieldsDirection([
            offerPrice, stock, price
        ])
    }
}




//MARK:-  actions
extension AddProductConfigurationTableViewCell {
    @IBAction func checkBoxBtnTapped(sender: UIButton) {
        self.endEditing(true)
        checkBoxButton.toggle()
        self.configuration?.combination.isOffer = checkBoxButton.isSelected == true ? true:false
        self.delegate?.didUpdate(configuration: self.configuration, indexPath: indexPath)
        self.offerPriceView.isHidden = checkBoxButton.isSelected == true ? false:true
    }
}

//MARK:-  create dropdowns
extension AddProductConfigurationTableViewCell {
    func setupFeatureCharateristics()  {
        
        
        if self.configuration?.combination.features.count == 0 {
            self.dropdownStackView.isHidden = true
            print("selected Features not found")
        }
        else {
            self.dropdownStackView.isHidden = false
        }
        
        //remove all views
        for view in  self.dropdownStackView.arrangedSubviews  {
            self.dropdownStackView.removeArrangedSubview(view)
        }
        
        
        //create dropdown stackview
        for (index, object) in (self.configuration?.combination.features ?? []).enumerated() {
            
            //create UI View
            let dropDownView = DropDownView.instanceFromNib() as! DropDownView
            dropDownView.heightAnchor.constraint(equalToConstant:72).isActive = true
            dropDownView.tag = index
            
            self.dropdownStackView.addArrangedSubview(dropDownView)
            
            dropDownView.loadCell(configuration: self.configuration, combinationFeature: object, delegate: self)
        }
        
    }
}



extension AddProductConfigurationTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.price:
            self.configuration?.combination.price = self.price.text
            self.delegate?.didUpdate(configuration: self.configuration, indexPath: indexPath)
        case self.stock:
            self.configuration?.combination.available = self.stock.text
            self.delegate?.didUpdate(configuration: self.configuration, indexPath: indexPath)
        case self.offerPrice:
            self.configuration?.combination.offer = self.offerPrice.text
            
            self.delegate?.didUpdate(configuration: self.configuration, indexPath: indexPath)
        default:
            return
        }
        
        
        
    }
}






//MARK:-  collectionview layout
extension AddProductConfigurationTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width =  160
        let height = 140
        return CGSize(width: width , height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 8, left: 0, bottom: 8, right: 0)
    }
}



extension AddProductConfigurationTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // dynamic cell- > view Image List
        //static cell-> add image
        
        
        
        if let totalImages = self.configuration?.combination.images.count{
            return  totalImages + 1
        }
        else {
            return 1
        }
        
        //  return self.imageList.count + 1
        
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
            
            guard let imageList = self.configuration?.combination.images else {
                return cell
            }
            
            let row = indexPath.row - 1
            let model = imageList[row]
            cell.loadeCell(model: model)
            
            
            cell.deleteBtn.onTap {
                let msg = "Do you want to delete this image?"
                UIApplication.shared.keyWindow?.rootViewController?.presentAlert(message: msg, yes: {
                    self.didImageDelete(model: model)
                }, no: nil)
            }
            cell.tickBtn.onTap {
                
                self.didMarkAsDefault(model: model,index: row)
            }
            return cell
        }
        
    }
    
    
}


//MARK:-  tableview AddImageCollectionViewCellDelegate
extension AddProductConfigurationTableViewCell: AddImageCollectionViewCellDelegate {
    func didUploadedImageSuccessfully(imageDic: ImageCollection) {
        if self.configuration?.combination.images.count ?? 0 == 0 {
            imageDic.isDefault = true
        }
        //        self.combination?.isSelected = true
        self.configuration?.combination.images.insert(imageDic, at: 0)
        
        self.delegate?.didUpdate(configuration: self.configuration, indexPath: indexPath)
        // self.imageList = self.combination?.images ?? []
        collectionview.reloadData()
    }
    
}


//MARK:-  tableview ViewImageCollectionViewCellDelegate
extension AddProductConfigurationTableViewCell {
    func didMarkAsDefault(model: ImageCollection, index: Int) {
        //remove all previous defaults
        for item in self.configuration?.combination.images ?? []  {
            item.isDefault = false
        }
        self.configuration?.combination.images[index].isDefault = true
        self.delegate?.didUpdate(configuration: self.configuration, indexPath: indexPath)
        //        self.imageList = self.combination?.images ?? []
        collectionview.reloadData()
        
    }
    
    func didImageDelete(model: ImageCollection) {
        
        self.configuration?.combination.images = self.configuration?.combination.images.filter { $0.filePath != model.filePath } ?? []
        self.delegate?.didUpdate(configuration: self.configuration, indexPath:indexPath)
        collectionview.reloadData()
        
    }
    
}






//MARK:- DropDownViewDelegate
extension AddProductConfigurationTableViewCell: DropDownViewDelegate {
    
    
    func didSelectToggle(cell: DropDownView) {
        
        
        if let feature  = cell.combinationFeature {
            self.configuration?.combination.features[cell.tag] = feature
            self.delegate?.didUpdate(configuration: configuration, indexPath: indexPath)
        }
        
    }
    
}






