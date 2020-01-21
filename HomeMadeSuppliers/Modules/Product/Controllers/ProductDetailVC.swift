//
//  ProductDetailVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/12/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductDetailVC: ProductBaseVC {

     //MARK:- outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    var isBuyNowBtnTapped = false
    //Product
    var productId: String?
    var delegate: CallBackDelegate?
    var relatedProducts = [Product]()
    enum sections: Int {
        case top = 0, city,feature,detail,relatedProduct,submitReview,reviews
        static let count = 7
    }
    
    
    //Review Section
    var canReview = false
    var reviewPagination: Pagination?
    var reviews: [Review]?
    
    
    var productDetails: ProductDetail?
    
    //Parameters
    var selectedFeatures = [[String: Any]]()
    enum deliveryOption {
        case international
        case domestic
        case city
    }
    var selectedDeliveryOption = deliveryOption.domestic
    var selectedCity: DeliverableCity1?
    
    
    //combinations handling
    var featureArray : [String] = []
    var totalQuantity: Int = 1
    var totalRows = 0
    
    var initialPricable : Priceable1?
    var secondPricable : Priceable1?
    var initialChoise : Characteristic1?
    var secondChoise : Characteristic1?
    var characteristics : [String] = []
//    var firstIndex : Int = -1
    var secondIndex : Int = -1
//    var thirdIndex : Int = -1
    var firstCombinationIDs : [String]?
    var secondCombinationIDs : [String]?
    
    var foundCombinations : [Characteristic1]?
    
    var priceableToLoad : [Priceable1] = []
    var selectedCombination : Combination1?
  
    
    
    
     //MARK:- lifye cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product Detail".localized
        addBackBarButton()
        setLocalization()
        setupView()
        apiCallsOnLoad()
       
        
     }
    
    
    func apiCallsOnLoad()  {
        //call apis on didload
        requestToFetchProdcutDetail()
        requestToFetchProductAds()
        self.showNvLoader()
        self.requestToFetchProdutReviews()
        
        if myDefaultAccount == .buyer {
            requestToFetchCartList()
        }
    }
 
 
}




  //MARK:-  setup view/ tableview/ UI
extension ProductDetailVC {
    
  
    func setupView()  {
        
        navigationBarButtonsSetup()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: .didUpdateCartCount, object: nil)
        
        switch myDefaultAccount {
        case .seller:
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        default:
            return
        }
    }
    
    func setupTableView() {
        
        tableView.registerHeaderFooterCell(id: Header1TableView.id)
        tableView.registerCell(id: DetailTableViewCell.id)
        tableView.registerCell(id: ProductInfoTableViewCell.id)
        tableView.registerCell(id: DeliverableCityTableViewCell.id)
        tableView.registerCell(id: RadioButton2TableViewCell.id)
        tableView.registerCell(id: FeatureCollectionTableViewCell.id)
        tableView.registerCell(id: DropDownTableViewCell.id)
        tableView.registerCell(id: ProductCollectionTableViewCell.id)
        tableView.registerCell(id: SubmitReviewTableViewCell.id)
        tableView.registerCell(id: RatingReviewTableViewCell.id)
        
        tableView.estimatedRowHeight = 500
        
    }
    
    
    func updateUI() {
        
        totalRows = productDetails?.priceables?.count ?? 0
        priceableToLoad = productDetails?.priceables ?? []
        
        if let priceAbles = productDetails?.priceables{
            for obj in priceAbles{
                featureArray.append(obj.feature?.id ?? "")
            }
        }
        self.canReview = productDetails?.canReviewUsers?.count ?? 0 > 0 ? true: false
        tableView.reloadData()
    }
  
}


extension ProductDetailVC: ProductInfoTableViewCellDelegate {
    func didUpdate(quantity: Int) {
        self.totalQuantity = quantity
    }
    
    
}

//MARK:-  form Validaton -> e.g combinations / delivery options
extension ProductDetailVC {
    
