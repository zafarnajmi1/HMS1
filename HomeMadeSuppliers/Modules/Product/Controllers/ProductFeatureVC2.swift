//
//  ProductFeatureVC2.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/22/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//


import UIKit

class ProductFeatureVC2: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var weCanArriveLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var myContentView: UIView!
    @IBOutlet weak var myTitle: UILabel!
    
    
    
    var isBuyNowBtnTapped = false
    var delegate: ProductCollectionViewCellDelegate?
    
    var citySelectionIndex = -1
    enum sections: Int {
        case city
        case stepper
        case feature
        static var count = 3
    }
    
    
    //MARK:-  properties
    //data source
    var product: Product?
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
    var firstIndex : Int = -1
    var secondIndex : Int = -1
    var thirdIndex : Int = -1
    var firstCombinationIDs : [String]?
    var secondCombinationIDs : [String]?

    var foundCombinations : [Characteristic1]?

    var priceableToLoad : [Priceable1] = []
    var selectedCombination : Combination1?
    // end
    
    @IBOutlet weak var myContentViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLocalization()
    }
    

}

 //MARK:-  localization
extension ProductFeatureVC2 {
    private func setLocalization() {
        self.cancelBtn.setTitle("Cancel".localized, for: .normal)
        self.cartBtn.setTitle("Add To Cart".localized, for: .normal)
        self.buyNowBtn.setTitle("Buy Now".localized, for: .normal)
        self.weCanArriveLabel.text = "We Can Arrive In:".localized
    }
}




 //MARK:-  actions
extension ProductFeatureVC2 {
    
    @IBAction func addToCartBtnTapped(sender: UIButton) {
        isBuyNowBtnTapped = false
        
        if isValidCheckList() {
            requestToAddProductInCart()
        }
    }
    
    @IBAction func buyNowBtnTapped(sender: UIButton) {
        
        isBuyNowBtnTapped = true
        
        if isValidCheckList() {
            requestToAddProductInCart()
        }
    }
    
    
    
}

//MARK:-  view handling
extension ProductFeatureVC2 {
    
    private func setupView()   {
        collectionView.registerCell(id: DeliverableCityCollectionViewCell.id)
        collectionView.registerCell(id: StepperCollectionViewCell.id)
        collectionView.registerCell(id: DropDownCollectionViewCell.id)
        collectionView.registerCell(id: FeatureCollectionViewCell.id)
        
        // handle popupview
        if product?.priceables?.count == 0 {
            myContentViewHeight.constant = 320
        }
        cancelBtn.onTap {
            self.dismiss(animated: true, completion: nil)
        }
        
        //API Call
        self.myTitle.text = product?.title ?? "Add To Cart".localized
        requestToFetchProdcutDetail()
    }
    
    private func updateView()  {
        
        self.myContentView.isHidden = false
        
        totalRows = productDetails?.priceables?.count ?? 0
        priceableToLoad = productDetails?.priceables ?? []
        
        if let priceAbles = productDetails?.priceables{
            for obj in priceAbles{
                featureArray.append(obj.feature?.id ?? "")
            }
        }
        
        
        switch priceableToLoad.count {
        case 1:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.myContentViewHeight.constant = 400
            }, completion: nil)
        case 2:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.myContentViewHeight.constant = 460
            }, completion: nil)
        case 3:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.myContentViewHeight.constant = 600
            }, completion: nil)
        default:
            myContentView.layoutSubviews()
            myContentView.layoutIfNeeded()
            self.collectionView.reloadData()
        }
        
        
        myContentView.layoutSubviews()
        myContentView.layoutIfNeeded()
        self.collectionView.reloadData()
    }
    
    
    private func selectedFeaturesCell()  {
        
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
            
        }
    }
    
    // MARK:-  form Validaton
    private func isValidCheckList() -> Bool {
        
        let title = "Add To Cart".localized
        
        if product?.store?.deliverableCities?.count ?? 0 > 0 && selectedCity == nil && selectedDeliveryOption == .domestic {
            nvMessage.showStatusError(title: title, body: "Please select deliverable city".localized)
            return false
        }
        
        let index = IndexPath(row: 0, section: sections.stepper.rawValue)
        let cell = collectionView.cellForItem(at: index) as? StepperCollectionViewCell
        if let cell = cell {
            let available = cell.isvalidQunatiy()
            if available == false {
                nvMessage.showStatusError(title: title, body: "Out of stock".localized)
                return false
            }
        }
        
        if product?.isAvailable == false && product?.productType == "simple" {
            nvMessage.showStatusError(title:"Add to cart".localized, body: "Not in stock".localized)
            return false
        }
        
        //validate selected features
        self.selectedFeaturesCell()
        let productFeaturesCount = product?.priceables?.count ?? 0
        let selectedFeaturesCount = selectedFeatures.count
        
        if productFeaturesCount != selectedFeaturesCount {
            return false
        }
        
        
        return true
    }
}


 //MARK:-  network

