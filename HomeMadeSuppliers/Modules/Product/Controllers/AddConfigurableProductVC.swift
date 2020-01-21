//
//  AddConfigurableProductVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/4/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Segmentio


class AddConfigurableProductVC: UIViewController {

    
    //MARK:-  outlets
      @IBOutlet weak var tableView: UITableView!
      @IBOutlet weak var mySegmentView: Segmentio!
      @IBOutlet weak var tableViewTopSpace: NSLayoutConstraint!
      
      var selectedLocaleType = LocaleType.en
    
    
      // custom type
    enum TableViewSections: Int {
        case top = 0
        case categoryAttribute = 1
        case description = 2
        case configuration = 3
        case bottom = 4
        //total sections
        static let count = 5
      }
    
  
    
    var configurationList = [Configuration]()
    
  
      //shared
      var delegate: AddSimpleProductVCDelegate?
      var productType = ProductType.none
      var product: ProductDetail?
      var isEditProduct  =  false
      //fileprivate
      fileprivate var featuresData:[FeatureData] = []
      fileprivate var AttributesFilteredByCategory:[FeatureData] = [] {
          didSet { self.tableView.reloadData() }
      }
      
    
      fileprivate var paramsRoot = ConfigProductParameters()
   
   
    
     //MARK:-  life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = product == nil ? "Add Product".localized: "Update Product".localized
        self.addBackBarButton()
        self.setupView()
    }
    
     //MARK:-  Methods support
    func setupView()  {
        
          let initialObject = Configuration()
          self.configurationList.insert(initialObject, at: 0)
        
          self.tableView.registerCell(id: AddProductConfigurableTopTableViewCell.id)
          self.tableView.registerCell(id: AddProductConfigurableCheckBoxTableViewCell.id)
          self.tableView.registerCell(id: AddProductConfigurableDescriptionTableViewCell.id)
          self.tableView.registerCell(id: AddProductConfigurationTableViewCell.id)
          self.tableView.registerHeaderFooterCell(id: ButtonHeaderCell.id)
          self.tableView.registerCell(id: ButtonTableViewCell2.id)
          self.tableView.registerHeaderFooterCell(id: SectionTitleTableViewCell.id)
          self.tableView.rowHeight = UITableView.automaticDimension
          self.tableView.estimatedRowHeight = 300
          self.tableViewTopSpace.constant = 0
         // api call
         self.setupSegmentList()
         self.requestToFetchFeaturesList()
    }
    
    
    func setupSegmentList() {
        
        self.mySegmentView.selectedSegmentioIndex = 0
        
        let titleList = ["English",
                         "Arabic"]
        
        var content = [SegmentioItem]()
        
        for title in titleList {
            let tornadoItem = SegmentioItem(title: title , image: nil)
            content.append(tornadoItem)
        }
        
        self.mySegmentView.setupSegmentio(content: content)
        // handle tap event
        self.mySegmentView.valueDidChange = { segmentio, segmentIndex in
            
            switch segmentIndex {
            case 1:
                self.selectedLocaleType = .ar
            default:
                self.selectedLocaleType = .en
            }
           
            self.tableView.reloadData()
            
        }
    }
    
    
    
   
    //MARK:- update existing Product
      func reloadData(product: ProductDetail)  {
        self.isEditProduct = true
         self.tableViewTopSpace.constant = 52
         // textfields
          self.paramsRoot.titleEn = product.titleEn
          self.paramsRoot.titleAr = product.titleAr
          self.paramsRoot.descriptionEn = product.descriptionEn
          self.paramsRoot.descriptionAr = product.descriptionAr
         
//          self.parameters.offer = "\(product.offer?.aed?.amount ?? 0 )"
//          self.parameters.isOffer = product.isOffer
          //categories
          self.paramsRoot.selectedCategoryTitle = product.categories?.first?.title
          self.paramsRoot.selectedSubcategoryTitle = product.categories?.last?.title
          self.paramsRoot.category = product.categories?.first?.id
          self.paramsRoot.subcategory = product.categories?.last?.id
          self.paramsRoot.categories?.removeAll()
          if let categoryId = self.paramsRoot.category {
             self.paramsRoot.categories?.append(categoryId)
          }
          if let subcategoryId = self.paramsRoot.subcategory {
                self.paramsRoot.categories?.append(subcategoryId)
          }
         
          
         

          // category -> filtered features (make selected)> selected feature
          if let categories = product.categories {

              let category = categories.first
              //important
              getFeaturesFilteredBy(categoryId: category?.id)

              for priceable in product.priceables ?? [] {
                  if let index = AttributesFilteredByCategory.firstIndex(where: {$0.id == priceable.feature?.id}) {
                      self.AttributesFilteredByCategory[index].isSelected = true
                      //let selectedFeature = self.featuresFiltered[index]


                  }
              }
          }
          self.realodCombinations(product: product)
          self.tableView.reloadData()
      }

    
    
    func realodCombinations(product: ProductDetail)  {
        guard let combinations = product.combinations else {
            nvMessage.showError(body: "Combinations not found")
            return
        }
        
        self.configurationList.removeAll()
        for (_ , combination) in combinations.enumerated() {
           
            let configuration = Configuration()
            
            
            //textfields setter
            configuration.combination.price = "\(combination.price?.aed?.amount ?? 0)"
            configuration.combination.available = "\(combination.available ?? 0)"
            configuration.combination.isOffer = combination.isOffer ?? false
            configuration.combination.offer = "\(combination.offer?.aed?.amount ?? 0)"
           //-------
            
            
            //dropdowns setup
            let selectedFeatures = AttributesFilteredByCategory.filter({$0.isSelected == true})
            self.paramsRoot.selectedCategoryFeatures = selectedFeatures
            
            configuration.combination.features = self.featureArrayCopy(array: selectedFeatures)
            
            // selected charateristics
            for (_, feature) in (combination.features ?? []).enumerated() {
                
                if let featureIndex =  configuration.combination.features.firstIndex(where: {$0.id == feature}){

                    let selectedFeature = configuration.combination.features[featureIndex]
                    for charId in combination.characteristics ?? [] {
                        
                        if let index = selectedFeature.characteristics?.firstIndex(where: {$0.id == charId}) {
                        configuration.combination.features[featureIndex].characteristics?[index].isSelected = true
                        }
                    }
                }
            }
           
        
            //image collection
            configuration.combination.images.removeAll()
            for item in combination.images ?? [] {
                 let object = ImageCollection()
                 object.isDefault = item.isDefault ?? false
                 object.filePath = item.path
                 object.id = item.id
                 configuration.combination.images.append(object)
             }

            
            
            self.configurationList.append(configuration)
        }
    }
}


