//
//  ManageProductVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/24/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DropDown



enum ProductType: String {
    case simple
    case stock
    case configurable
    case none
}


class ManageProductVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productTypeBtn: UIButton!
    //bottom view
    @IBOutlet weak var restockBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var outofStockLabel: UILabel!
    @IBOutlet weak var collectionViewBottomSpaceConstraint: NSLayoutConstraint!
    
    
    //MARK: variables
    var productList = [Product]()
    var productPagination: Pagination?
    let productTypeDropDown = DropDown()
    var isProductsOutOfStock = false
    var isRestockAPICall = false
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Manage Products".localized
        showNavigationBar()
        addBackBarButton()
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
      
        setupView()
    }
    
    
    override func backToMain() {
        if isRestockAPICall == false {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.showRestockListing()
        }
    }
    
    
    func showRestockListing()  {
       self.showNvLoader()
       self.productPagination = nil
       self.isRestockAPICall = false
       self.isProductsOutOfStock = false
       self.requestToFetchProductList()
    }
    
   
    
    
    @IBAction func restockBtnTapped(_ sender: Any) {
        
       
        if isProductsOutOfStock == true && isRestockAPICall == false {
            self.showNvLoader()
            self.productPagination = nil
            self.isRestockAPICall = true
            self.requestToFetchProductList()
        }
        else {
            self.showRestockListing()
        }
        
        
    }
    
    @IBAction func restockDissmissBtnTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
             self.isRestockAPICall = false
             self.isProductsOutOfStock = false
             self.collectionViewBottomSpaceConstraint.constant = 0
        }
        
       
    }
    
   
    
    
    
    
    
    func setupView()  {
      
        collectionView.registerCell(id: ManageProductCollectionViewCell.id)
        //customize bar button image tint
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AddWhite")?.withRenderingMode(.alwaysTemplate)
        self.productTypeBtn.setImage(imageView.image, for: .normal)
        imageView.tintColor = .white
        //dropdown
        productTypeDropDownSetup()
        
        //api call
         self.showNvLoader()
         self.productPagination = nil
         self.isRestockAPICall = false
         self.isProductsOutOfStock = false
         self.requestToFetchProductList()
    }
    
    
}

 //MARK:- drop down setup
extension ManageProductVC {
    
    
    
    @IBAction func addBtnTapped() {
        productTypeDropDown.show()
    }
    
    func productTypeDropDownSetup() {
        let ds = ["Simple Product".localized,
                  "Stock Product".localized,
                  "Configurable Product".localized]
        productTypeDropDown.setData(btn: self.productTypeBtn, dataSource: ds)
        dropDownActionHandler()
    }
    
    fileprivate func dropDownActionHandler() {

        productTypeDropDown.selectionAction = {[unowned self](index: Int, item: String) in
            var productType = ProductType.none
            switch index {
            case 0:
                productType = .simple
            case 1:
                productType = .stock
            case 2 :
                productType = .configurable
                let s = AppConstant.storyBoard.product
                let vc = s.instantiateViewController(withIdentifier: AddConfigurableProductVC.id) as! AddConfigurableProductVC
                vc.delegate = self
                vc.productType = productType
                self.navigationController?.pushViewController(vc, animated: true)
                return
            default:
                nvMessage.showInfo(body: "Future Implementation")
                return
            }
            
            
            let s = AppConstant.storyBoard.product
            let vc = s.instantiateViewController(withIdentifier: AddSimpleProductVC.id) as! AddSimpleProductVC
            vc.delegate = self
            vc.productType = productType
            self.navigationController?.pushViewController(vc, animated: true)

        }

    }
}


 //MARK:-  AddSimpleProductVCDelegate
extension ManageProductVC: AddSimpleProductVCDelegate {
    func didAddedProduct() {
        self.productPagination = nil
        self.showNvLoader()
        self.requestToFetchProductList()
    }

}

//MARK:-  API Request
extension ManageProductVC {
   
    //fetch Product list
    
    func requestToFetchProductList() {
        
        collectionView.backgroundView = nil
        
        
        // params
        let perPage =  "\(MyPagination.shared.perPage)"
        let nextPage = "\(productPagination?.next ?? 1)"

       
       var queryItems: [URLQueryItem] = []

        queryItems.append(URLQueryItem(name: "pagination", value: perPage))
        queryItems.append(URLQueryItem(name: "page", value: nextPage))
        queryItems.append(URLQueryItem(name: "showRestockProducts",
                                       value: "\(isProductsOutOfStock)"))
       //request
        ProductManager.shared.fetchManageProductList(queryItems: queryItems) { (result) in

            self.hideNvloader()
            ProgressHUD.dismiss(animated: true)
            switch result {
            case .sucess(let root):
              self.updateList(response: root.data)
             case .failure(let error):
                self.collectionView.setEmptyView(message: error)
            }
            
        }
    }
    
