//
//  StoreDetailVC2.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/12/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StoreDetailVC2: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:-  variables
    var store: Store?
    var productList = [Product]()
    var productPagination: Pagination?
    var selectedCategory: Category?
   
    enum tableSections: Int {
        case store = 0
        case detail = 1
        case city = 2
        case product = 3
        static let count = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        collectionView.registerCell(id: StoreCollectionViewCell.id)
        collectionView.registerCell(id: DetailCollectionViewCell.id)
        collectionView.registerCell(id: DeliverableCityCollectionViewCell.id)
        collectionView.registerCell(id: GlobalDeliveryCollectionViewCell.id)
        collectionView.registerCell(id: ProductCollectionViewCell.id)
      
        //API call
        requesToFetchStoreDetal()
    }

}
 //MARK:-  api requests
extension StoreDetailVC2 {
    
    //api Request
    func requesToFetchStoreDetal() {
        
        guard let id = store?.id else {return}
        self.showNvLoader()
        StoreManager.shared.fetchStoreDetailBy(id: id) { (result) in
            
            
            switch result {
            case .sucess(let root):
                self.store = root.store
                self.collectionView.backgroundView = nil
                self.collectionView.reloadData()
                //api call
                self.requestToFetchProductList()
                
            case .failure(let error):
                self.hideNvloader()
                self.collectionView.setEmptyView(message: error)
            }
            
        }
    }
     //MARK:-  api request with pagination
    func requestToFetchProductList() {
        
        let perPage = MyPagination.shared.perPage
        let nextPage = productPagination?.next ?? 1
        var params: [String: Any] = ["pagination": perPage, "page": nextPage ]
        
        if let id = store?.id {
            params.updateValue(id, forKey: "store")
        }
        
        var categories = [String]()
        if let category = selectedCategory {
            categories.append(category.id ?? "")
        }
      
        if categories.count > 0 {
            params.updateValue(categories, forKey: "categories")
        }
        
        ProductManager.shared.fetchProductList(params: params) { (result) in
            self.hideNavigationBarLoader()
            ProgressHUD.dismiss(animated: true)
            self.hideNvloader()
            
            switch result {
            case .sucess(let root):
                self.updateList(response: root.data)
                
            case .failure(let error):
                self.collectionView.setEmptyView(message: error)
            }
            
        }
    }
    
    func updateList(response: ProductData? )  {
        
        self.productPagination = response?.pagination
        
        if productPagination?.page ?? 0 == 1 {
            self.productList = response?.collection ?? []
            self.reloadListView()
        }
        else {
            self.productList.append(contentsOf: response?.collection ?? [])
            self.collectionView.reloadData()
        }
        
        
    }
    
    func reloadListView()  {
        
        if productList.count == 0 {
            nvMessage.showStatusWarning(title: "Store Products".localized, body: "No Records found".localized)
            
        }
        collectionView.backgroundView = nil
        collectionView.reloadData()
        
    }
}