//MARK:-  api request
extension AddConfigurableProductVC {
    func requestToFetchFeaturesList()  {
        self.showNvLoader()
        ProductManager.shared.fetchProductFeatureCharacteristics { (response) in
            self.hideNvloader()
            switch response {
            case .sucess(let root):
                self.featuresData = root.data ?? []
            
                if let product = self.product {
                    self.reloadData(product: product)
                }
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
    }
    
    
    func requestToAddProduct(params: [String:Any])  {
        self.showNvLoader()
        ProductManager.shared.addProduct(params: params) { (response) in
            self.hideNvloader()
            switch response {
            case .sucess(let root):
                nvMessage.showSuccess(body: root.message ?? "sucess", closure: {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.didAddedProduct()
                })
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
    }
    
    func requestToUpdateProduct(params: [String:Any])  {
        self.showNvLoader()
        ProductManager.shared.updateProduct(params: params) { (response) in
            self.hideNvloader()
            switch response {
            case .sucess(let root):
                nvMessage.showSuccess(body: root.message ?? "sucess", closure: {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.didAddedProduct()
                })
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
    }
}


 //MARK:-  tableview delegate
extension AddConfigurableProductVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = TableViewSections(rawValue: section) else {
            return 0
        }
        
        switch sectionType {
        case .configuration:
            return 60
        case .categoryAttribute:
            return AttributesFilteredByCategory.count > 0 ? 20:0
        default:
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = TableViewSections(rawValue: indexPath.section) else {
            return 0
        }
        
        switch sectionType {
        case .categoryAttribute:
            return 50
        case .bottom:
            return 70
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        guard let sectionType = TableViewSections(rawValue: section) else {
                   return nil
               }

        switch sectionType {
               case .categoryAttribute:
                  let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionTitleTableViewCell.id) as! SectionTitleTableViewCell
                   return header
        case .configuration:
             let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ButtonHeaderCell.id) as! ButtonHeaderCell
               header.button.onTap {
                   //let sum = self.configurationList.count + 1
                   let emptyObject = Configuration()
                   emptyObject.combination.features = self.featureArrayCopy(array: self.paramsRoot.selectedCategoryFeatures ?? [])
                   self.configurationList.append(emptyObject)
                   self.tableView.reloadData()
               }
               return header
       default:
            return nil
       }
        
        
    }
    
}

 //MARK:-  tableview datasource
extension AddConfigurableProductVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = TableViewSections(rawValue: section) else {
            return 0
        }
        
        switch sectionType {
        case .top, .description, .bottom:
            return 1
        case .categoryAttribute:
            return AttributesFilteredByCategory.count
        case .configuration:
            return self.configurationList.count
//        default:
//            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        
        guard let sectionType = TableViewSections(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch sectionType {
        case .top:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddProductConfigurableTopTableViewCell.id) as! AddProductConfigurableTopTableViewCell
            let isEditProduct = self.product?.id == nil ? false: true
            cell.loadCell(productType: productType,
                          product: paramsRoot,
                          delegate: self,
                          isEditProduct: isEditProduct,
                          localeType: selectedLocaleType )
            return cell
        case .categoryAttribute:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddProductConfigurableCheckBoxTableViewCell.id) as! AddProductConfigurableCheckBoxTableViewCell
            let feature = AttributesFilteredByCategory[indexPath.row]
            cell.loadCell(feature: feature, indexPath: indexPath, delegate: self)
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddProductConfigurableDescriptionTableViewCell.id) as! AddProductConfigurableDescriptionTableViewCell
          
            cell.loadCell(model: paramsRoot, delegarte: self,
                          isEditProduct:  self.isEditProduct,
                          localeType: self.selectedLocaleType)
            return cell
            
            
        case .configuration:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddProductConfigurationTableViewCell.id) as! AddProductConfigurationTableViewCell
            
            let prefix = "Option #".localized
            cell.labelTitle.text = "\(prefix) \(indexPath.row + 1)"
            cell.button.isHidden = indexPath.row == 0 ? true:false
          
            let configuration = self.configurationList[indexPath.row]
            cell.loadCell(configuration: configuration,
                          delegate: self, indexPath: indexPath)

            cell.button.onTap {
                self.deleteConfigCell(indexPath: indexPath)
            }
          
            
            
            return cell
            
        case .bottom:
             let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell2.id) as! ButtonTableViewCell2
             let title = product?.id == nil ? "Add Product".localized: "Update Product".localized
             cell.button.setTitle(title, for: .normal)
             cell.button.onTap {
                self.sendButtonTapped()
            }
             return cell
//        default:
//            return UITableViewCell()
        }
       
      
    }
    
    
}

