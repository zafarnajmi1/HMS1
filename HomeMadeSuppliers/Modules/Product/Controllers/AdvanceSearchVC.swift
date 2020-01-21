//
//  AdvanceSearchVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/2/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import RangeSeekSlider
import DLRadioButton
import DropDown
import CoreLocation

protocol AdvanceSearchDelegate: class {
    func didFetchProduct(data:ProductData?,
                  superCategory: Category?,
                  subcategory: Category?,
                  keyword: String?)
}

class AdvanceSearchVC: UIViewController {

    //MARK:- outlets
   
    @IBOutlet weak var searchKeyword: UITextField!
    @IBOutlet weak var slider: RangeSeekSlider!
    @IBOutlet weak var priceRangeLabel: UILabel!
    
    @IBOutlet weak var topRated: UIButton!
    @IBOutlet weak var nearBy: UIButton!
    @IBOutlet weak var priceCriteriaLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var highToLow: UIButton!
    @IBOutlet weak var lowToHigh: UIButton!
  
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var subcategory: UITextField!
    @IBOutlet weak var subcategoryBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchBtnBottom: UIButton!
    @IBOutlet weak var minRange: UITextField!
    @IBOutlet weak var maxRange: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var lbltoprated: UILabel!
    @IBOutlet weak var lblNearBy: UILabel!
    @IBOutlet weak var lblhightolow: UILabel!
    @IBOutlet weak var lbllowtohigh: UILabel!
    
    //dropdowns
    var delegate: AdvanceSearchDelegate?
    var comeFromHomeVC = false
    var categoryDropDown = DropDown()
    var subcategoryDropDown = DropDown()
    
    //MARK: variables
    var selectedCategory: Category?
    var selectedSubcategory: Category?
    var keyword: String?
    var productList = [Product]()
    var productPagination: Pagination?
    private var mySelectedLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Advanced Search".localized
        
        setupView()
        setLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        self.showNavigationBar()
        addBackBarButton()
    }
    func setupView() {
        
        setupDropDrowns()
        minRange.text = "\(0)"
        maxRange.text = "\(10000)"
        
        minRange.delegate = self
        maxRange.delegate = self
        slider.minValue = 0
        slider.maxValue = 10000
        slider.selectedMinValue = 0
        slider.selectedMaxValue = 10000
        //label.text = myDefaultCurrencySymple + "10000"
        self.searchKeyword.text = keyword
        
        category.text = selectedCategory?.title ?? ""
        subcategory.text = selectedSubcategory?.title ?? ""
        
        slider.delegate = self
        minRange.delegate = self
        maxRange.delegate = self
        minRange.addTarget(self, action: #selector(minRangeTextFieldChanged), for: .editingChanged)
        maxRange.addTarget(self, action: #selector(maxRangeTextFieldChanged), for: .editingChanged)
        
 }
    
  //MARK:->  Radio Button Action
    
    @IBAction func topRated(_ sender: UIButton) {
        self.topRated.isSelected = true
        self.nearBy.isSelected = false
    }
    
    @IBAction func nearBy(_ sender: UIButton) {
        self.topRated.isSelected = false
        self.nearBy.isSelected = true
    }
    
    @IBAction func hightolow(_ sender: UIButton) {
        self.highToLow.isSelected = true
        self.lowToHigh.isSelected = false
    }
    
    @IBAction func lowtohigh(_ sender: UIButton) {
        self.highToLow.isSelected = false
        self.lowToHigh.isSelected = true
    }
    
    
    //MARK:-  actions
    @IBAction func searchBtnTapped (_ sender: UIButton) {
       self.view.endEditing(true)
       self.requestToFetchProductList()
     
    }
    
    override func moveToAdvanceSearchVC() {
        self.view.endEditing(true)
        
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: "AdvanceSearchVC") as! AdvanceSearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

 //MARK:-  localization
private extension AdvanceSearchVC {
    func setLocalization () {
        priceRangeLabel.text = "Price Range".localized
        locationLabel.text = "Location".localized
        priceCriteriaLabel.text = "Price Criteria".localized
        self.lbltoprated.text =  "Top Rated".localized
        self.lblNearBy.text =  "Near By".localized
        self.lblhightolow.text = "High To Low".localized
        self.lbllowtohigh.text = "Low To High".localized
        searchBtnBottom.setTitle("Search".localized, for: .normal)
      
        category.placeholder = "Select Category".localized
        subcategory.placeholder = "Select Subcategory".localized
        searchKeyword.placeholder = "Enter Keyword...".localized
        minRange.placeholder = "Min Price".localized
        maxRange.placeholder = "Max Price".localized
        address.placeholder = "Select Location".localized
        
        AppLanguage.updateTextFieldsDirection([
        category, subcategory, searchKeyword,
        minRange,maxRange,address
        ])
    }
}


extension AdvanceSearchVC: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        minRange.text = "\(Int(minValue))"
        maxRange.text = "\(Int(maxValue))"
    }
}



 //MARK:-  textfield delegates
