//
//  StoreListVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/29/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import PullToRefreshKit
import Alamofire

class StoreListVC: BadgeCountVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: LoaderButton!
    
    
    var storeList: [Store]?
    var storePagination: Pagination?
    var isComeFromCategory = false
    var selectedCategory: Category?
    
    var isSearchButtonTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Store List".localized
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupView()
        setLocalization()
    }
    
    
    
    func setupView()  {
        
        if isComeFromCategory == true {
            addBackBarButton()
        }
        else {
            addMenuBarBtn()
        }
        
      
        //register cell
        tableView.registerCell(id: StoreTableViewCell.id)
        //Pull to refresh
        tableView.pullToRefresh {
            self.view.endEditing(true)
            self.storePagination = nil
            self.searchButton.isHidden = false
            self.requestToFetchStores()
        }
        //API Call
        showNvLoader()
        requestToFetchStores()
    }
    
    override func toggleMenu() {
          AppSettings.shared.showMenu(self)
    }
    
    
    @IBAction func searchBtnTapped ( sender: UIButton ) {
        self.view.endEditing(true)
    
        self.isSearchButtonTapped = true
        searchButton.indicatorLoadingColor = UIColor.red
        searchButton.backgroundLoadingColor = UIColor.clear
        searchButton.showLoading()
        tableView.isUserInteractionEnabled = false
        self.storePagination = nil
        self.requestToFetchStores()
      
    }
    
    
    
    func requestToFetchStores()  {
       
        
        let nextPage = storePagination?.next ?? 1

        var queryItems = [URLQueryItem(name: "page", value: "\(nextPage)"),
                          URLQueryItem(name: "keyword", value: searchTextField.text)]
        if let categoryId = selectedCategory?.id {
            queryItems.append(URLQueryItem(name: "categories[0]", value:  "\(categoryId)"))
        }
      
        StoreManager.shared.fetchStoreList(queryItems: queryItems) { (result) in
            self.tableView.switchRefreshHeader(to: .normal(.none, 0))
            
            if self.isSearchButtonTapped == true {
                self.searchButton.hideLoading()
                self.tableView.isUserInteractionEnabled = true
                self.isSearchButtonTapped = false
            }
            
           
            self.hideNvloader()
            ProgressHUD.dismiss(animated: true)
            
            switch result {
            case let .sucess(response):
                self.updateList(response: response.data)
            case let .failure(error):
                self.tableView.setEmptyView( message: error)
            }
        }
    }
    
   
}

extension StoreListVC {
    private func setLocalization() {
        self.searchTextField.placeholder = "Search Keyword...".localized
        AppLanguage.updateTextFieldsDirection([searchTextField])
    }
    
}
extension StoreListVC {
    func updateList(response: StoreData? )  {
        self.tableView.backgroundView = nil
        self.storePagination = response?.pagination
        
        if self.storePagination?.page ?? 0 == 1 {
            self.storeList = response?.collection
            self.reloadTableView()
        }
        else {
            self.storeList?.append(contentsOf: response?.collection ?? [])
            self.tableView.reloadData()
        }
        
    }
    
    func reloadTableView()  {
        
        if storeList?.count ?? 0 == 0 {
            self.tableView.setEmptyView()
           
        }
        
        tableView.reloadData()
        
    }
}



extension StoreListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.id) as! StoreTableViewCell
        let store = storeList![indexPath.row]
        cell.setData(model: store)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = storeList![indexPath.row]
        
        let s = AppConstant.storyBoard.main
        let vc = s.instantiateViewController(withIdentifier: StorePagerVC.id) as! StorePagerVC
        vc.store = store
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height - 10 {
            
            let canFetch = MyPagination.shared.checkFetchMore(model: storePagination)
            if canFetch {
                ProgressHUD.present(animated: true)
                self.requestToFetchStores()
            }

        }
    }
    
}