extension StoreDetailVC2: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 0 , height: 0)
        guard let tableSection = tableSections(rawValue: indexPath.section) else { return size }
       
        switch tableSection {
        case .store:
            let cellMarginLR: CGFloat =  0
            let cellWidth = collectionView.frame.size.width
            return CGSize(width: cellWidth - cellMarginLR , height: 160)
        case .detail:
  
            return dynamicHeightCell()
         case .city:
           return cityCellSize()
        case .product:
            let cellMarginLR: CGFloat =  12
            let cellWidth = collectionView.frame.size.width * 0.50
            return CGSize(width: cellWidth - cellMarginLR , height: 295)
            
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let defaultInsets = UIEdgeInsets (top: 8, left: 12, bottom: 8, right: 12)
        guard let tableSection = tableSections(rawValue: section) else { return defaultInsets }
        switch tableSection {
        case .detail:
            return UIEdgeInsets (top: 0, left: 12, bottom: 8, right: 12)
        case .city:
             return UIEdgeInsets (top: 8, left: 12, bottom: 12, right: 12)
        case .product:
            return UIEdgeInsets (top: 12, left: 8, bottom: 12, right: 8)
        default:
            return defaultInsets
        }
    }
    
    func dynamicHeightCell() -> CGSize {
        // load cell from Xib
        let cell = Bundle.main.loadNibNamed("DetailCollectionViewCell", owner: self, options: nil)?.first as! DetailCollectionViewCell
        cell.detail.text = store?.descriptionField
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        //width that you want
        let paddingLR: CGFloat = 24
        let width = collectionView.frame.width - paddingLR
        let height: CGFloat = 0
        
        let targetSize = CGSize(width: width, height: height)
        
        // get size with width that you want and automatic height
        let size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
        //if you want height and width both to be dynamic use below
        //let size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return size
    }

    
    func cityCellSize() -> CGSize {
        if store?.deliverableCities?.count ?? 0 > 0 {
            let cellMarginLR: CGFloat =  18
            let cellWidth = collectionView.frame.size.width * 0.50
            return CGSize(width: cellWidth - cellMarginLR , height: 32)
        }
        else { //Gloable delivery cell size
            let cellMarginLR: CGFloat =  24
            let cellWidth = collectionView.frame.size.width
            return CGSize(width: cellWidth - cellMarginLR , height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let defaultSize = CGSize(width: 0, height: 0)
        guard let tableSection = tableSections(rawValue: section) else { return defaultSize }
        switch tableSection {
        case .store:
            return defaultSize
        default:
            return CGSize(width: collectionView.frame.width, height: 40) //add your height here
        }
       
    }
}




 //MARK:-  class dataSource
extension StoreDetailVC2: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
            
            guard let section = tableSections(rawValue: indexPath.section) else { return reusableview }
            switch section {
            case .store:
                reusableview.title.text = ""
                reusableview.dropDownView.isHidden = true
            case .detail:
                reusableview.title.text = "Description".localized
                reusableview.dropDownView.isHidden = true
            case .city:
                reusableview.title.text = "We Can Arrive In:".localized
                reusableview.dropDownView.isHidden = true
            case .product:
                reusableview.title.text = "Store Products".localized
                reusableview.dropDownView.isHidden = false
                reusableview.delegate = self
                reusableview.setupDropDown()
            }
            
            return reusableview
            
            
        default:  fatalError("Unexpected element kind")
        }
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tableSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tableSection = tableSections(rawValue: section) else { return 0 }
        switch tableSection {
        case .store:
            return 1
        case .detail:
            return 1
        case .city:
            let cities = store?.deliverableCities?.count ?? 0
            return cities == 0 ? 1: cities
        case .product:
            return self.productList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tableSection = tableSections(rawValue: indexPath.section) else {
            return UICollectionViewCell() }
        
        switch tableSection {
        case .store:
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.id, for: indexPath) as! StoreCollectionViewCell
                  cell.isStoreDetailPage = true
                  cell.setData(model: self.store!)
             
            return cell
            
        case .detail:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.id, for: indexPath) as! DetailCollectionViewCell
            cell.detail.text = store?.descriptionField
            
            return cell
        case .city:
            if store?.deliverableCities?.count ?? 0 > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeliverableCityCollectionViewCell.id, for: indexPath) as! DeliverableCityCollectionViewCell
                let city = store?.deliverableCities?[indexPath.row]
                cell.setData(model: city!)
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GlobalDeliveryCollectionViewCell.id, for: indexPath) as! GlobalDeliveryCollectionViewCell
                let price =  setDefualtCurrency(price: store?.domesticShipping)
                let prefix = "All accross UAE in".localized
                cell.title.text = "\(prefix) \(price)"
                return cell
            }
           
        case .product:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as! ProductCollectionViewCell
               let product = productList[indexPath.row]
            
               cell.loadCell(model: product)
            return cell
        
        }
    }
    
   func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (collectionView.contentOffset.y + collectionView.frame.size.height) >= collectionView.contentSize.height  {
            
            let fetchMore = MyPagination.shared.checkFetchMore(model: productPagination)
            if fetchMore {
                ProgressHUD.present(animated: true)
                self.requestToFetchProductList()
            }
            
        }
    }
    
}

extension StoreDetailVC2: HeaderCollectionReusableViewDelegate {
    func didSelect(_ category: Category?) {
        self.selectedCategory = category
        self.showNvLoader()
        self.productPagination = nil
        self.requestToFetchProductList()
    }
    
    
}

 //MARK:- class delegates
extension StoreDetailVC2: UICollectionViewDelegate, CallBackDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        guard let section = tableSections(rawValue: indexPath.section) else { return }
        switch section {
        case .product:
            let product = productList[indexPath.row]
            let s = AppConstant.storyBoard.product
            let vc = s.instantiateViewController(withIdentifier: ProductDetailVC.id) as! ProductDetailVC
            vc.productId = product.id
            vc.product = product
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        default :
           return
        }
    }
    
    func reloadData() {
        productPagination = nil
        self.showNavigationBarloader()
        requestToFetchProductList()
    }
}



extension StoreDetailVC2: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Store".localized)
    }
    
}
