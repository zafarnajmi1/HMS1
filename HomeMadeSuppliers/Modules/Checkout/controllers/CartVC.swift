//
//  CartVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/21/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import ObjectMapper

class CartVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalBillLabel: UILabel!
    @IBOutlet weak var totalBill: UILabel!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    
    var cartList = [Cart]()
    var billAmount: PricesObject?
    var comeFromProductDetail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Cart".localized
        self.setupView()
        
      
    }
    
    override func toggleMenu() {
          AppSettings.shared.showMenu(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      switch myDefaultAccount {
        case .buyer:
            self.socketEventsListen()
            self.showNvLoader()
            self.requestToFetchCartList()
        default:
            self.tableView.setEmptyView(message: "please Login From buyer Account".localized)
        }
        
        setLocalization()
    }
    
    func setupView() {
        
        if comeFromProductDetail == true {
            addBackBarButton()
            tabBarController?.tabBar.isHidden = true
        }
        else {
            tabBarController?.tabBar.isHidden = false
            addMenuBarBtn()
        }
        
        tableView.registerCell(id: CartTableViewCell.id)
        tableView.estimatedRowHeight = 200
        tableView.pullToRefresh {
            self.requestToFetchCartList()
        }
    }

    @IBAction func checkoutBtnTapped(_ sender: UIButton ) {
        
        let s = AppConstant.storyBoard.checkout
        let vc = s.instantiateViewController(withIdentifier: CheckOutVC.id) as! CheckOutVC
        vc.cartList = cartList
        vc.totalBilAmount = billAmount?.total
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CartVC {
    
    func setLocalization() {
        totalBillLabel.text = "Total Bill".localized
        checkoutBtn.setTitle("Continue To Checkout".localized, for: .normal)
    }
}


 //MARK:- Network
extension CartVC {
    
    func requestToFetchCartList(){
      
        CartManager.shared.fetchCartList { (result) in
            self.hideNvloader()
            self.tableView.stopLoader()
            switch result {
            case .sucess(let root):
                self.reloadTableView(root: root)
            case .failure(let error):
                nvMessage.showError(body: error)
            }
            
        }
    }
    
    func reloadTableView(root: CartAPIResponse)  {
        self.cartList = root.data?.cart ?? []
        let count = self.getTotalQty(cartItmes: self.cartList)
        self.tabBarController?.increaseBadge(indexOfTab: 3, num: count)
        self.tableView.backgroundView = nil
        self.tableView.reloadData()
        reloadBottomView(root: root)
       
       
        
        if cartList.count == 0 {
            tableView.setEmptyView(message: "No items in the cart".localized)
            bottomView.isHidden = true
        }
        else {
            bottomView.isHidden = false
            tableView.backgroundView = nil
        }
      
    }
    
    func reloadBottomView(root: CartAPIResponse)  {
        self.billAmount = root.data?.pricesObject
        self.totalBill.text = setDefualtCurrency(price: billAmount?.total)
    }
    
    
    func  requestToGetProfile()  {
      //  showNvLoader()
        ProfileManager.shared.getProfile { (result) in
           // self.hideNvloader()
            
            switch result {
            case .sucess(let root):
                 AppSettings.shared.setUser(model: root.user!)
                 let isCartProcessing = root.user?.isCartProcessing ?? false
                 if isCartProcessing == true {
                    let msg = "Your cart is in processing. Please wait.".localized
                    self.checkoutBtn.setTitle(msg, for: .normal)
                    self.checkoutBtn.isEnabled = false
                    self.checkoutBtn.setTitleColor(#colorLiteral(red: 0.04705882353, green: 0.3294117647, blue: 0.3764705882, alpha: 1), for: .normal)
                    self.checkoutBtn.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.9254901961, blue: 0.9450980392, alpha: 1)
                 }
                 else {
                    let msg = "Continue To Checkout".localized
                    self.checkoutBtn.setTitle(msg, for: .normal)
                    self.checkoutBtn.isEnabled = true
                    self.checkoutBtn.setTitleColor(.white, for: .normal)
                    self.checkoutBtn.backgroundColor = #colorLiteral(red: 0.92406708, green: 0.1152566597, blue: 0.1496061683, alpha: 1)
                 }
                 //self.checkoutBtn.isHidden = check == true ? true:false
               
                
            case .failure(let error):
                self.tableView.setEmptyView(message: error)
            }
        }
    }
    
    
}

 //MARK:- tableview
extension CartVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.id) as! CartTableViewCell
        let item = cartList[indexPath.row]
        cell.setData(model: item, index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    
}

extension CartVC: CallBackDelegate {
    func reloadData() {
        self.showNvLoader()
        self.requestToFetchCartList()
    }
    
    
}


extension UIViewController {
    
    func  getTotalQty(cartItmes: [Cart]?) -> String? {
        //update cart badge
        let quantities = cartItmes?.compactMap{$0.quantity}
        var sum = quantities?.reduce(0, +)
        sum = sum == 0 ? nil : sum
        return sum?.string
        
    }

    func  count(cartItmes: [Cart]?) -> Int? {
        //update cart badge
        let quantities = cartItmes?.compactMap{$0.quantity}
        var sum = quantities?.reduce(0, +)
        sum = sum == 0 ? nil : sum
        return sum
        
    }
}




 //MARK:-  socket
extension CartVC {
    
    func socketEventsListen() {
        
//        cartInProcess
//        cartNotInProcess
//        cartProductUpdated
//        cartProductDeleted
//        cartChanged
//        cartInProcess
//        cartNotInProcess
        
        
        let socket = SocketIOManager.sharedInstance.getSocket()
        socket.on("cartInProcess") { (data, ack) in
            //get userProfile
            self.requestToGetProfile()
        }
        socket.on("cartNotInProcess") { (data, ack) in
            //get userProfile
            self.requestToGetProfile()
        }
        
        socket.on("cartChanged") { (data, ack) in
            //get cartlist
           // self.showNvLoader()
            self.requestToFetchCartList()
        }
        
        
        socket.on("cartProductDeleted") { (data, ack) in
            self.alertMessage(message: "Product is deleted from your cart because it is deleted by store.".localized, btnTitle: "OK".localized, completion: {
                self.requestToFetchCartList()
            })
           
        }
        
        socket.on("cartProductUpdated") { (data, ack) in
          
            let modified = data[0] as AnyObject
            guard let dict = modified as? [String: AnyObject] else { return }
            guard let obj =  Mapper<CartAPIResponse>().map(JSONObject: dict) else { return }
            if obj.success == false { return }
            
            let msg = "Product is deleted from your cart because it is updated by store, please add this product again".localized
            
            self.presentAlert( message: msg, view: {
                self.moveToProductDetailVC(id: obj.data?.product)
            }, cancel: nil)
           
            
        }
    }
    
    func moveToProductDetailVC(id: String?)  {
        guard let productId = id else {
            nvMessage.showError(body: "Product Id not found".localized)
            return
        }
        
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: ProductDetailVC.id) as! ProductDetailVC
        vc.productId = productId
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
    
    
    
    