    func isValidCheckList() -> Bool {
        
        let title = "Add To Cart".localized
        
        if product?.isAvailable == false && product?.productType == "simple" {
            nvMessage.showStatusError(title:"Add to cart".localized, body: "Not in stock".localized)
            return false
        }
        
        if product?.store?.deliverableCities?.count ?? 0 > 0 && selectedCity == nil && selectedDeliveryOption == .domestic {
            nvMessage.showStatusError(title: title, body: "Please select deliverable city".localized)
            return false
        }
        
        let indexPath = IndexPath(row: 0, section: sections.top.rawValue)
        let cell = tableView.cellForRow(at: indexPath) as? ProductInfoTableViewCell
        if let cell = cell {
            let available = cell.isvalidQunatiy()
            if available == false {
                nvMessage.showStatusError(title: title, body: "Out of stock".localized)
                return false
            }
        }
        
        
        self.selectedFeaturesCell()
        let productFeaturesCount = product?.priceables?.count ?? 0
        let selectedFeaturesCount = selectedFeatures.count
        
        if productFeaturesCount != selectedFeaturesCount {
            return false
        }
        
        
        return true
    }
    
    func selectedFeaturesCell()  {
        
        selectedFeatures.removeAll()
        
        for (_,priceable) in priceableToLoad.enumerated() {
            let feature = priceable.feature
            
            if let selectedIndex = priceable.selectedIndex {
                let characteristic = priceable.characteristics?[selectedIndex]
                let selectedOptionId = characteristic?.id ?? ""
                selectedFeatures.append(["feature": feature?.id ?? "",
                                         "characteristic": selectedOptionId])
            }
            else {
                let title = "Add To Cart".localized
                let prefix = "Please Select".localized
                nvMessage.showStatusError(title:title, body: "\(prefix) \(feature?.title ?? "" )")
                return
            }
          
        } // end loop
        
    }// end method
    
}

  //MARK:-  actions
extension ProductDetailVC {
    
    @objc func updateCartBadge() {
        requestToFetchCartList()
    }
    
    func guestLogin() {
        let msg = "You are in guest Mode. Please login first".localized
        self.presentAlert(message: msg , yes: {
            let s = AppConstant.storyBoard.userEntry
            let vc = s.instantiateViewController(withIdentifier: LoginOptionVC.id) as! LoginOptionVC
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }, no: nil)
        
        
    }
    
    
    @IBAction func addToCartBtnTapped(sender: UIButton) {
        isBuyNowBtnTapped = false
        
        if myDefaultAccount == .guest {
            guestLogin()
            return
        }
        
        
        //validate
        if self.product?.store?.isBusy == true {
            AppSettings.storeIsBusyAlert(view: self.view)
        }
        else {
            if isValidCheckList() {
                requestToAddProductInCart()
            }
        }
        
        
    }
    
    @IBAction func buyNowBtnTapped(sender: UIButton) {
        isBuyNowBtnTapped = true
        if myDefaultAccount == .guest {
            guestLogin()
            return
        }
        
        
        //validate
        if self.product?.store?.isBusy == true {
            AppSettings.storeIsBusyAlert(view: self.view)
        }
        else {
            if isValidCheckList() {
                requestToAddProductInCart()
            }
        }
        
        
    }
    
}


//MARK:-  api request

extension ProductDetailVC {
    
    func requestToFetchProdcutDetail()  {
        if productId == nil {
             guard let id = product?.id  else { return }
             productId = id
        }
        
        
        self.showNvLoader()
        ProductManager.shared.productDetail(productID: productId!) { (response) in
            self.hideNvloader()
            switch response {
            case .sucess(let root):
                self.productDetails = root.data
                
                self.updateUI()
            case .failure(let error):
               
                nvMessage.showError(body: error)
                
            }
        }
    }
    
    func requestToFetchProdutReviews(){
        
        guard let productId = productId else {
            nvMessage.showError(body: "Product Id not found".localized)
            return
        }
        
        let perPage = 50
        let nextPage = reviewPagination?.next ?? 1
        
        let params = ["_id": productId,
                      "pagination": perPage,
        "page": nextPage] as [String: Any]
        
       
        ProductManager.shared.productReviews(params: params ) { (result) in
            
            self.hideNvloader()
            ProgressHUD.dismiss(animated: true)
            
            switch result {
                
            case .sucess(let root):
                self.updateReviewList(response: root.data)
            
            case .failure(let error):
                nvMessage.showError(body: error)
            
            }
            
        }
    }
    