//MARK:-  button actions
extension AddConfigurableProductVC {
    func sendButtonTapped() {
        self.view.endEditing(true)
        
        if formIsValid() == true {
            guard let params = parametersDictionary() else {
                return nvMessage.showError(body: "Parmeters are missing")
            }
            
            if product == nil {
                self.requestToAddProduct(params: params)
            }
            else {
               self.requestToUpdateProduct(params: params)
            }
            
        }
    }
    
    func parametersDictionary() -> [String: Any]? {
        
      //  var dictionary = self.productParemeters.dictionary
        var dictionary = [String:Any]()
        
        
        dictionary.updateValue(selectedLocaleType.rawValue, forKey: "locale")
        dictionary.updateValue(paramsRoot.titleEn ?? "", forKey: "titleEn")
        dictionary.updateValue(paramsRoot.titleAr ?? "", forKey: "titleAr")
        dictionary.updateValue(paramsRoot.descriptionEn ?? "", forKey: "descriptionEn")
        
        dictionary.updateValue(paramsRoot.descriptionAr ?? "", forKey: "descriptionAr")
        
        
        
        if let category = paramsRoot.category {
            dictionary.updateValue(category, forKey: "category")
        }
        if let subcategory = paramsRoot.subcategory {
            dictionary.updateValue(subcategory, forKey: "subcategory")
        }
        
        if let category = paramsRoot.category, let subcategory = paramsRoot.subcategory {
            let categories = [category,subcategory]
            dictionary.updateValue(categories, forKey: "categories")
        }
        
      
        
        if let productID = product?.id {
            dictionary.updateValue(productID, forKey: "_id")
        }
        
        if  productType == .configurable {
            dictionary.updateValue("configurable", forKey: "productType")
        }
        
        dictionary.updateValue(selectedFeatureIdArray(), forKey: "allFeatures")
        dictionary.updateValue(selectedFeatureIdArray(), forKey: "features")
        dictionary.updateValue(selectedCombinationsArray(), forKey: "combinations")

        
        
        print(dictionary )
        return dictionary
    }
    
