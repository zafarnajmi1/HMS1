//
//  MyOrderListVC.swift
//  Baqala
//
//  Created by apple on 12/5/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Segmentio




class MyOrderListVC: UIViewController {

    //MARK:- outlets
    @IBOutlet weak var mySegmentView: Segmentio!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- properties and Structures
    var isComeFromCheckout = false
    var orderList: [Order]?
    var ordersPagination: Pagination?
    enum OrderStatus: String {
        case all
        case confirmed
        case shipped
        case completed
        case cancelled
    }
    var currentStatus = OrderStatus.confirmed
    
    
    
    //MARK:- lifeCycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Orders".localized
       
        showNavigationBar()
        setupView()
       
        
    }

    
    override func backToMain() {
        if isComeFromCheckout {
            AppSettings.shared.moveToRootMainVC()
        }
        else {
           self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func setupView()  {
        addBackBarButton()
        setupSegmentList()
        self.tableView.registerCell(id: MyOrderTableViewCell.id)
        self.tableView.contentInset = UIEdgeInsets(top: 12,left: 0,bottom: 12,right: 0)
        self.mySegmentView.selectedSegmentioIndex = 0
    }
    

    fileprivate func setupSegmentList() {

        let titleList = ["All".localized,
                         "Confirmed".localized,
                         "Shipped".localized,
                         "Completed".localized,
                         "Cancelled".localized]
        
        var content = [SegmentioItem]()
        
        for title in titleList {
            let tornadoItem = SegmentioItem(title: title , image: nil)
            content.append(tornadoItem)
        }

        self.mySegmentView.setupSegmentio(content: content)
        

        self.mySegmentView.valueDidChange = { segmentio, segmentIndex in

            switch segmentIndex {
            case 1:
                self.currentStatus = .confirmed

            case 2:
                self.currentStatus = .shipped
            case 3:
                self.currentStatus = .completed
            case 4:
                self.currentStatus = .cancelled
            default:
               self.currentStatus = .all
            }

            self.tableViewPullToRefresh()
        }
    }

    func tableViewPullToRefresh() {
        
        self.tableView.pullToRefresh {
            //call your function to update table View
            self.ordersPagination = nil
            self.orderList = nil
            self.tableView.backgroundView = nil
            self.requestToFetchOrder()

        }
        self.tableView.switchRefreshHeader(to: .refreshing)
        self.view.isUserInteractionEnabled = false
       
    }
    

    func requestToFetchOrder()  {
        let status = currentStatus.rawValue
        let perPage = 10 //MyPagination.shared.perPage
        let nextPage = ordersPagination?.next ?? 1
        
        let params:[String:Any] = ["status": status,
                                   "page": nextPage,
                                   "pagination": perPage]
      
        
        
        OrderManager.shared.fetchBuyerOrders(params: params) { (result) in
            self.tableView.stopLoader()
            ProgressHUD.dismiss(animated: true)
            delay(bySeconds: 0.5, closure: {
                 self.view.isUserInteractionEnabled = true
            })

            switch result {
            case .sucess(let root):
                self.updateList(response: root)
                
            case .failure(let error):
                self.tableView.setEmptyView(message: error)
            }
            
        }
    }

 
        func updateList(response: OrderAPIResponse? )  {
            
            self.ordersPagination = response?.data?.pagination
            
            if self.ordersPagination?.page ?? 0 == 1 {
                self.orderList = response?.data?.collection
                self.reloadTableView()
               
            }
            else {
                self.orderList?.append(contentsOf: response?.data?.collection ?? [])
                self.tableView.reloadData()
            }
            
        }
        
        func reloadTableView()  {
            
            if orderList?.count ?? 0 == 0 {
                self.tableView.reloadData()
                self.tableView.setEmptyView(message: "No record found".localized)
                return
            }
            
            self.tableView.backgroundView = nil
            self.tableView.reloadData()
            
        }
 
  

}

//MARK:- tableView Extension

extension MyOrderListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyOrderTableViewCell.id ) as! MyOrderTableViewCell

        guard let model = orderList?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setData(model: model)

        // cell actions
        cell.myBtnView.onTap {
            self.didSelect(order: model)
        }
        
        return cell
    }
    

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if (tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height - 10 {
            
            let canFetch = MyPagination.shared.checkFetchMore(model: ordersPagination)
            if canFetch {
                ProgressHUD.present(animated: true)
                self.requestToFetchOrder()
            }
            
        }
    }

    func didSelect(order: Order) {
                    let storyboard = UIStoryboard(name: "Order", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: MyOrderDetailVC.id) as! MyOrderDetailVC
                    vc.orderId = order.id
                    vc.delegate = self
        
                    self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyOrderListVC: CallBackDelegate {

    func reloadData() {
        delay(bySeconds: 0.5) {
             self.tableViewPullToRefresh()
        }
       
    }
    
    
}