    func updateReviewList(response: ReviewCollection? )  {
        
        self.reviewPagination = response?.pagination
        
        if reviewPagination?.page ?? 0 == 1 {
            self.reviews = response?.reviews ?? []
        }
        else {
            self.reviews?.append(contentsOf: response?.reviews ?? [])
        }
        
        tableView.reloadData()
    }
    
    func requestToAddProductInCart() {
    
        guard  let product = product else { return }
        var params: [String: Any] = ["product": product.id! ]
        
        params.updateValue(product.productType ?? "", forKey: "productType")
       
        
        //update quantity
      //  let index = IndexPath(row: 0, section: sections.top.rawValue)
        //let cell = tableView.cellForRow(at: index) as? ProductInfoTableViewCell
//        if  cell != nil && cell?.quantity ?? 0 > 0 {
          if  self.totalQuantity > 0 {
            params.updateValue(totalQuantity, forKey: "quantity")
        }
        else {
            nvMessage.showError(body: "Quantity required".localized)
            return
        }
        
        
        
        
        switch selectedDeliveryOption {
        case .domestic:
            params.updateValue("domestic", forKey: "shipping")
            params.updateValue(selectedCity?.id ?? "", forKey: "deliverableCity")
        case .city:
            params.updateValue(selectedCity?.id ?? "", forKey: "deliverableCity")
            params.updateValue("domestic", forKey: "shipping")
        case .international:
            params.updateValue("international", forKey: "shipping")
        }
        
        
        if selectedFeatures.count > 0 {
            params.updateValue(selectedFeatures, forKey: "priceables")
        }
        
        if let id = selectedCombination?._id {
            params.updateValue(id, forKey: "combination")
        }
        
        if isBuyNowBtnTapped {
            params.updateValue("true", forKey: "buyNow")
        }
        
        
        self.showNvLoader()
        CartManager.shared.addProductToCart(params: params) { (response) in
            self.hideNvloader()
            switch response {
            case let .sucess(root):
                if self.isBuyNowBtnTapped == true {
                   self.moveToCheckout(price: root.data?.totalWithShipping)
                   return
                }
                nvMessage.showSuccess(body: root.message ?? "", closure: {
                    self.requestToFetchCartList()
                    self.requestToFetchProdcutDetail()
                    self.resetFeaturesSelection()
                    self.tableView.reloadData()
                })
            case let .failure(error):
                nvMessage.showError(body: error)
            }
        }
    }
    
    
    
    func moveToCheckout(price: Price?) {
        
        let s = AppConstant.storyBoard.checkout
        let vc = s.instantiateViewController(withIdentifier: CheckOutVC.id) as! CheckOutVC
        vc.totalBilAmount = price
        vc.isFromBuyNow = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func requestToFetchProductAds() {
        
        let perPage =  6
        let nextPage = 1
        
        let categories = [product?.categories?.first?.id,
                          product?.categories?.last?.id]
        var params: [String: Any] = ["pagination": perPage,
                                     "page": nextPage,
                                     "categories": categories]
        
        if let id = product?.id {
            params.updateValue(id, forKey: "notInclude")
        }
    
        showNvLoader()
        ProductManager.shared.fetchProductList(params: params, defaultSort: false) { (result) in
           self.hideNvloader()
          
            switch result {
            case .sucess(let root):
                self.relatedProducts = root.data?.collection ?? []
                self.tableView.reloadData()
            case .failure(let error):
                self.tableView.setEmptyView(message: error)
            }
           
           
        }
    }
    
}

extension ProductDetailVC: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if productDetails == nil { return 0 }
       
        guard let tableSection = sections(rawValue: section) else {return 0}
        
        switch tableSection {
        case .detail, .city:
             return 45
        case .relatedProduct:
            return relatedProducts.count == 0 ? 0: 45
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Header1TableView.id) as! Header1TableView
        
        guard let tableSection = sections(rawValue: section) else {return nil}
        
