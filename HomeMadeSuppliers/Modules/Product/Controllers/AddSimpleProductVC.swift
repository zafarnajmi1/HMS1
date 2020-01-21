//
//  AddSimpleProductVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/25/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Segmentio


enum LocaleType: String {
    case en
    case ar
}

protocol AddSimpleProductVCDelegate: class {
    func didAddedProduct()
}


class AddSimpleProductVC: UIViewController {
    
     //MARK:-  outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mySegmentView: Segmentio!
    @IBOutlet weak var tableViewTopSpace: NSLayoutConstraint!

    var selectedLocaleType = LocaleType.en
    
    // custom type
    enum  cellType {
        case top
        case attribute
        case image
        case bottom
    }
    
    struct Section {
        var type: cellType
        var index: Int
        init(index: Int, type: cellType) {
            self.index = index
            self.type = type
        }
    }
   
   
    struct cellHeight {
        static let top: CGFloat = 192
        static let image: CGFloat = 150
        static let attributeHeader: CGFloat = 50
        static let attribute: CGFloat = 50
        static let bottom = UITableView.automaticDimension
    }
    
    //MARK:-  variables
    
    //shared
    var delegate: AddSimpleProductVCDelegate?
    var productType = ProductType.none
    var product: ProductDetail?
    var isEditProduct = false
    //fileprivate
    fileprivate var tableSections = [Section]()
    fileprivate var featuresData:[FeatureData] = []
    fileprivate var featuresFiltered:[FeatureData] = [] {
        didSet {
            setupSections()
        }
    }
    
    fileprivate var selectedimageList = [ImageCollection]()
    fileprivate var parameters = AddProductParmeters()
    
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = product == nil ? "Add Product".localized: "Update Product".localized
        setupView()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.disconnectSocketProcess()
    }
    
    
    func disconnectSocketProcess()  {
        let socket = SocketIOManager.sharedInstance.getSocket()
       
        socket.off("uploadCompleted")
        socket.off("moreData")
    }
    
    
    func setupView()  {
         addBackBarButton()
         tableView.registerCell(id: AddProductTopTableViewCell.id)
         tableView.registerCell(id: AddProductBottomTableViewCell.id)
         tableView.registerCell(id: AddProductCollectionViewTableViewCell.id)
         tableView.registerHeaderFooterCell(id: CheckBoxSectionTableViewCell.id)
         tableView.registerCell(id: CheckBoxTableViewCell.id)
         tableView.rowHeight = UITableView.automaticDimension
         tableView.estimatedRowHeight = 200
         self.tableViewTopSpace.constant = 0
        //api request
        
        
        setupSegmentList()
        setupSections()
        requestToFetchFeaturesList()
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

    
    func setupSections() {
        var index = 0
        tableSections.removeAll()
        tableSections.append(Section(index: index, type: .top))
        for _ in featuresFiltered {
            index = index + 1
            tableSections.append(Section(index: index, type: .attribute))
        }
        index = index + 1
        tableSections.append(Section(index: index, type: .image))
        index = index + 1
        tableSections.append(Section(index: index, type: .bottom))
        
        tableView.reloadData()
        
    }

     //MARK:- update existing Product
    func reloadData(product: ProductDetail)  {
        self.isEditProduct = true
        self.tableViewTopSpace.constant = self.isEditProduct == true ? 52:0
        
        
       // textfields
        self.parameters.titleEn = product.titleEn
        self.parameters.titleAr = product.titleAr
        self.parameters.price = "\(product.price?.aed?.amount ?? 0 )"
        self.parameters.isAvailable = product.isAvailable == true ? "Yes".localized :"No".localized
        self.parameters.descriptionEn = product.descriptionEn
        self.parameters.descriptionAr = product.descriptionAr
        self.parameters.available = "\(product.available ?? 0)"
        self.parameters.offer = "\(product.offer?.aed?.amount ?? 0 )"
        self.parameters.isOffer = product.isOffer
        //categories
        self.parameters.selectedCategoryTitle = product.categories?.first?.title
        self.parameters.selectedSubcategoryTitle = product.categories?.last?.title
        self.parameters.category = product.categories?.first?.id
        self.parameters.subcategory = product.categories?.last?.id
        if product.categories?.count ?? 0 == 2 {
            self.parameters.categories = [self.parameters.category ?? "", self.parameters.subcategory ?? ""]
        }
        
        //image collection
        self.selectedimageList.removeAll()
        for item in product.images ?? [] {
            let object = ImageCollection()
            object.isDefault = item.isDefault ?? false
            object.filePath = item.path
            object.id = item.id
            self.selectedimageList.append(object)
        }
        
        //Feature/priceables selection
        // category -> filtered features (make selected)> selected feature> charatersitcs (make selected)
        if let categories = product.categories {
           
            let category = categories.first
            //important
            featuresFilter(categoryId: category?.id)
        
            for priceable in product.priceables ?? [] {
                if let index = featuresFiltered.firstIndex(where: {$0.id == priceable.feature?.id}) {
                    self.featuresFiltered[index].isSelected = true
                    let selectedFeature = self.featuresFiltered[index]
                    
                    for char in priceable.characteristics ?? [] {
                        if let index = selectedFeature.characteristics?.firstIndex(where: {$0.id == char.id}) {
                            selectedFeature.characteristics?[index].isSelected = true
                         }
                    }
                }
            }
        }
    
        self.tableView.reloadData()
    }
    
    
}


 //MARK:-  api request