extension ProductFeatureVC2 {

// fetch product detail
    func requestToFetchProdcutDetail()  {
        self.myContentView.isHidden = true
        self.showNvLoader()
        guard let id = product?.id  else { return }
        ProductManager.shared.productDetail(productID: id) { (response) in
            self.hideNvloader()
            switch response {
            case .sucess(let root):
                self.productDetails = root.data
               
                self.updateView()
            case .failure(let error):
                self.dismiss(animated: true, completion: nil)
                nvMessage.showError(body: error)
               
            }
        }
    }
   
 // add product to cart
    func requestToAddProductInCart() {
        
        guard  let product = productDetails else { return }
        var params: [String: Any] = ["product": product.id! ]
        
        params.updateValue(product.productType ?? "", forKey: "productType")
        
        
        
        
        //update quantity
        let index = IndexPath(row: 0, section: sections.stepper.rawValue)
        let cell = collectionView.cellForItem(at: index) as? StepperCollectionViewCell
        if let cell = cell {
            params.updateValue(cell.quantity, forKey: "quantity")
        }
        
        switch selectedDeliveryOption {
        case .domestic:
            params.updateValue("domestic", forKey: "shipping")
            params.updateValue(selectedCity?.id ?? "", forKey: "deliverableCity")
        case .city:
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
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.buyNowBtnTapped(billAmount: root.data?.totalWithShipping)
                    return
                }
                
                nvMessage.showSuccess(body: root.message ?? "", closure: {
                    NotificationCenter.default.post(name: .didUpdateCartCount, object: nil)
                    self.dismiss(animated: true, completion: nil)
                    
                })
            case let .failure(error):
                nvMessage.showError(body: error)
            }
        }
    }
    
    
}

 //MARK:-  collection cell layout
extension ProductFeatureVC2: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 0 , height: 0)
        guard let tableSection = sections(rawValue: indexPath.section) else { return size }
        
        switch tableSection {
        case .feature:
            let cellMarginLR: CGFloat =  36
            let cellWidth = collectionView.frame.size.width
            return CGSize(width: cellWidth - cellMarginLR , height: 80)
        case .stepper:
            let cellMarginLR: CGFloat =  36
            let cellWidth = collectionView.frame.size.width
            return CGSize(width: cellWidth - cellMarginLR , height: 80)
        case .city:
            return cityCellSize()
            
            
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let defaultInsets = UIEdgeInsets (top: 4, left: 16, bottom: 4, right: 16)
        // guard let tableSection = sections(rawValue: section) else { return defaultInsets }
        return defaultInsets
    }
    
    
    
  private func cityCellSize() -> CGSize {
        let cities = productDetails?.store?.deliverableCities
        if cities?.count ?? 0 > 0 {
            let cellMarginLR: CGFloat =  20
            let cellWidth = collectionView.frame.size.width * 0.50
            return CGSize(width: cellWidth - cellMarginLR , height: 32)
        }
        else { //Gloable delivery cell size
            let cellMarginLR: CGFloat =  32
            let cellWidth = collectionView.frame.size.width
            return CGSize(width: cellWidth - cellMarginLR , height: 32)
        }
    }
}

 //MARK:-  collection view data source