        switch tableSection {
            case .detail:
                header.setData(title: "Description".localized )
            case .relatedProduct:
                 header.setData(title: "Related Products".localized )
            case .city:
                header.setData(title: "We Can Arrive In:".localized )
            default:
            return nil
            }
            return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        guard let tableSection = sections(rawValue: section) else { return 0 }
        
        switch tableSection {
            case .top, .city, .detail:
                return productDetails == nil ? 0:1
            case .feature:
                return self.priceableToLoad.count
            case .relatedProduct:
                return relatedProducts.count == 0 ? 0: 1
            case .submitReview:
                return canReview == true && myDefaultAccount == .buyer ? 1: 0
            case .reviews:
                return self.reviews?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       guard let tableSection = sections(rawValue: indexPath.section) else { return UITableViewCell() }
       
        switch tableSection {
        
        case .top:
           
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoTableViewCell.id) as! ProductInfoTableViewCell
            cell.stepperDelegate = self
            cell.cellDelegate = self
            cell.loadCell(model: productDetails!, self, quantity: self.totalQuantity, combination: selectedCombination)
            return cell

            
        case .city:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliverableCityTableViewCell.id) as! DeliverableCityTableViewCell
            cell.delegate = self
            cell.setData(model: productDetails!.store!, selectedCity: selectedCity)
            return cell
        
        case .feature:
           
            let priceable = self.priceableToLoad[indexPath.row]
           
           
            switch priceable.feature?.howToShow {
            case "dropdown":
                let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTableViewCell.id) as! DropDownTableViewCell
                cell.setData(priceable: priceable, self)
               
                return cell
            default: // radio
                let cell = tableView.dequeueReusableCell(withIdentifier: FeatureCollectionTableViewCell.id) as! FeatureCollectionTableViewCell
               
                cell.setData(priceable: priceable, self)
              
                return cell
            }
        
        
        case .detail:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.id) as! DetailTableViewCell
            cell.setData(model: productDetails )
            return cell
        
        case .relatedProduct:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCollectionTableViewCell.id) as! ProductCollectionTableViewCell
            cell.callBackDelegate = self
            cell.productDelegate = self
            cell.setData(list: relatedProducts)
            return cell
        
        case .submitReview:
           
            let cell = tableView.dequeueReusableCell(withIdentifier: SubmitReviewTableViewCell.id) as! SubmitReviewTableViewCell
            cell.productId = product?.id
            cell.delegate = self
            return cell
            
        case .reviews:
           
            let cell = tableView.dequeueReusableCell(withIdentifier: RatingReviewTableViewCell.id) as! RatingReviewTableViewCell
            let review = reviews?[indexPath.row]
            cell.setData(model: review!)
            return cell
       
        }
    
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height - 20 {
            let canFetch = MyPagination.shared.checkFetchMore(model: reviewPagination)
            if canFetch {
                ProgressHUD.present(animated: true)
                self.requestToFetchProdutReviews()
            }
           
        }
    }
    
}

extension ProductDetailVC: CallBackDelegate, ProductDelegate {
    
    func reloadData() {
        self.requestToFetchProdcutDetail()
        self.requestToFetchProdutReviews()
    }
    