extension AddSimpleProductVC {
    func requestToFetchFeaturesList()  {
        self.showNvLoader()
        ProductManager.shared.fetchProductFeatureCharacteristics { (response) in
            self.hideNvloader()
            switch response {
            case .sucess(let root):
                self.featuresData = root.data ?? []
                self.tableView.reloadData()
                
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


 //MARK:-  table cell row Height
extension AddSimpleProductVC: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = tableSections[indexPath.section].type
        
        switch sectionType {
        case .image:
            return cellHeight.image
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = tableSections[section].type
        switch sectionType {
        case .attribute:
            return cellHeight.attributeHeader
        default:
            return 0
        }
    }
   
}

 //MARK:-  tableview data source
extension AddSimpleProductVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = tableSections[section].type
        switch sectionType {
        case .top,.bottom, .image:
            return 1
        case .attribute:
            let topSection = 1
            let feature = featuresFiltered[section - topSection]
            return feature.isSelected == true ? feature.characteristics?.count ?? 0:0
           // return model.characteristics?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = tableSections[section].type
        switch sectionType {
        case .attribute:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CheckBoxSectionTableViewCell.id) as! CheckBoxSectionTableViewCell
            header.checkBoxDelegate = self
            let topSection = 1
            let model = featuresFiltered[section - topSection ]
            header.loadHeader(feature: model, section: section)
           
            return header
        default:
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let sectionType = tableSections[indexPath.section].type
        
        switch sectionType {
        case .top:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddProductTopTableViewCell.id) as! AddProductTopTableViewCell
            cell.delegate = self
           
            cell.loadCell(productType: productType,
                          product: self.parameters,
                          isEditProduct: self.isEditProduct,
                          localeType:  selectedLocaleType)
            cell.attributeTitle.isHidden = featuresFiltered.count > 0 ? false:true
            
            return cell
        
        case .attribute:
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.id) as! CheckBoxTableViewCell
            let model = featuresFiltered[indexPath.section - 1]
            cell.loadCell(feature: model, indexPath: indexPath)
            cell.checkBoxDelegate = self
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddProductCollectionViewTableViewCell.id) as! AddProductCollectionViewTableViewCell
            cell.imageList = selectedimageList
            cell.collectionview.reloadData()
            cell.addImageDelegate = self
            cell.viewImageDelegate = self
            return cell
        case .bottom:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddProductBottomTableViewCell.id) as! AddProductBottomTableViewCell
            cell.delegate = self
            let btnName = product == nil ? "Add Product".localized : "Update Product".localized
            cell.sendBtn.setTitle(btnName, for: .normal)
            cell.loadCell(model: self.parameters,
                          isEditProduct: self.isEditProduct,
                          localeType: selectedLocaleType)
            return cell
//        default:
//            return UITableViewCell()
        }
        
      
       
    }
    
}






//MARK:-  top cell delegates
extension AddSimpleProductVC: AddProductTopTableViewCellDelegate {
    
    func didSelect(category: Category?) {
        print(category?.title ?? "" )
        featuresFilter(categoryId: category?.id)
    }
    
    func featuresFilter(categoryId: String?) {
        self.parameters.category = categoryId
        
        guard let categoryId = categoryId else {
            return self.featuresFiltered.removeAll()
        }
        
        var  filtereData = [FeatureData]()
        for (_,feature )in self.featuresData.enumerated() {
            
            if let _ = feature.categories?.firstIndex(of: categoryId) {
                filtereData.append(feature)
            }
        }
        self.featuresFiltered = filtereData
    }

    
    func didSelect(subcategory: Category?) {
        print(subcategory?.title ?? "unselected")
        self.parameters.subcategory = subcategory?.id
      
        
    }
    
