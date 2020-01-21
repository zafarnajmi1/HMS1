//
//  HomeVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/21/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import DropDown
import GoogleMaps
import CoreLocation


class HomeVC: BadgeCountVC {

     //MARK:- outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var searchStoreToggleBtn: UIButton!
    @IBOutlet weak var searchKeyword: UITextField!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var cityTextField : UITextField!
    @IBOutlet weak var categoryCollectionView : UICollectionView!
    @IBOutlet weak var subcategoryCollectionView : UICollectionView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var bottomView: HomeBottomView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationCloseBtn: UIButton!
  //  @IBOutlet weak var subcategoriesHeight: NSLayoutConstraint!
    @IBOutlet weak var lc_topCollectionBottom: NSLayoutConstraint!
    @IBOutlet weak var lc_bottomCollectionBottom: NSLayoutConstraint!
    @IBOutlet weak var address: UITextField!
     
    
         
    //MARK:-  properties
    var stores = [Store]()
    var selectedCity: City?
    let cityDropDown = DropDown()
    
    //category
    var categories = [Category]()
    var selectedCategory: Category?
    var selectedSubCategory: Category?
    var mySelectedLocation: CLLocationCoordinate2D?
   // var delegate: HomeControllerDelegate?
    
   
    
    //MARK:-  class ovverides functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        //Receiving a notification
       // setupSideMenu1()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.hideNavigationBar()
        setupView()
        setLocalization()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
   
    
    
    private func setLocalization() {
        self.searchKeyword.placeholder = "Search...".localized
        self.address.placeholder = "Select Location".localized
        self.cityTextField.placeholder = "City".localized
        self.cityTextField.text = "City".localized
        AppLanguage.updateTextFieldsDirection([searchKeyword, address])
    }
    
     //MARK:-  methods
    
    func setupView() {
       
        setupCityDropDown()
        bottomView.isHidden = true
    
        
        self.selectedCategory = nil
        self.selectedSubCategory = nil
        self.categories.removeAll()
        categories = AppSettings.shared.settingData?.categories ?? []
        categoryCollectionView.collectionViewLayout.invalidateLayout()
        categoryCollectionView.reloadData()
       
       // subcategoriesHeight.constant = 0
        subcategoryCollectionView.isHidden = true
        lc_topCollectionBottom.priority = UILayoutPriority(rawValue: 999)
        lc_bottomCollectionBottom.priority = UILayoutPriority(rawValue: 250)
        
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.animate(toZoom: 12)
        
    
        // default supplier list selected
        searchStoreToggleBtn.isSelected = true
        tableView.isHidden = false
        headerView.backgroundColor = .white
        
        tableView.registerCell(id: StoreTableViewCell.id)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        requestToFetchStoreList()
        
       AppLanguage.updateUIScreenDirection()
    }
    

    //MARK:-  actions
    @IBAction func searchBtnTapped (_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: SearchProductVC.id) as! SearchProductVC
        vc.keyword = searchKeyword.text!
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func filterBtnTapped (_ sender: UIButton) {
        self.view.endEditing(true)
        
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: AdvanceSearchVC.id) as! AdvanceSearchVC
        vc.keyword = searchKeyword.text!
        vc.comeFromHomeVC = true
     
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func searchStoreToggleBtnTapped (_ sender: UIButton) {
        if sender.isSelected == false {
            tableView.isHidden = false
            headerView.backgroundColor = .white
            sender.isSelected = true
        }
        else {
            tableView.isHidden = true
            headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            sender.isSelected = false
        }
    }
    
   
    
    
    @IBAction func sideMenuBtnTapped(_ sender: UIButton)  {
       
        AppSettings.shared.showMenu(self)
    }
   
   
}

 //MARK:-  api Requests