extension AdvanceSearchVC: UITextFieldDelegate {
    @objc func minRangeTextFieldChanged(){
        
        if minRange.text?.count == 0 {
          
          slider.selectedMinValue = 0
          slider.setNeedsLayout()
        
        }

        guard let minNumber = NumberFormatter().number(from:  minRange.text ?? "0") else {return }
        guard let maxNumber = NumberFormatter().number(from: maxRange.text ?? "0") else {
            let minFloat = CGFloat(truncating: minNumber)
            if minFloat < 10000 {
                slider.selectedMinValue = minFloat
                slider.selectedMaxValue = minFloat + 1
                slider.setNeedsLayout()
            }
            return
            
        }
        let minFloat = CGFloat(truncating: minNumber)
        let maxFloat = CGFloat(truncating: maxNumber)
        if minFloat < maxFloat {
            slider.selectedMinValue = minFloat
            slider.setNeedsLayout()
        }
        
    }
    
    @objc func maxRangeTextFieldChanged(){

        
        if maxRange.text?.count == 0 && minRange.text?.count == 0 {
            minRange.text = "0"
            slider.selectedMinValue = 0
            slider.selectedMaxValue = 1
            slider.setNeedsLayout()
            return
        }
        guard let minNumber = NumberFormatter().number(from:  minRange.text ?? "0") else {return }
        guard let maxNumber = NumberFormatter().number(from: maxRange.text ?? "0") else {return }
        let minFloat = CGFloat(truncating: minNumber)
        let maxFloat = CGFloat(truncating: maxNumber)
        if minFloat < maxFloat {
            slider.selectedMaxValue = maxFloat
            slider.setNeedsLayout()
        }

    }
    
    
    
}








//MARK:-  setup drownDowns

extension AdvanceSearchVC {
    
    
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
            
            self.category.text = item
            self.subcategory.text = ""
            self.selectedSubcategory = nil
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



//MARK:-  pagination implementation
extension AdvanceSearchVC {
    
    func requestToFetchProductList() {
        
        let perPage =  MyPagination.shared.perPage
        let nextPage = productPagination?.next ?? 1
        var params: [String: Any] = ["pagination": perPage, "page": nextPage ]
        
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
        
        if searchKeyword.text?.trim.count ?? 0 > 0{
            params.updateValue(searchKeyword.text!, forKey: "keyword")
        }
        
        if let location = mySelectedLocation {
            params.updateValue([location.longitude, location.latitude], forKey: "location")
        }
        
        
        if topRated.isSelected {
             params.updateValue("topRated", forKey: "sortOrder")
        }
        
        if nearBy.isSelected {
            params.updateValue("nearBy", forKey: "sortOrder")
        }
        
        if highToLow.isSelected {
            params.updateValue("highLow", forKey: "priceOrder")
        }
        
        if lowToHigh.isSelected {
            params.updateValue("lowHigh", forKey: "priceOrder")
        }
        
        //add price range filter
        params.updateValue(slider.selectedMinValue, forKey: "minPrice")
        params.updateValue(slider.selectedMaxValue, forKey: "maxPrice")
        params.updateValue(myDefaultCurrency.rawValue, forKey: "currency")
        
        self.showNvLoader()
        ProductManager.shared.fetchProductList(params: params, defaultSort: false) { (result) in
            self.hideNvloader()
            ProgressHUD.dismiss(animated: true)
            switch result {
            case .sucess(let root):
                
               
                
                self.moveToSearchProductVC(obj: root.data)
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
    

    func moveToSearchProductVC(obj: ProductData?) {
        
        if comeFromHomeVC == true {
            let s = AppConstant.storyBoard.product
            let vc = s.instantiateViewController(withIdentifier: SearchProductVC.id) as! SearchProductVC
            vc.comeFromAdvanceSearch = true
            vc.keyword = searchKeyword.text!
            vc.selectedCategory = selectedCategory
            vc.selectedSubcategory = selectedSubcategory
            vc.selectedProductData = obj
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            self.delegate?.didFetchProduct(data: obj,
                                           superCategory: self.selectedCategory,
                                           subcategory: self.selectedSubcategory,
                                           keyword: self.searchKeyword.text!)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
  

}

extension AdvanceSearchVC {
    @IBAction func locationBtnTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let picker = LocationPickerController()
        picker.open { (coordinates, address) in
            self.mySelectedLocation = coordinates
            self.address.text = address
        }
        
    }
}