    func didEnter(productName: String?) {
        self.parameters.titleEn = productName
    }
    
    func didEnter(productNameAR: String?) {
        self.parameters.titleAr = productNameAR
    }
    
    func didSelect(productAvailablity: String?) {
        print(productAvailablity ?? "--")
       
        self.parameters.isAvailable = productAvailablity
       
       
       
    }
    
    func didEnter(productStock: String?) {
         self.parameters.available = productStock
    }
    
    
    
    
    
    func didEnter(productPrice: String?) {
        print(productPrice ?? "--")
        self.parameters.price = productPrice
    }
    
    func didEnter(productOfferPrice: String?, isOffer: Bool) {
        self.parameters.offer = productOfferPrice
        self.parameters.isOffer = isOffer
    }
    
}

//MARK:-  tableview CheckBoxTableViewCellDelegate
extension AddSimpleProductVC: CheckBoxTableViewCellDelegate {
    func didSelectToggle(cell: CheckBoxTableViewCell, indexPath: IndexPath) {
          print(indexPath.section, indexPath.row)
        let char = cell.charateristic
        if char?.isSelected ?? false {
            char?.isSelected = false
         }
        else{
            char?.isSelected = true
        }
        
        
        self.tableView.reloadData()
        //reloadSection(section: indexPath.section)
    }
}

//MARK:-  tableview CheckBoxSectionTableViewCellDelegate
extension AddSimpleProductVC: CheckBoxSectionTableViewCellDelegate {
    func didSelectToggle(header: CheckBoxSectionTableViewCell, section: Int) {
        let feature = header.feature
        
       
        
        if feature?.isSelected ?? false {
            feature?.isSelected = false
            
        }
        else{
            feature?.isSelected = true
            
        }
        
        let selectedItems = featuresFiltered.filter({$0.isSelected == true})
        if selectedItems.count > 3 {
            let msg = "You can select only three Features".localized
            nvMessage.showWarning(body: msg)
            header.checkBoxButton.isSelected = header.checkBoxButton.isSelected == true ? false : false
            return
        }
        else {
            self.tableView.reloadData()
           // reloadSection(section: section)
        }
        
       
    }
    
   
    
    func reloadSection(section: Int) {
       
        
        tableView.beginUpdates()
        tableView.reloadSections([section], with: .none)
        tableView.endUpdates()
        
    }
}


//MARK:-  tableview AddImageCollectionViewCellDelegate
extension AddSimpleProductVC: AddImageCollectionViewCellDelegate {
    func didUploadedImageSuccessfully(imageDic: ImageCollection) {
        if self.selectedimageList.count == 0 {
           imageDic.isDefault = true
        }
        self.selectedimageList.insert(imageDic, at: 0)
        
    
        //fix me-> reload specific section
        tableView.reloadData()
    }

}


//MARK:-  tableview ViewImageCollectionViewCellDelegate
extension AddSimpleProductVC: ViewImageCollectionViewCellDelegate {
    func didMarkAsDefault(model: ImageCollection, index: Int) {
        //remove all previous defaults
        for item in selectedimageList {
            item.isDefault = false
        }
        self.selectedimageList[index].isDefault = true
        //fix me-> reload specific section
        tableView.reloadData()
    }
    
    func didImageDelete(model: ImageCollection) {
        
        self.selectedimageList = self.selectedimageList.filter { $0.filePath != model.filePath }
        //fix me-> reload specific section
        tableView.reloadData()
    }
    
}




//MARK:-  bottom cell delegate
extension AddSimpleProductVC: AddProductBottomTableViewCellDelegate {
   
    func didEnter(detailEn: String?) {
          self.parameters.descriptionEn = detailEn
    }
    func didEnter(detailAr: String?) {
         self.parameters.descriptionAr = detailAr
    }
    