    func selectedFeatureIdArray() -> [String] {
       let selectedFeatures = AttributesFilteredByCategory.filter({$0.isSelected == true})
       let selectedFeaturesID  = selectedFeatures.compactMap({$0.id})
       return selectedFeaturesID
    }
    
    func selectedChartericsIdsOffAllCombinations()-> [[String]] {
        var array: [[String]] = []
        
          for (_, configuration) in configurationList.enumerated() {
            let combination = configuration.combination
                   
                   var selectedCharacteristicIDs: [String] = []
                   for feature in combination.features {
                       let selectedCharacteristic =  feature.characteristics?.filter({$0.isSelected == true}).first
                       if let id = selectedCharacteristic?.id {
                            selectedCharacteristicIDs.append(id)
                       }
                      
                   }
                  
                
                array.append(selectedCharacteristicIDs)
               }

        return array
    }
    
    
    func selectedCombinationsArray() -> [[String: Any]] {
        let selectedCombinations = self.configurationList.compactMap({$0.combination})
        var combinationsArray = [[String:Any]]()

        for combination in selectedCombinations {
            
            
            if combination.features.count == 0 {
                nvMessage.showError(body: "features not found")
                return [[:]]
            }
            
            var selectedCharacteristicIDs: [String] = []
            for feature in combination.features {
                let selectedCharacteristic =  feature.characteristics?.filter({$0.isSelected == true}).first
                if let id = selectedCharacteristic?.id {
                     selectedCharacteristicIDs.append(id)
                }
               
            }
           
            let combinationObject: [String: Any] = [
                "characteristics" : selectedCharacteristicIDs,
                "images": getImageArray(imageList: combination.images ),
                "available": combination.available ?? "",
                "price": combination.price ?? "",
                "isOffer": combination.isOffer.string,
                "offer": combination.offer ?? ""]
            
         
           // print(selectedCharacteristicIDs)
            combinationsArray.append(combinationObject)
        }

        return combinationsArray
    }
    
