//
//  SearchProductVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/2/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DropDown

class SearchProductVC: UIViewController {

     //MARK:- outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchKeyword: UITextField!
   
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var subcategory: UITextField!
    @IBOutlet weak var subcategoryBtn: UIButton!

    @IBOutlet weak var searchBtn: UIButton!
    
  
    var comeFromAdvanceSearch = false
    //dropdowns
    var categoryDropDown = DropDown()
    var subcategoryDropDown = DropDown()
   
    //MARK: variables
    var selectedCategory: Category?
    var selectedSubcategory: Category?
    var selectedProductData: ProductData?
    var keyword: String?
    var productList = [Product]()
    var productPagination: Pagination?
    
    
    
    //Advance Search Variable
    var defaultSort = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search".localized
        self.setLocalization()
        self.setupView()
    }
   

    override func moveToAdvanceSearchVC() {
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: "AdvanceSearchVC") as! AdvanceSearchVC
        vc.keyword = searchKeyword.text!
        vc.selectedCategory = selectedCategory
        vc.selectedSubcategory = selectedSubcategory
        vc.delegate = self
        vc.comeFromHomeVC = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

private extension SearchProductVC {
    private func setLocalization() {
        self.searchKeyword.placeholder = "Enter Keyword...".localized
        self.category.placeholder = "Category".localized
        self.subcategory.placeholder = "Subcategory".localized
        AppLanguage.updateTextFieldsDirection([
            searchKeyword,
            category,
            subcategory
        ])
    }
}


//MARK:-  setup view
private extension SearchProductVC {
    
    private func setupView()  {
        self.showNavigationBar()
        addBackBarButton()
        setFilterBarButton()
        collectionView.registerCell(id: ProductCollectionViewCell.id)
        self.setupDropDrowns()
        if comeFromAdvanceSearch == false {
            self.showNvLoader()
            self.requestToFetchProductList()
        }
        else {
            updateList(response: selectedProductData)
        }
        
        self.searchKeyword.text = keyword
        self.category.text = selectedCategory?.title ?? ""
        self.subcategory.text = selectedSubcategory?.title ?? ""
        
        collectionView.pullToRefresh {
            self.selectedCategory = nil
            self.selectedSubcategory = nil
            self.searchKeyword.text = ""
            self.keyword = ""
            self.category.text = ""
            self.subcategory.text = ""
            self.productPagination = nil
            self.requestToFetchProductList()
        }
    }
    
    
}


//MARK:-  actions
private extension SearchProductVC {

    @IBAction func searchBtnTapped (_ sender: UIButton) {
        self.view.endEditing(true)
        self.showNvLoader()
        productPagination = nil
        self.requestToFetchProductList()
    }
}


 //MARK:-  AdvanceSearchDelegate
extension SearchProductVC: AdvanceSearchDelegate {
    
    func didFetchProduct(data: ProductData?, superCategory: Category?, subcategory: Category?, keyword: String?) {
        
        self.selectedCategory = superCategory
        self.selectedSubcategory = subcategory
        self.searchKeyword.text = keyword
        self.updateList(response: data)
       
      
        self.category.text = selectedCategory?.title ?? ""
        self.subcategory.text = selectedSubcategory?.title ?? ""
       
        self.defaultSort = false
    }
 
}


  //MARK:-  setup drownDowns

extension SearchProductVC {
  
    
    func setupDropDrowns() {
        setupCategoryDropDown()
        setupSubcategoryDropDown()
       
    }
    
    
    func setupCategoryDropDown(){
        
        var items = ["Category".localized]
        let superCateogries = AppSettings.shared.settingData?.categories
       
        let titls = superCateogries?.compactMap{$0.title} ?? []
        items.append(contentsOf: titls)
        
        categoryDropDown.setData(btn: categoryBtn, dataSource: items)
        categoryDropDown.selectionAction = {[unowned self](index: Int, item: String) in
            if index == 0 {
                
                self.category.text = ""
                self.subcategory.text = ""
                self.selectedCategory = nil
                self.selectedSubcategory = nil
                self.setupSubcategoryDropDown()
                return
            }
            
            
            self.subcategory.text = ""
            self.selectedSubcategory = nil
            self.category.text = item
            self.selectedCategory = superCateogries?[index-1]
            self.setupSubcategoryDropDown()
        }
        
    }
    