    func sendButtonTapped(sender: UIButton) {
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
        
        var dictionary = self.parameters.dictionary
       
        dictionary?.updateValue(selectedLocaleType.rawValue, forKey: "locale")
        
        let isOffer = self.parameters.isOffer == true ? "true":"false"
        dictionary?.updateValue(isOffer, forKey: "isOffer")
        
        
        
        let selectedFeatures = featuresFiltered.filter({$0.isSelected == true})
        let selectedFeaturesID  = selectedFeatures.compactMap({$0.id})
        dictionary?.updateValue(selectedFeaturesID, forKey: "allFeatures")
        
        var featuresDicList = [[String:Any]]()
        var characteristicsList = [String]()
        for feature in selectedFeatures {
            let filteredCharacteristics = feature.characteristics?.filter({$0.isSelected == true})
            let selectedCharacteristics = filteredCharacteristics?.compactMap({$0.id})
            featuresDicList.append(["feature":feature.id!, "characteristics": selectedCharacteristics ?? [] ])
            characteristicsList.append(contentsOf: selectedCharacteristics ?? [])
        }
        dictionary?.updateValue(featuresDicList, forKey: "priceables")
        dictionary?.updateValue(characteristicsList, forKey: "characteristics")
    
    
        var imagesArray = [[String:Any]]()
        for image in selectedimageList {
        
            // add new product
            if product?.id == nil {
                var object : [String: Any] = [:]
                let isDefault = image.isDefault == true ? true: false
                let completeURL = "\(AppNetwork.current.assetsTemp)\(image.filePath ?? "")"
                
                object.updateValue(isDefault, forKey: "isDefault")
                if let fileName = image.filePath {
                    object.updateValue(fileName, forKey: "fileName")
                   // object.updateValue(fileName, forKey: "url")
                }
                
              
                object.updateValue(completeURL, forKey: "url")
                imagesArray.append(object)
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
                imagesArray.append(object)
            }
            

           
        }
        dictionary?.updateValue(imagesArray, forKey: "images")

        let categories = [parameters.category, parameters.subcategory]
        dictionary?.updateValue(categories, forKey: "categories")
        
        switch productType {
        case .simple:
            let isAvailable = parameters.isAvailable?.localized  == "Yes".localized ? "true": "false"
            dictionary?.updateValue(isAvailable, forKey: "isAvailable")
            dictionary?.updateValue("simple", forKey: "productType")
        case .stock:
            let stock = parameters.available
            dictionary?.updateValue("false", forKey: "isAvailable")
            dictionary?.updateValue(stock ?? "", forKey: "available")
            dictionary?.updateValue("stock", forKey: "productType")
        default:
            print("Implmentation required")
        }
        
        if let productID = product?.id {
            dictionary?.updateValue(productID, forKey: "_id")
        }
        
        
        print(dictionary ?? "dictionary is empty")
        return dictionary
    }
    
    
}

 //MARK:-  form validation
extension AddSimpleProductVC {
    
    func formIsValid() -> Bool {
        
        
        let title = product?.id == nil ? "Add Product".localized: "Update Product".localized
        
        if  parameters.category?.count ?? 0 == 0 {
            let msg = "Please enter select category".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        if  parameters.subcategory?.count ?? 0 == 0 {
            let msg = "Please enter select subcategory".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        
        if  parameters.titleEn?.count ?? 0 < 2  && selectedLocaleType == .en {
            let msg = "Product name EN is required,  at least 3 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        
        if  parameters.titleAr?.count ?? 0 < 2 && selectedLocaleType == .ar {
            let msg = "Product name AR is required, at least 3 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        
    
        if  parameters.price?.count ?? 0 == 0 {
            let msg = "Please enter valid Price".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if  parameters.isAvailable?.count ?? 0 == 0 && productType == .simple {
            let msg = "Please select availablity".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if  parameters.available?.count ?? 0 == 0 && productType == .stock {
            let msg = "Please enter stock".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }

        if  parameters.isOffer == true && parameters.offer?.count ?? 0 == 0 {
            let msg = "Please enter Offer Price".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }


        if  parameters.descriptionEn?.count ?? 0 < 10  {
            let msg = "Description EN is Required, at least 10 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }

        if  parameters.descriptionAr?.count ?? 0 < 10 && isEditProduct == true {
            let msg = "Description AR is Required, at least 10 characters".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        
        let selectedFeatures = featuresFiltered.filter({$0.isSelected == true})
        if selectedFeatures.count > 3 {
            let msg = "You can select only three Features".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        if selectedFeatures.count == 3 {
            for feature in selectedFeatures {
                let selectedcharateristics = feature.characteristics?.filter({$0.isSelected == true})
                if selectedcharateristics?.count ?? 0 == 0 {
                    let msg = "Select atleast one characteristics of \(feature.title ?? "") ".localized
                    nvMessage.showError(title: title, body: msg)
                    return false
                }
            }
        }
        
        return true
    }
    
}