extension ProductFeatureVC2: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = sections(rawValue: section) else {return 0}
        switch sectionType {
        case .city:
            let items = productDetails?.store?.deliverableCities?.count ?? 0
            return items == 0 ? 1:items
        case .stepper:
            return productDetails == nil ? 0:1
        case .feature:
            return priceableToLoad.count
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = sections(rawValue: indexPath.section) else {
            return UICollectionViewCell() }
        
        switch sectionType {
            
        case .city:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeliverableCityCollectionViewCell.id, for: indexPath) as! DeliverableCityCollectionViewCell
            let store = productDetails?.store
            if store?.deliverableCities?.count ?? 0 > 0 {
                let model = store?.deliverableCities?[indexPath.row]
                cell.setData(model: model!)
            }
            else { // domestic Price
                cell.label.text = "All Over The UAE".localized
                cell.value.text = setDefualtCurrency(price: product?.store?.domesticShipping)
            }
            
            if citySelectionIndex == indexPath.row {
                cell.myContentView.layer.borderColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
                self.citySelectionIndex = indexPath.row
                
            }
            else {
                cell.myContentView.layer.borderColor = #colorLiteral(red: 0.7960784314, green: 0.8, blue: 0.8039215686, alpha: 1)
            }
            
            return cell
            
        case .stepper:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StepperCollectionViewCell.id, for: indexPath) as! StepperCollectionViewCell
            cell.delegate = self
            cell.setData(model: self.productDetails!)
            return cell
        case .feature:
            
            return handleFeatures(indexPath, collectionView)
        }
    }
    
    func handleFeatures(_ indexPath: IndexPath, _ collectionView: UICollectionView) -> UICollectionViewCell {
        
        let priceable = self.priceableToLoad[indexPath.row]
       
        
        switch priceable.feature?.howToShow {
        case "dropdown":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DropDownCollectionViewCell.id, for: indexPath) as! DropDownCollectionViewCell
            cell.setData(priceable: priceable, self)
            return cell
        default: // radio
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeatureCollectionViewCell.id, for: indexPath) as! FeatureCollectionViewCell
            cell.setData(priceable: priceable, self)
            
            return cell
        }
    }
}

 //MARK:-  collection view delegate
extension ProductFeatureVC2: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = sections(rawValue: indexPath.section) else { return }
        
        switch sectionType {
        case .city:
            let cell = collectionView.cellForItem(at: indexPath) as! DeliverableCityCollectionViewCell
            let cities = productDetails?.store?.deliverableCities
            if cities?.count ?? 0 > 0 {
                self.selectedCity = cities?[indexPath.row]
            }
            
            
            cell.myContentView.layer.borderColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
            self.citySelectionIndex = indexPath.row
            
            collectionView.reloadSections([sectionType.rawValue])
          
            

            
        default:
            return
        }
        
        
        
    }
}


//MARK:-  Combinations Handling
extension ProductFeatureVC2: FeatureCollectionViewCellDelegate {
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



extension ProductFeatureVC2 {
    
    func updateFeatureCells(priceable: Priceable1, index: Int)  {
        switch priceable.feature?.howToShow  {
        case "dropdown":
            let indexPath = IndexPath(row: index, section: sections.feature.rawValue)
            let cell = collectionView.cellForItem(at: indexPath) as! DropDownCollectionViewCell
            cell.setData(priceable: priceable, self)
            cell.textField.text = ""
            cell.selectedOptionId = nil

        default: // radio
            let indexPath = IndexPath(row: index, section: sections.feature.rawValue)
            let cell = collectionView.cellForItem(at: indexPath) as! FeatureCollectionViewCell
            cell.setData(priceable: priceable, self)
        }
    }
 
}




extension ProductFeatureVC2: StepperCollectionViewCellDelegate {
    //delegate method
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
        
        // reset deliverable city
        self.selectedCity = nil
        self.citySelectionIndex = -1
        collectionView.reloadSections([sections.city.rawValue])
        
        //reset Features cell
        for (index,priceable) in priceableToLoad.enumerated() {
            
            switch priceable.feature?.howToShow  {
            case "dropdown":
                let indexPath = IndexPath(row: index, section: sections.feature.rawValue)
                let cell = collectionView.cellForItem(at: indexPath) as! DropDownCollectionViewCell
                cell.setData(priceable: priceable, self)
                cell.textField.text = ""
                cell.selectedOptionId = nil
                
            default: // radio
                let indexPath = IndexPath(row: index, section: sections.feature.rawValue)
                let cell = collectionView.cellForItem(at: indexPath) as! FeatureCollectionViewCell
                cell.setData(priceable: priceable, self)
                cell.selectedOptionId = nil
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
            let section = sections.stepper.rawValue
            if let cell = collectionView.cellForItem(at: IndexPath.init(row: 0, section: section)) as? StepperCollectionViewCell
            {
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
            if let chrAry = obj.characteristics, let index = obj.selectedIndex{
                let chr = chrAry[index]
                characteristics.append(chr.id ?? "")
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