    func setupSubcategoryDropDown(){
        
        var items = ["Subcategory".localized]
       
        guard let subcategory = self.selectedCategory else { return }
       
        let subcategories = subcategory.children
        let titles = subcategories?.compactMap{$0.title!} ?? []
        items.append(contentsOf: titles)
       
        subcategoryDropDown.setData(btn: subcategoryBtn, dataSource: items)
        subcategoryDropDown.selectionAction = {[unowned self](index: Int, item: String) in
            if index == 0 {
                self.subcategory.text = ""
                self.selectedSubcategory = nil
                return
            }
            self.subcategory.text = item
            self.selectedSubcategory = subcategories?[index-1]
        }
        
    }
    
    //MARK:-  dropdown actions
    
    @IBAction func categoryBtnTapped(_ sender: UIButton) {
        categoryDropDown.show()
    }
    
    @IBAction func subcategoryBtnTapped(_ sender: UIButton) {
        subcategoryDropDown.show()
    }
}



//MARK:-  Network
extension SearchProductVC {
    
    func requestToFetchProductList() {
        
       
        let nextPage = productPagination?.next ?? 1
        var params: [String: Any] = ["page": nextPage ]
        
        var categories = [String]()
        if let category = selectedCategory {
            categories.append(category.id ?? "")
        }
        if let subcategory = selectedSubcategory {
            categories.append(subcategory.id ?? "")
        }
        
        if categories.count > 0 {
            params.updateValue(categories, forKey: "categories")
        }
        
        if keyword?.count ?? 0 > 0{
            params.updateValue(keyword ?? "", forKey: "keyword")
        }
        
        if searchKeyword.text?.trim.count ?? 0 > 0 {
            params.updateValue(searchKeyword.text!, forKey: "keyword")
        }
        
//        if let location = mySelectedLocation {
//            params.updateValue([location.longitude, location.latitude], forKey: "location")
//        }
//
//
//        if topRated.isSelected {
//            params.updateValue("topRated", forKey: "sortOrder")
//        }
//
//        if nearBy.isSelected {
//            params.updateValue("nearBy", forKey: "sortOrder")
//        }
//
//        if highToLow.isSelected {
//            params.updateValue("highLow", forKey: "priceOrder")
//        }
//
//        if lowToHigh.isSelected {
//            params.updateValue("lowHigh", forKey: "priceOrder")
//        }
        
        
        
        
        
        ProductManager.shared.fetchProductList(params: params, defaultSort: defaultSort) { (result) in
            self.hideNvloader()
            ProgressHUD.dismiss(animated: true)
            self.collectionView.stopLoader()
            
            switch result {
            case .sucess(let root):
                self.updateList(response: root.data)
                
            case .failure(let error):
                self.collectionView.setEmptyView(message: error)
            }
            
        }
    }
    
    func updateList(response: ProductData? )  {
        self.collectionView.backgroundView = nil
        productPagination = response?.pagination
        
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

 //MARK:-  collection cell layout
extension SearchProductVC: UICollectionViewDelegateFlowLayout {
    
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
        return UIEdgeInsets (top: 0, left: 8, bottom: 8, right: 8)
    }
}


 //MARK:-  collection dataSource
extension SearchProductVC: UICollectionViewDataSource,UICollectionViewDelegate {
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
        
        if (collectionView.contentOffset.y + collectionView.frame.size.height) >= collectionView.contentSize.height {
            let fetchMore = MyPagination.shared.checkFetchMore(model: productPagination)
            if fetchMore {
                ProgressHUD.present(animated: true)
                self.requestToFetchProductList()
            }
            
        }
    }
    
}

extension SearchProductVC: CallBackDelegate {
    func reloadData() {
        productList.removeAll()
        productPagination = nil
        self.showNvLoader()
        self.requestToFetchProductList()
    }
    
    
}
