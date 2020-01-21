//
//  MyOrderDetailVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/24/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class MyOrderDetailVC: UIViewController {
    
    //MARK:- outlets
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var totalProductsLabel: UILabel!
    @IBOutlet weak var totalProducts: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var shippingAmountLabel: UILabel!
    @IBOutlet weak var shippingAmount: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- properties
    var delegate: CallBackDelegate?
    var orderId: String?
    var orderDetail : OrderDetailData?
    var completedProductId: String?
    
     //MARK:-  life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Order Detail".localized
        addBackBarButton()
        setLocalization()
        tableView.registerCell(id: MyOrderDetailTableViewCell.id)
        self.requestToFetchOrderDetail()
        
    }
  
}

 //MARK:- localization
extension MyOrderDetailVC {
   private func setLocalization() {
        self.dateLabel.text = "Date:".localized
        self.totalProductsLabel.text = "Total Products:".localized
        self.statusLabel.text = "Status:".localized
        self.totalAmountLabel.text = "Total Amount:".localized
    }
}

//MARK:-  helpers
extension MyOrderDetailVC {
    
    private func updateView()  {
        let orderPrefix = "Order # ".localized
        self.orderNumber.text = "\(orderPrefix) \(orderDetail?.orderNumber ?? "")"
        self.date.text = setDateFormatBy(dateString: orderDetail?.createdAt ?? "")
        self.totalProducts.text = "\(orderDetail?.orderItemsCount ?? 0)"
        self.totalAmount.text = setDefualtCurrency(price: orderDetail?.total)
        self.shippingAmount.text = "" //setDefualtCurrency(price: orderDetail.)
        self.status.text = getformatedStatus(pending: orderDetail?.pendingOrderItemsCount,
                                             shipped:orderDetail?.shippedOrderItemsCount ,
                                             delivered:orderDetail?.deliveredOrderItemsCount)
        tableView.reloadData()
    }
    
    private func deliveredOrderWithConfirmation()  {
        let msg = "Do you want to mark this order as Delivered?".localized
        self.presentAlert(message: msg, yes: {
            self.requestToCompletedProduct()
        }, no: nil)
    }
}


//MARK:- network
extension MyOrderDetailVC {
    
    private func requestToFetchOrderDetail()  {
        guard let id = orderId else {
            nvMessage.showError(body: "Order id not found".localized)
            return
        }
        
        showNvLoader()
        OrderManager.shared.orderDetail(id: id) { (result) in
            self.hideNvloader()
            
            switch result {
                
            case .sucess(let root):
                self.orderDetail = root.data
                self.updateView()
                
            case .failure(let error):
                nvMessage.showError(body: error)
                
            }
        }
    }
    
    private func requestToCompletedProduct() {
        let id = completedProductId
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
    
    
}


//MARK:-  tableview
extension MyOrderDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetail?.orderDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyOrderDetailTableViewCell.id) as! MyOrderDetailTableViewCell
        let model = orderDetail?.orderDetails![indexPath.row]
        cell.loadCell(model: model!)
        cell.statusBtn.onTap {
            self.completedProductId = model?.id
            self.deliveredOrderWithConfirmation()
        }
        return cell
    }
    
    
}