    func didSelect(product: Product) {
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: ProductDetailVC.id) as! ProductDetailVC
        vc.productId = product.id
        vc.product = product
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension ProductDetailVC : deliveryOptionDelegate {
    
    func didSelect(selectedCity: DeliverableCity1?) {
        self.selectedCity = selectedCity
        
    }
}



//MARK:-  Combinations Handling
extension ProductDetailVC: FeatureCollectionViewCellDelegate {
    func didSelectedItem(characteristic: Characteristic1?, _ priceable: Priceable1?, _ row: Int) {
       
       

        
        //Selected Item
        if let characteristic = characteristic , let priceable = priceable {
            print("selected feature : \(priceable.feature?.title ?? "")")
            
            if let combinations = characteristic.combinations {
                print("Characteristic Combinations Ids\(combinations.flatMap{$0.compactMap({$0.id})})")
                featureSelected(object: priceable, charactistic: characteristic, index: row)
                
            }
            else {
                let objectIndex = priceableToLoad.firstIndex{$0.id == priceable.id}
                if let objectIndex = objectIndex {
                    priceableToLoad[objectIndex].selectedIndex = row
                }
            }
        }
        else { // unselected Item
            let objectIndex = priceableToLoad.firstIndex{$0.id == priceable?.id}
            if let objectIndex = objectIndex {
                priceableToLoad[objectIndex].selectedIndex = nil
            }
        }
        
        
        
    }
    
    
}



extension ProductDetailVC {
    
    
    
    
    func updateFeatureCells(priceable: Priceable1, index: Int)  {
        switch priceable.feature?.howToShow  {
        case "dropdown":
            let indexPath = IndexPath(row: index, section: sections.feature.rawValue)
            let cell = tableView.cellForRow(at: indexPath) as? DropDownTableViewCell
            cell?.setData(priceable: priceable, self)
            cell?.textField.text = ""
            cell?.selectedOptionId = nil
            
        default: // radio
            let indexPath = IndexPath(row: index, section: sections.feature.rawValue)
            let cell = tableView.cellForRow(at: indexPath) as? FeatureCollectionTableViewCell
            cell?.setData(priceable: priceable, self)
        }
    }
    
    
    
    
}




extension ProductDetailVC: StepperCollectionViewCellDelegate {
    func resetFeaturesSelection() {
        resetSection()
    }
    
   
    func resetSection() {
        initialPricable = nil
        initialChoise = nil
        firstCombinationIDs = nil
        secondCombinationIDs = nil
        secondPricable = nil
        foundCombinations = nil
        priceableToLoad = (productDetails?.priceables)!
        selectedCombination = nil
        selectedCity = nil
        self.tableView.reloadData()
        
        //reset Features cell
        for (index,priceable) in priceableToLoad.enumerated() {
            
            switch priceable.feature?.howToShow  {
            case "dropdown":
                let indexPath = IndexPath(row: index, section: sections.feature.rawValue)
                let cell = tableView.cellForRow(at: indexPath) as? DropDownTableViewCell
                cell?.setData(priceable: priceable, self)
                cell?.textField.text = ""
                cell?.selectedOptionId = nil
                
            default: // radio
                let indexPath = IndexPath(row: index, section: sections.feature.rawValue)
                let cell = tableView.cellForRow(at: indexPath) as? FeatureCollectionTableViewCell
                cell?.setData(priceable: priceable, self)
                cell?.selectedOptionId = nil
            }
        }
        
    }
    
    
    
    func featureSelected(object: Priceable1, charactistic: Characteristic1, index: Int) {
        print("Delegate Called Implementation is called.")
        
        if !checkAndSetInitPriceable(object: object, charactistic: charactistic, index : index){
            
            if !checkAndsetSecondPriceable(object: object, charactistic: charactistic, index: index){
                
                for (priceIndex,priceable) in priceableToLoad.enumerated(){
                    if priceable.id == object.id
                    {
                        priceableToLoad[priceIndex].selectedIndex = index
                        loadCharactristicArray()
                        updateTopCell()
                    }
                    
                }
                
            }
            else{
                secondIndex = index
            }
        }
        else{
            
        }
        
        
    }
    
    
    func updateTopCell(){
        if checkAndLoadCombination(){
            let section = sections.top.rawValue
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? ProductInfoTableViewCell {
               cell.updateStepper(combination: selectedCombination!)
                
            }
        }
        else{
            
        }
        
    }
    
