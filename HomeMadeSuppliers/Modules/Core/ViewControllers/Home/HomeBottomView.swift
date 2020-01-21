//
//  HomeBottomCollection.swift
//  HomeMade2
//
//  Created by Apple on 04/07/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit


protocol HomeBottomViewDelegate : class {
    func itemScrolled(lastIndex : Int, index: Int)
    func didSelect(object: Store)
}

class HomeBottomView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btn_left: UIButton?
    @IBOutlet weak var btn_right: UIButton?
    var lastIndex : Int = -1
    var currentIndex : Int = -1
    weak var delegate: HomeBottomViewDelegate?
    
    private var storesList : [Store] = []
    
    var stores : [Store]{
        set {
            storesList = newValue
            collectionView.reloadData()
            if storesList.isEmpty {
                updateButtons(index: -1)
            }
            else{
                lastIndex = 0
                currentIndex = 0
                updateButtons(index: currentIndex)
            }
            
        }
        get{
            return storesList
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerCell(id: MapStoreCollectionViewCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        btn_left?.setImage(UIImage(named: "arrow_previous_grey"), for: .disabled)
        btn_right?.setImage(UIImage(named: "arrow_next_grey"), for: .disabled)
        let itemWidth = AppSettings.screenWidth-16
        let itemHeight : CGFloat = 120.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //        let screenWidth = UIScreen.main.bounds.size.width
        //        let screenHeight = UIScreen.main.bounds.size.height
//        let itemWidth = AppSettings.screenWidth
//        let itemHeight = itemWidth * (934/1080)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight-1)
        collectionView.collectionViewLayout = layout
        
        
        
        
    }

   
    @IBAction func onClick_left(_ sender : UIButton){
    
        
        let index = currentIndex
        if index > 0 {
            scroll(to: index - 1)
        }
        
        
        
        print("Index: \(index)")
    }
    @IBAction func onClick_right(_ sender : UIButton){
        let index = currentIndex
        if index != -1 && index < stores.count - 1 {
            scroll(to: index + 1)

        }
    }
    func scroll(to index : Int){
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        
        updateButtons(index: index)
    }

    
    
    func updateButtons(index : Int){
        
        if index == -1{
            nextGrey()
            previousGrey()
        }
        else{
            if index == 0 {
                previousGrey()
            }
            else{
                previousOrange()
                
            }
            if index == stores.count - 1{
                nextGrey()
            }
            else{
                nextOrange()
            }
            lastIndex = currentIndex
            currentIndex = index
            delegate?.itemScrolled(lastIndex: lastIndex, index: currentIndex)
        }
        
    }
    func nextOrange(){
        btn_right?.isEnabled = true
        btn_right?.setImage(UIImage(named: "arrow_next_yellow"), for: .normal)
    }
    func nextGrey(){
        btn_right?.isEnabled = false
        btn_right?.setImage(UIImage(named: "arrow_next_grey"), for: .normal)
    }
    func previousOrange(){
        btn_left?.isEnabled = true
        btn_left?.setImage(UIImage(named: "arrow_previous_yellow"), for: .normal)
    }
    func previousGrey(){
        btn_left?.isEnabled = false
        btn_left?.setImage(UIImage(named: "arrow_previous_grey"), for: .normal)
    }
    

}
extension HomeBottomView : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stores.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapStoreCollectionViewCell.id, for: indexPath) as! MapStoreCollectionViewCell
        let store = stores[indexPath.row]
        cell.setData(model: store)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let store = stores[indexPath.row]
         delegate?.didSelect(object: store)
    }
    
    
}
extension HomeBottomView : UIScrollViewDelegate{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
//        print("Image Preview DidEndScrollingAnimation")
        previewEndScrolling()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: nil, afterDelay: 0.3)
//        print("Image Preview ScrollViewDidScroll")
    }
    
    func previewEndScrolling() {
        let page = Int(collectionView.contentOffset.x / collectionView.frame.width)
        delegate?.itemScrolled(lastIndex: lastIndex, index: page)
        updateButtons(index: page)
        
        
    }
}


