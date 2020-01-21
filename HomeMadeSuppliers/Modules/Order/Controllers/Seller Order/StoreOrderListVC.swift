//
//  StoreOrderListVC.swift
//  Baqala
//
//  Created by apple on 12/4/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Segmentio
import PullToRefreshKit

//MARK:- Enums
enum sellerOrderStatus:String {
    case all
    case confirmed
    case shipped
    case completed
    case cancelled
}

var sellerOrderSelectedStatus = sellerOrderStatus.all

class StoreOrderListVC: UIViewController {
  
    //MARK:- outlets
    @IBOutlet weak var mySegmentView: Segmentio!
    @IBOutlet weak var tableView: UITableView!
    

    //MARK:- properties and Structures
    var ordersPagination: Pagination?
    var orderList: [Order]?

  
    //MARK:- lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Order History".localized
        showNavigationBar()
        setupView()
       
    }
  
//    override func backToMain() {
//        self.dismiss(animated: true, completion: nil)
//    }
//    
    func setupView()  {
        self.addBackBarButton()
        setupSegmentList() //segments horizantal list
        self.tableView.registerCell(id: StoreOrderTableViewCell.id)
        self.tableView.contentInset = UIEdgeInsets(top: 12,left: 0,bottom: 12,right: 0)
        self.mySegmentView.selectedSegmentioIndex = 0
    }
 
    
    func setupSegmentList() {
        
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
        // handle tap event
        self.mySegmentView.valueDidChange = { segmentio, segmentIndex in
            
            switch segmentIndex {
            case 1:
                sellerOrderSelectedStatus = .confirmed
            case 2:
                sellerOrderSelectedStatus = .shipped
            case 3:
                sellerOrderSelectedStatus = .completed
            case 4:
                sellerOrderSelectedStatus = .cancelled
            default:
               sellerOrderSelectedStatus = .all
            }
            self.tableViewPullToRefresh()
        }
    }
    
    
    
    
}
//MARK:- base configuration ( on load View)
extension StoreOrderListVC {
    
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
        let perPage = 10 //MyPagination.shared.perPage
        let nextPage = ordersPagination?.next ?? 1
        let status = sellerOrderSelectedStatus.rawValue
        
        let params:[String:Any] = ["page": nextPage,
                                   "pagination": perPage,
                                   "status": status]
        
        
        
        OrderManager.shared.fetchSellerOrders(params: params) { (result) in
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
            self.tableView.setEmptyView(message: "No Record Found".localized)
            return
        }
        
        self.tableView.backgroundView = nil
        self.tableView.reloadData()
        
    }

    
    func moveToOrderDetail(order: Order?)  {
        let storyboard = UIStoryboard(name: "Order", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StoreOrderDetailVC") as! StoreOrderDetailVC
        vc.orderId = order?.id
        vc.delegate = self
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}



//MARK:- tableView Extension
extension StoreOrderListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreOrderTableViewCell.id) as! StoreOrderTableViewCell
        guard let model =  orderList?[indexPath.row] else {
            return UITableViewCell()
        }
       
        cell.setData(model: model)
        cell.sharedVC = self
        
        
     
       
        cell.myBtnView.on(.touchUpInside) { control, event in
            
            self.moveToOrderDetail(order: model)
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order =  orderList?[indexPath.row]
        moveToOrderDetail(order: order)
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
    
    
    
}

extension StoreOrderListVC: CallBackDelegate {
    func reloadData() {
        delay(bySeconds: 0.4, closure: {
            self.tableViewPullToRefresh()
        })
    }
    
    
}
