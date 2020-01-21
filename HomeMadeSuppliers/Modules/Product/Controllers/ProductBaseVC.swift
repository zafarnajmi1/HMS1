//
//  ProductBaseVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/27/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductBaseVC: UIViewController {

    //MARK:-  outlets
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var buyNowBtn: UIButton!
    
    var product: Product?
}



 //MARK:-  localization
extension ProductBaseVC {
    func setLocalization () {
        self.addToCartBtn.setTitle("Add To Cart".localized, for: .normal)
        self.buyNowBtn.setTitle("Buy Now".localized, for: .normal)
    }
}


//MARK:-  navigationBar setup
extension ProductBaseVC {
    func navigationBarButtonsSetup() {
        //navigation buttons
        switch myDefaultAccount {
        case .buyer:
            let items: [UIBarButtonItem] = [setChatBtn(),setCartBtn(), setShareBtn()]
            self.navigationItem.setRightBarButtonItems(items, animated: true)
        case .seller:
            addToCartBtn.isHidden = true
            buyNowBtn.isHidden = true
           // let items: [UIBarButtonItem] = [ setShareBtn(), setChatBtn()]
            let items: [UIBarButtonItem] = [setShareBtn()]
            self.navigationItem.setRightBarButtonItems(items, animated: true)
        default:
            
            let items: [UIBarButtonItem] = [ setShareBtn()]
            self.navigationItem.setRightBarButtonItems(items, animated: true)
        }
    }
}

extension ProductDetailVC {
    
    
    override func backToMain() {
        delegate?.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func moveToShare() {
        guard let product = product else { return }
        self.view.shareInApp(str: product.image ?? "Home Made Supplier".localized)
    }
    
    override func moveToCartVC() {
        let s = AppConstant.storyBoard.main
        let vc = s.instantiateViewController(withIdentifier: CartVC.id) as! CartVC
        vc.hidesBottomBarWhenPushed = true
        vc.comeFromProductDetail = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func moveToChatVC() {
        self.getConverSationObject()
    }
    
    
    
    func getConverSationObject()  {
        
        
        let socket = SocketIOManager.sharedInstance.getSocket()
        
        showNvLoader()
        
        let storeId = self.product?.store?.id
        //add ids to dictioanry
        let params: [String : Any] = ["product": self.product!.id!,
                                      "store": storeId! ,
                                      "locale": "en"]
        
        socket.emit("getConversation", with: [params])
        
        //step 3: call getConversation Data .on
        socket.on("getConversation") { [weak self] (data, ack) in
            
            
            
            let modified =  (data[0] as AnyObject)
            
            //hide loader
            self?.hideNvloader()
            
            //Map your response Object
            if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: modified) {
                let s = AppConstant.storyBoard.chat
                let vc = s.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                vc.conversation = rootModel.data?.conversation
                self!.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                nvMessage.showStatusError(body: "Response Changed")
            }
            
        }
        
        socket.on("newConversation") { (data, ack) in
            
            let modified =  (data[0] as AnyObject)
            
            //hide loader
            self.hideNvloader()
            
            //Map your response Object
            if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: modified) {
                let s = AppConstant.storyBoard.chat
                let vc = s.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                vc.conversation = rootModel.data?.conversation
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                nvMessage.showStatusError(body: "Response Changed")
            }
            
        }
        
    }
    
}








 //MARK:-  update cart count
extension ProductBaseVC {
    
    func requestToFetchCartList(){
        
        // showNvLoader()
        CartManager.shared.fetchCartList { (result) in
            //  self.hideNvloader()
            
            switch result {
            case .sucess(let root):
                let count = self.getTotalQty(cartItmes: root.data?.cart)
                self.tabBarController?.increaseBadge(indexOfTab: 3, num: count)
                AppUserDefault.shared.cartBadgeItems = Int(count?.description ?? "0")
                let items: [UIBarButtonItem] = [self.setChatBtn(),self.setCartBtn(), self.setShareBtn()]
                self.navigationItem.setRightBarButtonItems(items, animated: true)
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
    
}