    func checkAndSetInitPriceable (object: Priceable1, charactistic: Characteristic1, index : Int) -> Bool{
        
        if initialPricable == nil || initialPricable?.id == object.id {
            initialPricable = object
            
            if initialChoise?.id != charactistic.id{
                
                priceableToLoad = productDetails!.priceables!
                initialPricable = object
                initialChoise = charactistic
                var ids = [String]()
                for array in charactistic.combinations ?? []{
                    for combination in array{
                        // do not repeat
                        ids.append(combination.id!)
                    }
                }
                ids = Array(Set(ids))
                firstCombinationIDs = ids
                let priceables = productDetails?.priceables!
                for (priceIndex, priceable) in priceables!.enumerated(){
                    if priceable.id != object.id{
                        
                        priceableToLoad[priceIndex] = updatePriceable(index: priceIndex)
                        //replaced
                        updateFeatureCells(priceable: priceableToLoad[priceIndex], index: priceIndex)
                        
                    }
                    else{
                        priceableToLoad[priceIndex].selectedIndex = index
                    }
                }
                if totalRows == 1{
                    loadCharactristicArray()
                    updateTopCell()
                }
                return true
                
            }
        }
        
        return false
        
    }
    func updatePriceable(index : Int) -> Priceable1{
        var priceable = productDetails?.priceables![index]
        var indexsToRemove = [Int]()
        for (index, obj) in (priceable?.characteristics!.enumerated())!{
            if firstCombinationIDs!.contains(obj.id!){
                
            }
            else{
                indexsToRemove.insert(index, at: 0)
            }
            
        }
        for index in indexsToRemove{
            priceable?.characteristics?.remove(at: index)
        }
        return priceable!
        
    }
    //updated
    func updatePriceable1(index : Int) -> Priceable1{
        var priceable = productDetails?.priceables![index]
        var indexsToRemove = [Int]()
        for (index, obj) in (priceable?.characteristics!.enumerated())!{
            if secondCombinationIDs?.contains(obj.id!) ?? false{
                
            }
            else{
                indexsToRemove.insert(index, at: 0)
            }
            
        }
        for index in indexsToRemove{
            priceable?.characteristics?.remove(at: index)
        }
        return priceable!
        
    }
    
    func checkAndsetSecondPriceable(object: Priceable1, charactistic: Characteristic1, index : Int) -> Bool{
        //        if initialPricable == nil || initialPricable?._id == object._id
        if secondPricable == nil || secondPricable?.id == object.id {
            secondPricable = object
            secondChoise = charactistic
            
            
            if totalRows == 3 {
                
                
                var combinations : [String] = []// [Combination1]()
                for array in initialChoise?.combinations ?? []{
                    for (index,combination) in array.enumerated(){
                        
                        if combination.id == charactistic.id{
                            let requiredInded : Int = (index == 0 ? 1 : 0)
                            combinations.append(array[requiredInded].id!)
                            break
                        }
                        //                    combinations.append(combination)
                        //                    combinations.append(combination._id!)
                    }
                }
                secondCombinationIDs = combinations
            }
            
            
            
            
            for (priceIndex,priceable) in priceableToLoad.enumerated(){
                if priceable.id == object.id
                {
                    priceableToLoad[priceIndex].selectedIndex = index
                }
                else if priceable.id == initialPricable?.id{
                    
                }
                else{
                    priceableToLoad[priceIndex] = updatePriceable1(index: priceIndex)
                    //replaced
                    updateFeatureCells(priceable: priceableToLoad[priceIndex], index: priceIndex)
                    
                    
                    
                }
            }
            if totalRows == 2{
                loadCharactristicArray()
                updateTopCell()
            }
            return true
            
        }
        return false
        
    }
    func checkAllSelected() -> Bool {
        
        let allSelected = true
        if let priceAbles = productDetails?.priceables{
            for obj in priceAbles{
                if obj.selectedIndex == nil {
                    return false
                }
            }
        }
        return allSelected
    }
    func loadCharactristicArray(){
        characteristics = []
        //        if let priceAbles = productDetails?.priceables{
        for obj in priceableToLoad{
            if let chrAry = obj.characteristics{
                if let index = obj.selectedIndex {
                    let char =  chrAry[index]
                     characteristics.append(char.id ?? "")
                }
               
            }
        }
        //        }
    }
    func checkAndLoadCombination() -> Bool{
        if let combinations = productDetails?.combinations{
            var combinationSelected = false
            for comb in combinations{
                if let chrArray = comb.characteristics {
                    if chrArray.containsSameElements(as: characteristics){
                        selectedCombination = comb
                        combinationSelected = true
                        break
                    }
                }
            }
            if combinationSelected == false {
                selectedCombination = nil
            }
            else{
            }
            return combinationSelected
        }
        else{
            return false
        }
    }
    
    
}

