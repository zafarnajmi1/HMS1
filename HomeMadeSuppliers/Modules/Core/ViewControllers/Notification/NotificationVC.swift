//
//  NotificationVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/21/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import ObjectMapper


class NotificationVC: UIViewController {
    
    //MARK:-  outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteAllBtn: UIButton!
    
    //MARK:-  properties
    var page = 1
    var totalPage = 0
    var notificationList = [NotificationModel]()
    
    let socket = SocketIOManager.sharedInstance.getSocket()
    
    var selectedIndepath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Notification".localized
        self.deleteAllBtn.setTitle("Delete All".localized, for: .normal)
        self.setupView()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupView()
        
    }
     override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()
        
           if myDefaultLanguage == .ar {
               self.view.semanticContentAttribute = .forceRightToLeft
              
           }else{
               self.view.semanticContentAttribute = .forceLeftToRight
              }
       }
    func setupView()  {
        self.tableView.estimatedRowHeight = 200
         addMenuBarBtn()
        if myDefaultAccount == .buyer || myDefaultAccount == .seller {
            self.notificationSocket()
            tableView.pullToRefresh {
                self.page = 1
                self.totalPage = 0
                self.notificationSocket()
            }
        }
        else {
            deleteAllBtn.isHidden = true
            tableView.setEmptyView(message: "You are in guest mode".localized)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
     //MARK:- actions

    @IBAction func deletAllBTnTapped(_ sneder: UIButton) {
        self.presentAlert(message: "Do you want to delete All notifications?".localized, yes: {
            self.removeAllNotification()
        }, no: nil)
    }
}


//MARK:-  table View Implementation
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count  //fix me
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        let model = notificationList[indexPath.row]
        cell.setData(model: model)
        
        //actions
        cell.removeBtn.onTap {
            let msg = "Do you want to remove this notification?".localized
            self.presentAlert(title: "Notification".localized, message: msg, yes: {
                self.removeNotification(index: indexPath.row)
            }, no: nil)
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //read status
        let notification = self.notificationList[indexPath.row]
        
        if notification.seen == false {
            
            let socket = SocketIOManager.sharedInstance.getSocket()
            
            let list = [notification.id!]
            let parms = ["notifications": list]
            socket.emit("notificationsSeen", with: [parms])
            
            let cell = tableView.cellForRow(at: indexPath) as! NotificationTableViewCell
            cell.unseenView.isHidden = true
            
        }
        
        
        if myDefaultAccount == .seller || myDefaultAccount == .buyer {
            self.didSelectEvent(notification: notification)
        }
       
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height - 10 {
            
            if self.page <= self.totalPage {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                let dic = ["page": self.page] as [String: Any]
                socket.emit("notificationsList", dic)
            }
            
        }
    }
    
}


//MARK:-  socket Implementation

extension NotificationVC {
    
    func notificationSocket(){
        
        let dic = ["page": self.page] as [String: Any]
        socket.emit("notificationsList",dic)
        
        self.showNvLoader()
        socket.on("notificationsList"){(data, ack)in
            self.tableView.stopLoader()
            
            //MARK:- StopProccessHere
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.hideNvloader()
            ProgressHUD.dismiss(animated: true)
            
            
          
            let modified = data[0] as AnyObject
            
            if let obj =  Mapper<NotificationAPIResponse>().map(JSONObject: modified) {
                
                
                if obj.success == true {
                    
                    self.totalPage = (obj.data?.pagination?.pages)!
                    
                    if self.page == 1 {
                        self.notificationList = (obj.data?.notifications)! // default list
                        self.page += 1
                    }
                    else {
                        
                        if self.page <= self.totalPage {
                            
                            self.page += 1 //increment in current page
                            
                            for model in (obj.data?.notifications)! {
                                self.notificationList.append(model)
                            }
                        }
                    }
                    
                    let count = obj.data?.unseenNotificationsCount ?? 0
                    AppUserDefault.shared.notificationCount = count
                    UIApplication.shared.applicationIconBadgeNumber = count
                    if count == 0 {
                        self.tabBarController?.increaseBadge(indexOfTab: 2, num: nil)
                    }
                    else {
                        self.tabBarController?.increaseBadge(indexOfTab: 2, num: "\(count)")
                    }
                    
                    
                    
                    if self.notificationList.count == 0 {
                        self.tableView.reloadData()
                        self.tableView.setEmptyView()
                        self.deleteAllBtn.isHidden = true
                    }
                    else {
                        self.deleteAllBtn.isHidden = false
                        self.tableView.backgroundView = nil
                        self.tableView.reloadData()
                        print(self.notificationList.count)
                    }
                    
                    
                }
                else {
                    let msg = obj.message
                    nvMessage.showError(body: msg ?? "")
                }
            }
            
        }
        
        
        socket.on("newNotification"){(data , ack )in
            let dic = ["page": self.page] as [String: Any]
            self.socket.emit("notificationsList", dic)
            
        }
        socket.on("removeNotifications"){(data , ack)in
            
            let modified = data[0] as AnyObject
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
        }
        socket.on("notificationsChanged"){(data, ack)in
            let dic = ["page": self.page] as [String: Any]
            self.socket.emit("notificationsList",dic)
        }
        
        
        
    }
    
    
    func seenNotificationAray() {
        
        let socket = SocketIOManager.sharedInstance.getSocket()
        
        
        let notificationIds = notificationList.compactMap({$0.id})
        let json = ["notifications":notificationIds ]
        
        #if DEBUG
        print(self.notificationList.count)
        print(notificationIds)
        print(json)
        #endif
        socket.emit("notificationsSeen", with: [json])
        
    }
    
    
    func removeNotification(index : Int) {
        
        let socket = SocketIOManager.sharedInstance.getSocket()
        
        var notificationIds = [String]()
        let notification = self.notificationList[index]
        notificationIds.append(notification.id!)
        let json2 = ["notifications": notificationIds]
        
        if(notificationIds.count > 0) {
            
            socket.emit("removeNotifications", with: [json2])
            self.notificationList.remove(at: index)
            
            self.tableView.reloadData()
        }
    }
    