    //update ui
    func updateList(response: ProductData? )  {
        
        self.productPagination = response?.pagination
        
        // restock view handling
        let countOutOfStock = response?.productsOutOfStock ?? 0
        if countOutOfStock > 0 && self.isRestockAPICall == false {
            self.outofStockLabel.text = "You have \(countOutOfStock) product(s) out of stock. To re-stock"
            self.isProductsOutOfStock = true
            UIView.animate(withDuration: 0.5) {
                self.collectionViewBottomSpaceConstraint.constant = 75
                self.bottomView.backgroundColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 0.1776005993)
                self.dismissBtn.isHidden = false
            }
           
        }
        else {   // hide bottom view
            UIView.animate(withDuration: 0.5) {
            self.collectionViewBottomSpaceConstraint.constant = 0
            }
        }
        // change bottom view appearance - if restock api hit
        if self.isRestockAPICall == true {
           self.isProductsOutOfStock = false
           self.outofStockLabel.text = "View all products"
            UIView.animate(withDuration: 0.5) {
                self.collectionViewBottomSpaceConstraint.constant = 75
                self.bottomView.backgroundColor = #colorLiteral(red: 0.6392156482, green: 0.9019611478, blue: 0.4352941215, alpha: 0.1840753425)
                self.dismissBtn.isHidden = true
            }
          
        }
        if countOutOfStock == 0 && self.isRestockAPICall == false && self.isProductsOutOfStock == false {
            
            UIView.animate(withDuration: 0.5) {
            self.collectionViewBottomSpaceConstraint.constant = 0
            }
            
        }
      
      
        
        //pagination
        if productPagination?.page ?? 0 == 1 {
            self.productList = response?.collection ?? []
            collectionView.reloadData()
            
            if productList.count == 0 {
                collectionView.setEmptyView()
            }
        }
        else {
            self.productList.append(contentsOf: response?.collection ?? [])
            self.collectionView.reloadData()
        }
   }
    
    func requestToFetchProdcutDetail(productId: String?)  {
       
        guard let id = productId else {
            nvMessage.showError(body: "Product ID not found".localized)
            return
        }
        self.showNvLoader()
        ProductManager.shared.productDetail(productID:id) { (response) in
            self.hideNvloader()
            switch response {
            case .sucess(let root):
                let product = root.data
                self.moveToAddProductScreen(product: product)
            case .failure(let error):
                nvMessage.showError(body: error)
                
            }
        }
    }
    
    func moveToAddProductScreen(product: ProductDetail?)  {
        guard let product = product else {
            nvMessage.showError(body: "Product detail not found".localized)
            return
            
        }
        
        guard let productType = ProductType(rawValue: product.productType ?? "none") else {
            nvMessage.showError(body: "Product detail not found".localized)
            return
        }
        switch productType {
        case .simple, .stock:
            let s = AppConstant.storyBoard.product
            let vc = s.instantiateViewController(withIdentifier: AddSimpleProductVC.id ) as! AddSimpleProductVC
            vc.delegate = self
            vc.productType = productType
            vc.product = product
            self.navigationController?.pushViewController(vc, animated: true)
        
        case .configurable:
            let s = AppConstant.storyBoard.product
            let vc = s.instantiateViewController(withIdentifier:
                AddConfigurableProductVC.id) as! AddConfigurableProductVC
            vc.delegate = self
            vc.productType = productType
            vc.product = product
            self.navigationController?.pushViewController(vc, animated: true)

        default:
           return
           
        }

    }
    
    
    // Remove Product
    func requestToDeleteProduct(product: Product)  {
        guard let productId = product.id else {
            return nvMessage.showError(body: "Product Id not found".localized)
        }
      
        
        showNvLoader()
        ProductManager.shared.deleteProductBy(productId: productId) { (response) in
            self.hideNvloader()
            switch response {
            case .sucess(let root):
                nvMessage.showSuccess(body:  root.message ?? "server message not found", closure: {
                    self.deleteProductFromProductList(product: product)
                })
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
    }
    
    func deleteProductFromProductList(product: Product)  {
        if let index = productList.firstIndex(of: product) {
            productList.remove(at: index)
        }
        
        
        if productList.count == 0 {
            collectionView.reloadData()
            collectionView.setEmptyView()
        }
        else {
            collectionView.backgroundView = nil
            collectionView.reloadData()
        }
        
    }

   
}

 //MARK:-  collectionview layout
extension ManageProductVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSpace: CGFloat =  12
        let collectionViewSize = collectionView.frame.size.width * 0.50
        
        return CGSize(width: collectionViewSize - cellSpace , height: 305)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 8, left: 8, bottom: 8, right: 8)
    }
}


 //MARK:-  collectionview implementation
extension ManageProductVC: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManageProductCollectionViewCell.id, for: indexPath) as! ManageProductCollectionViewCell
        let product = productList[indexPath.row]
        cell.product = product
        cell.deleteBtn.onTap {
            let msg = "Do you want to delete the product?"
            self.view.presentAlert(message: msg, yes: {
                self.requestToDeleteProduct(product: product)
            }, no: nil)
        }
        cell.editBtn.onTap {
            self.requestToFetchProdcutDetail(productId: product.id)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let product = productList[indexPath.row]
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: ProductDetailVC.id) as! ProductDetailVC
        vc.productId = product.id
        vc.product = product
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (collectionView.contentOffset.y + collectionView.frame.size.height) >= collectionView.contentSize.height - 10 {
            let fetchMore = MyPagination.shared.checkFetchMore(model: productPagination)
            if fetchMore {
                ProgressHUD.present(animated: true)
                self.requestToFetchProductList()
            }
            
        }
    }
    
}



extension ManageProductVC: CallBackDelegate {
    func reloadData() {
         productList.removeAll()
         self.showNvLoader()
         self.productPagination = nil
         self.isRestockAPICall = false
         self.isProductsOutOfStock = false
         self.requestToFetchProductList()
    }
    
    
}