extension HomeVC {
    func requestToFetchStoreList() {
        
        tableView.backgroundView = nil
        
       // var parts: [String] = []
       // parts.append("page=1")
        let page = 1
        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        
        if let cityId = selectedCity?.id {
             queryItems.append(URLQueryItem(name: "city", value:  "\(cityId)"))
        }
        
        
        if let categoryId = selectedCategory?.id {
          
            queryItems.append(URLQueryItem(name: "categories[0]", value:  "\(categoryId)"))
        }
        if let subcategoryId = selectedSubCategory?.id {
             //parts.append("categories[1]=\(subcategoryId)")
            queryItems.append(URLQueryItem(name: "categories[1]", value:  "\(subcategoryId)"))
        }
        

        
        if let location = mySelectedLocation {
           queryItems.append(URLQueryItem(name: "location[0]", value:  "\(location.longitude)"))
           queryItems.append(URLQueryItem(name: "location[1]", value:  "\(location.latitude)"))
        }
        
     
      
        
        self.showNvLoader()
        StoreManager.shared.fetchStoreList(queryItems: queryItems) { (result) in
            self.hideNvloader()
            ProgressHUD.dismiss(animated: true)
            switch result {
            case .sucess(let root):
                let collection = root.data?.collection ?? []
                self.stores = collection.filter({$0.locationSetting == true})
                self.updateView()
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
    func updateView()  {
        
        if stores.count == 0 {
            mapView.clear()
            tableView.reloadData()
            tableView.setEmptyView()
            self.bottomView.isHidden = true

        }
        else {
            self.loadPinsOnMap()
            self.bottomView.stores = self.stores
            self.bottomView.delegate = self
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                  self.bottomView.isHidden = false
            }, completion: nil)
         }
    }
}

 //MARK:-  dropdowns
extension HomeVC {
   
    
    @IBAction func DropdownAction(_ sender: UIButton) {
        cityDropDown.show()
    }
    
    func setupCityDropDown(){
        
        var items = ["City".localized]
        let superCateogries = AppSettings.shared.settingData?.cities ?? []
        
        let titls = superCateogries.compactMap{$0.title}
        items.append(contentsOf: titls)
        
        cityDropDown.setData(btn: cityBtn, dataSource: items)
        cityDropDown.selectionAction = {[unowned self](index: Int, item: String) in
            if index == 0 {
                self.cityTextField.text = "City".localized
                self.cityTextField.placeholder = "City".localized
                self.selectedCity = nil
                self.requestToFetchStoreList()
                return
            }
            
            self.cityTextField.text = item
            self.selectedCity = superCateogries[index-1]
            self.requestToFetchStoreList()
        }
        
    }
}

//MARK:-  collection view implementation
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //subcategory cell size
        if collectionView == subcategoryCollectionView {
            if let title = selectedCategory?.children?[indexPath.row].title {
                let width = title.size(withAttributes: nil).width
                let paddingLR: CGFloat = 30
                return CGSize(width: width + paddingLR, height: 29)
            }
            return CGSize(width: 20, height: 20)
        }
        else {
            //category cell size
            return CGSize(width: 100, height: 115)
            
        }
    }
}



extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        }
        if collectionView == subcategoryCollectionView {
            
            return selectedCategory?.children?.count ?? 0
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath) as! CategoryCollectionViewCell
            
            let model = categories[indexPath.row]
            cell.setData(model: model)
            
            if selectedCategory?.id == model.id {
                cell.myImage.borderColor = #colorLiteral(red: 0.9254901961, green: 0.1137254902, blue: 0.1490196078, alpha: 1)
            }
            else {
                cell.myImage.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9058823529, blue: 0.9098039216, alpha: 1)
            }
            
            return cell
        }
        
        if collectionView == subcategoryCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubcategoryCollectionViewCell.id, for: indexPath) as! SubcategoryCollectionViewCell
            
            let model = selectedCategory?.children![indexPath.row]
            cell.setData(model: model!)
            
            if selectedSubCategory?.id == model?.id {
                cell.title.borderColor = #colorLiteral(red: 0.9254901961, green: 0.1137254902, blue: 0.1490196078, alpha: 1)
            }
            else {
                cell.title.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9058823529, blue: 0.9098039216, alpha: 1)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    
   
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
         
            handleCategoryToggleSelection(indexPath)
          
           
        }
        
        if collectionView == subcategoryCollectionView {
            handleSubcategoryToggleSelection(indexPath)
        }
    }
    
     func handleCategoryToggleSelection(_ indexPath: IndexPath) {
        self.selectedSubCategory = nil
       
        let category = categories[indexPath.row]
        
        //if category is selected (unselect category)
        if selectedCategory?.id == category.id {
            
            selectedCategory = nil
            categoryCollectionView.collectionViewLayout.invalidateLayout()
            subcategoryCollectionView.reloadData()
            UIView.animate(withDuration: 0.5) {
                // self.subcategoriesHeight.constant = 30
                self.subcategoryCollectionView.isHidden = true
                self.lc_topCollectionBottom.priority = UILayoutPriority(rawValue: 999)
                self.lc_bottomCollectionBottom.priority = UILayoutPriority(rawValue: 250)
            }
            
        }
        else {// if Category is unselected (then load subcategories from selected category)
            selectedCategory = category
            categoryCollectionView.collectionViewLayout.invalidateLayout()
            subcategoryCollectionView.reloadData()
       
           // self.subcategoriesHeight.constant = 30
            subcategoryCollectionView.isHidden = false
            lc_topCollectionBottom.priority = UILayoutPriority(rawValue: 250)
            lc_bottomCollectionBottom.priority = UILayoutPriority(rawValue: 999)
           
        }
        
        categoryCollectionView.collectionViewLayout.invalidateLayout()
      
        categoryCollectionView.reloadData()
       
        self.requestToFetchStoreList()
    }
   
    
    
    
    func handleSubcategoryToggleSelection(_ indexPath: IndexPath) {
        let subcategory = selectedCategory?.children?[indexPath.row]
       
        if selectedSubCategory?.id == subcategory?.id {
            selectedSubCategory = nil
        }
        else {
            selectedSubCategory = subcategory
        }
        subcategoryCollectionView.collectionViewLayout.invalidateLayout()
       
        subcategoryCollectionView.reloadData()
        requestToFetchStoreList()
    }
    
    
}
 //MARK:-  tableView Implementation
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.id) as! StoreTableViewCell
        let store = stores[indexPath.row]
        cell.setData(model: store)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = stores[indexPath.row]
        
        let s = AppConstant.storyBoard.main
        let vc = s.instantiateViewController(withIdentifier: StorePagerVC.id) as! StorePagerVC
        vc.store = store
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


 //MARK:-  BottomView Impelementation
extension HomeVC : HomeBottomViewDelegate{
    func didSelect(object: Store) {
        let s = AppConstant.storyBoard.main
        let vc = s.instantiateViewController(withIdentifier: StorePagerVC.id) as! StorePagerVC
        vc.store = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func itemScrolled(lastIndex : Int, index: Int) {
        let lastImageView = stores[lastIndex].marker?.iconView as! UIImageView
        lastImageView.image = UIImage(named: "PinLocationRed2")
        let store = stores[index]
        zoomMapAtLocation(object: store)
        let currentImageView = store.marker?.iconView as! UIImageView
        currentImageView.image = UIImage(named: "PinLocationRed2")
    }
    
    
}
extension HomeVC: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("You tapped at marker : \(marker.iconView?.tag ?? -1)")
        let lastIndex = bottomView.currentIndex
    
        
        
        let imageView = stores[lastIndex].marker?.iconView as! UIImageView
        imageView.image = UIImage(named: "PinLocationRed2")
        
        if let index = marker.iconView?.tag{
            bottomView.scroll(to: index)
        }
        
        
        return true
    }
    
}

//MARK:-  location setup
extension HomeVC {
    func resetSelectedLocation() {
        self.address.text = ""
        self.mySelectedLocation = nil
    }
    
    func didSelectLocation() {
        self.locationCloseBtn.isHidden = false
        zoomMapAtLocation()
        self.requestToFetchStoreList()
    }
    
    @IBAction func locationCloseBtnTapped(_ sender: UIButton)  {
        
        resetSelectedLocation()
        self.locationCloseBtn.isHidden = true
        self.requestToFetchStoreList()
        
    }
    @IBAction func locationBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let picker = LocationPickerController()
        picker.open { (coordinates, address) in
            self.mySelectedLocation = coordinates
            self.address.text = address
            self.didSelectLocation()
        }
        
    }
    
    
}
