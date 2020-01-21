//
//  StoreReviewVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/31/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Cosmos
class StoreReviewVC: UIViewController {

     //MARK:- outlet
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- variables
    var store: Store?
    private var reviews: [Review]?
    private var reviewPagination: Pagination?
    private var canReview = false
    private var productId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //register
        tableView.registerCell(id: RatingReviewTableViewCell.id)
        tableView.registerCell(id: SubmitReviewTableViewCell.id)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 200
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        showNvLoader()
        self.requestToFetchStoreReviews()
        self.reloadContentView()
    }
    
    func reloadContentView()  {
        switch myDefaultAccount {
       
        case .buyer:
            canReview = store?.canReviewUsers?.count ?? 0 > 0 ? true:false
            self.productId = store?.canReviewUsers?.compactMap{$0.product}.first
            self.tableView.reloadData()
          default:
          canReview = false
        }
    }

    
    
}

 //MARK:-  setup API with Pagination
extension StoreReviewVC {
    
    func requestToFetchStoreReviews(){
        
        guard let productId = store?.id else {
            nvMessage.showError(body: "Store Id Not Found".localized)
            return
        }
        
        let perPage = 50
        let nextPage = reviewPagination?.next ?? 1
        
        let params = ["_id": productId,
                      "pagination": perPage,
                      "page": nextPage] as [String: Any]
        
        
        StoreManager.shared.storeReviews(params: params ) { (result) in
            
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
        self.tableView.backgroundView = nil
        
        if reviewPagination?.page ?? 0 == 1 {
            self.reviews = response?.reviews ?? []
            self.tableView.reloadData()
        }
        else {
            self.reviews?.append(contentsOf: response?.reviews ?? [])
            self.tableView.reloadData()
        }
        
        if reviews?.count ?? 0 == 0 {
            tableView.setEmptyView(message: "No Reviews".localized)
        }
        
    }
    
   
    
}

extension StoreReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return canReview == true ? 1:0
        default:
            return reviews?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubmitReviewTableViewCell.id) as! SubmitReviewTableViewCell
            cell.delegate = self
            cell.isProductRequest = false
            cell.reviewLabel.text = "Review This Store".localized
            cell.productId = productId
            cell.storeId = store?.id
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: RatingReviewTableViewCell.id) as! RatingReviewTableViewCell
            let model = reviews?[indexPath.row]
            cell.setData(model: model!)
            if reviews!.count - 1 == indexPath.row  {
                cell.sperator.isHidden = true
            }
            else {
                cell.sperator.isHidden = false
            }
            return cell
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height - 20 {
            let canFetch = MyPagination.shared.checkFetchMore(model: reviewPagination)
            if canFetch {
                ProgressHUD.present(animated: true)
                self.requestToFetchStoreReviews()
            }
            
        }
    }
    
}


extension StoreReviewVC: CallBackDelegate {
    func reloadData() {
        self.store?.canReviewUsers?.remove(at: 0)
        self.navigationController?.popViewController(animated: true)
      }
    
    
}



extension StoreReviewVC: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Reviews".localized)
    }
    
}
