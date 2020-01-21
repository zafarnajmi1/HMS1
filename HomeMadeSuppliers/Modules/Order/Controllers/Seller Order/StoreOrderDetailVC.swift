//
//  OrderDetailVC.swift
//  Baqala
//
//  Created by apple on 12/5/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit



class StoreOrderDetailVC: UIViewController {
    
    //MARK:- outlets
    @IBOutlet weak var tableView: UITableView!

    //MARK:- properties and Structures
    var orderId: String?
    var delegate: CallBackDelegate?
    var orderDetail: OrderDetail?
    
    
    enum sections: Int {
        case profile = 0
        case address
        case paymentType
        case order
        static let count = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Order History".localized
        addBackBarButton()
       
        tableView.registerCell(id: StoreOrderSellerInfoTableViewCell.id)
        tableView.registerCell(id: StoreOrderDetailTableViewCell.id)
        tableView.registerCell(id: BillingAddressTableViewCell.id)
        tableView.registerCell(id: PaymentTypeTableViewCell.id)
        requestToFetchOrderDetail()
    }

  //MARK:-  web Requests
    
    func requestToFetchOrderDetail()  {
        guard let id = orderId else{
            nvMessage.showError(body: "Order Id Not found".localized)
            return
        }
        
        showNvLoader()
        OrderManager.shared.orderStoreDetail(id: id) { (result) in
            self.hideNvloader()
            
            switch result {
                
            case .sucess(let root):
                self.orderDetail = root.data
                self.tableView.reloadData()
                
            case .failure(let error):
                nvMessage.showError(body: error)
                
            }
        }
    }
    
    
    
    func requestToShipProduct() {
        let id = orderDetail?.id
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        OrderManager.shared.shipProductByOrderDetail(id: id!) { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .sucess(let rootModel):
                nvMessage.showSuccess(body: rootModel.message!, closure: {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.reloadData()
                })
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
    
    func shipOrderWithConfirmation()  {
        let msg = "Do you want to mark this order as Shipped?".localized
        self.presentAlert(message: msg, yes: {
              self.requestToShipProduct()
        }, no: nil)
    }
 
    
    
    func requestToCompletedProduct() {
        let id = orderDetail?.id
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        OrderManager.shared.completeProductByOrderDetail(id: id!) { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .sucess(let rootModel):
                nvMessage.showSuccess(body: rootModel.message!, closure: {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.reloadData()
                })
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
    
    func deliveredOrderWithConfirmation()  {
        let msg = "Do you want to mark this order as completed?".localized
        self.presentAlert(message: msg, yes: {
            self.requestToCompletedProduct()
        }, no: nil)
    }
}




//MARK:- tableView Extension
extension StoreOrderDetailVC: UITableViewDataSource, UITableViewDelegate {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // false case
        guard let sectionType = sections(rawValue: section) else {
            return 0
        }
        if orderDetail == nil {
            return 0
        }
        
        // true case
        switch sectionType {
        case .profile,.paymentType, .order:
            return 1
        case .address:
            return orderDetail?.user?.addresses?.count ?? 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let sectionType = sections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionType {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreOrderSellerInfoTableViewCell.id) as! StoreOrderSellerInfoTableViewCell
            cell.setData(model: orderDetail!, self)
            return cell
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: BillingAddressTableViewCell.id) as! BillingAddressTableViewCell
            let address = orderDetail?.user?.addresses?[indexPath.row]
            cell.setData(model: address)
            return cell
        case .paymentType:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTypeTableViewCell.id) as! PaymentTypeTableViewCell
            cell.setData(model: self.orderDetail)
            return cell
        case .order:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreOrderDetailTableViewCell") as! StoreOrderDetailTableViewCell
            cell.setData(model: orderDetail!)
            let statusType =  self.orderDetail?.status?.lowercased()
            cell.statusBtn.onTap {
                // self.shipOrderWithConfirmation()
                switch statusType {
                case "confirmed":
                    self.shipOrderWithConfirmation()
                case "shipped":
                    self.deliveredOrderWithConfirmation()
                default:
                    print("setup action for status \(statusType ?? "unkown" )")
                }
                
               
            }
            return cell
        }
    
      
    }
    
}



extension StoreOrderDetailVC: CallBackDelegate {
    func reloadData() {
        self.delegate?.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
}
