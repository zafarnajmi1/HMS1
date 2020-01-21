//
//  RatingReviewVC.swift
//  TailerOnline
//
//  Created by apple on 3/12/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import Cosmos
class RatingReviewVC: UIViewController {

  
    //MARK:- outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stars: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var totalReviews: UILabel!
    @IBOutlet weak var storeReviewsLabel: UILabel!
    //MARK:- variables
    private var reviews: [Review]?
    private var reviewPagination: Pagination?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register
        self.title = "Rating & Reviews".localized
        self.showNavigationBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNvLoader()
        self.requestToFetchStoreReviews()
        
    }
    
//    override func backToMain() {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    func setupView()  {
        self.addBackBarButton()
        tableView.registerCell(id: RatingReviewTableViewCell.id)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.estimatedRowHeight = 200
        
        let user = AppSettings.shared.user
        let rating = user?.averageRating ?? 0
        self.stars.rating = rating
        self.ratingNumber.text = "\(rating)"
        let postfix = "total Reivews".localized
        self.totalReviews.text = "(\(0) \(postfix))"
        self.storeReviewsLabel.text = "Store Reviews".localized
    }
    
    
    
}

//MARK:-  setup API with Pagination
extension RatingReviewVC {
    
    func requestToFetchStoreReviews(){
        
        guard let productId = AppSettings.shared.user?.id else {
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
        
        if reviewPagination?.page ?? 0 == 1 {
            self.reviews = response?.reviews ?? []
            self.tableView.reloadData()
        }
        else {
            self.reviews?.append(contentsOf: response?.reviews ?? [])
            self.tableView.reloadData()
        }
        
        let postfix = "total Reivews".localized
        self.totalReviews.text = "(\(reviews?.count ?? 0) \(postfix))"
    }
    
    
    
}

extension RatingReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return reviews?.count ?? 0
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
            let cell = tableView.dequeueReusableCell(withIdentifier: RatingReviewTableViewCell.id) as! RatingReviewTableViewCell
            let model = reviews?[indexPath.row]
            cell.setData(model: model!)
            return cell
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height - 10 {
            let canFetch = MyPagination.shared.checkFetchMore(model: reviewPagination)
            if canFetch {
                ProgressHUD.present(animated: true)
                self.requestToFetchStoreReviews()
            }
            
        }
    }
    
}
