//
//  StorePager.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/31/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ObjectMapper

class StorePagerVC: ButtonBarPagerTabStripViewController {

    
    var store: Store?
    
    override func viewDidLoad() {
        self.setHeaderAppearance()
        super.viewDidLoad()
        self.navigationItem.title = store?.storeName ?? "Supplier Detail".localized
        setupView()
    }
    
    
    func setupView()  {
        self.showNavigationBar()
        addBackBarButton()
        switch myDefaultAccount {
        case .buyer:
            let items: [UIBarButtonItem] = [setChatBtn()]
            self.navigationItem.setRightBarButtonItems(items, animated: true)
        default:
            return
        }
    }
    
    override func moveToChatVC() {
        self.getConverSationObject()
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let s = AppConstant.storyBoard.main
        let child1 = s.instantiateViewController(withIdentifier: StoreDetailVC2.id) as! StoreDetailVC2
        child1.store = self.store
        
        let child2 = s.instantiateViewController(withIdentifier: StoreReviewVC.id) as! StoreReviewVC
        child2.store = self.store
    
        
        return [child1, child2]
    }
    

}


extension  ButtonBarPagerTabStripViewController {
    
     func setHeaderAppearance() {
        
        settings.style.selectedBarHeight = 0 //line
        settings.style.buttonBarMinimumLineSpacing = 2
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarVerticalAlignment = .middle
    
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            oldCell?.contentView.backgroundColor = #colorLiteral(red: 0.9958658814, green: 1, blue: 0.9999271035, alpha: 1)
            oldCell?.label.font = robotoMedium16
            newCell?.label.textColor = .white
            newCell?.contentView.backgroundColor =  #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
            newCell?.label.font = robotoMedium16
            // let selectedTab = newCell?.label.text
            
        }
        
    }
}


extension StorePagerVC {
    
   
    
    func getConverSationObject()  {
        
        
        let socket = SocketIOManager.sharedInstance.getSocket()
        
        guard let storeId = store?.id else {
            return nvMessage.showError(body: "Store Id not found".localized)
        }
        
        showNvLoader()
    
        
        //add ids to dictioanry
        let params: [String : Any] = ["store": storeId,
                                      "locale": "en"]
        
        socket.emit("getConversation", with: [params])
        
        //step 3: call getConversation Data .on
        socket.on("getConversation") { [weak self] (data, ack) in
            
            //hide loader
            self?.hideNvloader()
            let modified =  (data[0] as AnyObject)
            self?.moveToChatVC(modified)
           
            
        }
        
        socket.on("newConversation") {[weak self] (data, ack) in
            //hide loader
            self?.hideNvloader()
            let modified =  (data[0] as AnyObject)
            self?.moveToChatVC(modified)
            
        }
        
    }
    
    fileprivate func moveToChatVC(_ modified: (AnyObject)) {
        //Map your response Object
        if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: modified) {
            let s = AppConstant.storyBoard.chat
            let vc = s.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.conversation = rootModel.data?.conversation
            vc.navigationTitle = self.store?.storeName ?? "Chat"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            nvMessage.showStatusError(body: "Response Changed")
        }
    }
}