    func removeAllNotification() {
        
        let socket = SocketIOManager.sharedInstance.getSocket()
        
        let notificationIds = notificationList.compactMap({$0.id})
        let json = ["notifications":notificationIds ]
        
        #if DEBUG
        print(self.notificationList.count)
        print(notificationIds)
        print(json)
        #endif
        
        if notificationIds.count > 0{
            socket.emit("removeNotifications", with: [json])
            
            self.notificationList.removeAll()
            self.tableView.reloadData()
            self.tableView.setEmptyView()
            self.deleteAllBtn.isHidden = true
        }
    }
    
    
    
    
    func didSelectEvent(notification: NotificationModel)  {

        //        Notification Keys (Save This for later use)
//        ----------------------
//        1- NEW_ORDER (Open store Order Detail)
//        2- ORDER_RECEIVED (Open store Order Detail)
//        3- ORDER_SHIPPED (Open User Order Detail)
//        4- NEW_ORDER_PLACED (Open User Order Detail)
//        5- PRODUCT_RESTOCKED (Open product Detail)
//        6- PRODUCT_DELETED (Open product Detail)
//        7- OPEN_CONVERSATION (Open Messages Of Conversation)
//        8- PRODUCT_APPROVED ( open product detail pagde
        if notification.action == "NEW_ORDER" || notification.action == "ORDER_RECEIVED" {
            moveToStoreOrderDetail(object: notification)
            return
        }
        
        if notification.action == "ORDER_SHIPPED" || notification.action == "NEW_ORDER_PLACED" || notification.action == "ORDER_REFUNDED" {
            moveToBuyerOrderDetail(object: notification)
            return
        }
        
      
        if notification.action == "PRODUCT_RESTOCKED" || notification.action == "PRODUCT_DELETED" || notification.action == "PRODUCT_APPROVED" {
            moveToProductDetail(object: notification)
        }
        
        if notification.action == "OPEN_CONVERSATION" {
            self.getConversationObject(object: notification)
            return
        }
        
    }
    
   
    
    
    func moveToStoreOrderDetail(object: NotificationModel) {
        let storyboard = UIStoryboard(name: "Order", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoreOrderDetailVC.id) as! StoreOrderDetailVC
        vc.orderId = object.extras?.orderDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToBuyerOrderDetail(object: NotificationModel) {
        
        let storyboard = AppConstant.storyBoard.order
        let vc = storyboard.instantiateViewController(withIdentifier: MyOrderDetailVC.id) as! MyOrderDetailVC
        
        vc.orderId = object.extras?.order
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func moveToProductDetail(object: NotificationModel) {
        let storyboard = AppConstant.storyBoard.product
        let vc = storyboard.instantiateViewController(withIdentifier: ProductDetailVC.id) as! ProductDetailVC
        vc.productId = object.extras?.product
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- Get Conversation Object
    func getConversationObject(object: NotificationModel)  {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let socket = SocketIOManager.sharedInstance.getSocket()
        
        //step 2: call getConversation .emit
        guard let productId = object.extras?.conversation else {
            nvMessage.showError(body: "Conversation Id Not Found")
            return
        }
        let conversation = object.extras?.conversation
        
        //add ids to dictioanry
        let params = ["_id":  conversation!, "product_id": productId] as[String : Any]
        
        socket.emit("getConversation", with: [params])
        
        //step 3: call getConversation Data .on
        socket.on("getConversation") { [weak self] (data, ack) in
            
            socket.off("getConversation")
            
            let modified =  (data[0] as AnyObject)
            
            //hide loader
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            
            
            //Map your response Object
            if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: modified) {
                
                self?.navigateToChatVC(rootModel)
            }
            else {
                nvMessage.showStatusError(body: "Response Changed")
            }
            
        }
    }
    
    //common method in convesation
     func navigateToChatVC(_ rootModel: ConversationAPIResponse) {
        
        let model =  rootModel.data?.conversation!

        let storyboard = AppConstant.storyBoard.chat
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.conversation = rootModel.data?.conversation


        
        switch myDefaultAccount {

        case .seller:
    
            vc.navigationTitle = model?.user?.fullName ?? "Unkown name"

        case .buyer:
            vc.navigationTitle = model?.store?.storeName ?? "Unkown name"

        default:
            print("No Account Selected")
        }


        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
}


