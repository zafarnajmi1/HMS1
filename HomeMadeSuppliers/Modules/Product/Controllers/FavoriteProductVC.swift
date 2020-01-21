//
//  FavoriteProductVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/20/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class FavoriteProductVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
     //MARK: variables
    var productList = [Product]()
    var productPagination: Pagination?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favourite Products".localized
        addBackBarButton()
        showNavigationBar()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }


    func setupView()  {
       
        collectionView.registerCell(id: ProductCollectionViewCell.id)
        //api call
        self.showNvLoader()
        self.requestToFetchProductList()
    }
}

//MARK:-  pagination implementation
extension FavoriteProductVC {
    
    func requestToFetchProductList() {
        
        let perPage =  MyPagination.shared.perPage
        let nextPage = productPagination?.next ?? 1
        var params: [String: Any] = ["pagination": perPage, "page": nextPage ]
        
        params.updateValue(true, forKey: "showFavorites")
       
        
        ProductManager.shared.fetchProductList(params: params) { (result) in
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
    
    func updateList(response: ProductData? )  {
        
        self.productPagination = response?.pagination
        
        if productPagination?.page ?? 0 == 1 {
            self.productList = response?.collection ?? []
            self.reloadCollectionView()        }
        else {
            self.productList.append(contentsOf: response?.collection ?? [])
            self.collectionView.reloadData()
        }
        
        
    }
    
    func reloadCollectionView()  {
        
         collectionView.reloadData()
        
        if productList.count == 0 {
            collectionView.setEmptyView()
        }
        
       
        
    }
}


extension FavoriteProductVC: UICollectionViewDelegateFlowLayout {
    
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



extension FavoriteProductVC: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as! ProductCollectionViewCell
        let product = productList[indexPath.row]
        cell.loadCell(model: product)
        cell.delegate = self
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

extension FavoriteProductVC: CallBackDelegate {
    func reloadData() {
        productList.removeAll()
        productPagination = nil
        self.showNvLoader()
        self.requestToFetchProductList()
    }
    
    
}