    func getImageArray(imageList: [ImageCollection] ) -> [[String: Any]] {
        var imageArray = [[String:Any]]()
        for image in imageList {
            
            // add new product
            if product?.id == nil {
                var object : [String: Any] = [:]
                let isDefault = image.isDefault == true ? true: false
                //let completeURL = "\(AppNetwork.current.assetsTemp)\(image.filePath ?? "")"
                
                object.updateValue(isDefault, forKey: "isDefault")
                if let fileName = image.filePath {
                    object.updateValue(fileName, forKey: "path")
                }
                imageArray.append(object)
            }// edit product
            else {
                var object : [String: Any] = [:]
                let isDefault = image.isDefault == true ? true: false
                object.updateValue(isDefault, forKey: "isDefault")
                if let id = image.id {
                    object.updateValue(id, forKey: "_id")
                }
                if let fileName = image.filePath {
                    object.updateValue(fileName, forKey: "path")
                    object.updateValue(fileName, forKey: "url")
                }
                imageArray.append(object)
            }
            
        } //end for loop
          
        return imageArray
    }
    

}

//MARK:-  form validation
extension AddConfigurableProductVC {
    
    func formIsValid() -> Bool {
        let title = "Add Product".localized

        if  paramsRoot.category?.count ?? 0 == 0 {
            let msg = "Please select category".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        if  paramsRoot.subcategory?.count ?? 0 == 0 {
            let msg = "Please select subcategory".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }

        if  paramsRoot.titleEn?.count ?? 0 < 2 && selectedLocaleType == .en {
            let msg = "Product name EN is required,  at least 3 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        
        if  paramsRoot.titleAr?.count ?? 0 < 2 && selectedLocaleType == .ar {
            let msg = "Product name AR is required, at least 3 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        let selectedFeatures = AttributesFilteredByCategory.filter({$0.isSelected == true})
               if selectedFeatures.count == 0 {
                   let msg = "Category Attributes selection is required,at least 1 Attribute and maximum 3 Attributes".localized
                              nvMessage.showError(title: title, body: msg)
                              return false
        }


        if  paramsRoot.descriptionEn?.count ?? 0 < 10 && selectedLocaleType == .en {
            let msg = "Description EN is Required, at least 10 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }

        if  paramsRoot.descriptionAr?.count ?? 0 < 10 && selectedLocaleType == .ar {
            let msg = "Description AR is Required, at least 10 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }


        //let selectedCombinations = self.configurationList.compactMap({$0.combination})
        
        if self.configurationList.count > 0 {
            

            for (index, configuration) in configurationList.enumerated() {
                
                let title = "Please fill all inputs of configurataion #\(index + 1)"
//                if let combination = configuration.combination {
                   let combination = configuration.combination
                
                if combination.price?.count ?? 0 == 0 {
                    let msg = "Price is required"
                    nvMessage.showError(title: title, body: msg)
                    return false
                }
                    
                if combination.available?.count ?? 0 == 0 {

                    let msg = "Stock is required"
                    nvMessage.showError(title: title, body: msg)
                    return false
                }
                    
                if combination.isOffer == true && combination.offer?.count ?? 0 == 0 {
                        
                        let msg = "offer Price is required"
                        nvMessage.showError(title: title, body: msg)
                        return false
                }
                
                for feature in combination.features {
                    let selectedCharteriscs = feature.characteristics?.filter({$0.isSelected == true})
                    if selectedCharteriscs?.count ?? 0 == 0 {
                        let msg = "please select \(feature.title ?? "")"
                        nvMessage.showError(title: title, body: msg)
                        return false
                    }
                }

            }
            
        
            
            /// check  combination duplication
            let charteristics = selectedChartericsIdsOffAllCombinations()
            for i in 0..<charteristics.count   {
                var j = i + 1
                while  j<charteristics.count {
    
                    if  charteristics[i] ==  charteristics[j] && charteristics[i].count > 0 {
                     // / got the duplicate element
                        nvMessage.showError(body: "Combination #\(j+1) is equal to combination #\(i+1)")
                        return false
                    }
                   
                    j = j + 1
                }
                
            }
            
            
            
        }// end if
        else {
                let msg = "combinations required"
                nvMessage.showError(title: title, body: msg)
                return false
          }
        

        
        return true
    }
    
}




//MARK:-  delete cell 
extension AddConfigurableProductVC {
    func deleteConfigCell(indexPath: IndexPath) {
     let message = "Do you want to delete the combination?"
        self.presentAlert(message: message, yes: {
           
            if indexPath.row < self.configurationList.count {
                self.configurationList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .none)
            }
        
        }, no: nil)
        
    }
}


 //MARK:-  configCell delegate
extension AddConfigurableProductVC: AddProductConfigurationTableViewCellDelegate {
    func didUpdate(configuration: Configuration?, indexPath: IndexPath) {
        guard  let config = configuration else {
            nvMessage.showError(body: "configuration object not found")
            return 
        }
        self.configurationList[indexPath.row] = config
    }

    
    
}

//MARK:-   topCell Delegate
extension AddConfigurableProductVC: AddProductConfigurableTopTableViewCellDelegate{
   
    func didSelect(category: Category?) {
        print(category?.title ?? "" )
        getFeaturesFilteredBy(categoryId: category?.id)
    }
    
    func getFeaturesFilteredBy(categoryId: String?) {
        self.paramsRoot.category = categoryId
       
        
        guard let categoryId = categoryId else {
//            self.configurationList.forEach({$0.combination.features.removeAll()})
            self.AttributesFilteredByCategory.removeAll()
            self.tableView.reloadData()
            return
        }
        
        var  filtereData = [FeatureData]()
        for (_,feature )in self.featuresData.enumerated() {
            
            if let _ = feature.categories?.firstIndex(of: categoryId) {
                filtereData.append(feature)
            }
        }
        //setter
        self.AttributesFilteredByCategory = filtereData
        
    }
    
    
    func didSelect(subcategory: Category?) {
        print(subcategory?.title ?? "unselected")
        self.paramsRoot.subcategory = subcategory?.id
        
        
    }
    
    
    
    func didEnter(productName: String?) {
         print(productName ?? "--")
        self.paramsRoot.titleEn = productName

    }

    func didEnter(productNameAR: String?) {
             print(productNameAR ?? "--")
            self.paramsRoot.titleAr = productNameAR
        }

}

 //MARK:-  descriptionCell delegate
extension AddConfigurableProductVC: AddProductConfigurableDescriptionTableViewCellDelegate {

    
    func didEnter(detailAr: String?) {
        self.paramsRoot.descriptionAr = detailAr
    }
    func didEnter(detailEn: String?) {
         self.paramsRoot.descriptionEn = detailEn
    }
}

//MARK:-  CheckBoxCell Delegate
extension AddConfigurableProductVC: AddProductConfigurableCheckBoxTableViewCellDelegate {
    func didSelectToggle(cell: AddProductConfigurableCheckBoxTableViewCell, indexPath: IndexPath) {
        
        
        let feature = cell.feature
        if feature?.isSelected ?? false {
            feature?.isSelected = false
            
        }
        else{
            feature?.isSelected = true
            
        }
        
        let selectedFeatures = AttributesFilteredByCategory.filter({$0.isSelected == true})


       if selectedFeatures.count > 3 {
           let msg = "You can select only three Features".localized
           nvMessage.showWarning(body: msg)
           cell.checkBoxButton.isSelected = cell.checkBoxButton.isSelected == true ? false : false
           return
       }
       else {
          self.paramsRoot.selectedCategoryFeatures = selectedFeatures
           for object in configurationList{
               object.combination.features = featureArrayCopy(array: selectedFeatures)
           }
           self.tableView.reloadSection(section: TableViewSections.configuration.rawValue)
       }
    
    }
    
    func featureArrayCopy(array :[FeatureData]) -> [FeatureData]{
        var copiedArray = [FeatureData]()
        for element in array {
            
            copiedArray.append(element.cloneItem())
        }
        return copiedArray
    }
}


