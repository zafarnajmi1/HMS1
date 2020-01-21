//
//  SelectCityVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/28/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class SelectCityVC: UIViewController {
    @IBOutlet weak var selectPriceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    var cityList: [City]?
    var callBack: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Cities".localized
        self.addBackBarButton()
        setLocalization()
        //register
        tableView.registerCell(id: SelectCityTableViewCell.id)
        tableView.registerCell(id: ButtonTableViewCell.id)
        
        //update
        cityList = AppSettings.shared.settingData?.cities
    }
    
    
    private func setLocalization () {
        self.selectPriceLabel.text = "Enter Price".localized
        self.cityLabel.text = "City".localized
    }
    
    func getCheckedList() {
        
        var formIsValid = true
        var list = [[String: Any]]()
        
        for (index, city ) in (cityList?.enumerated())! {
            let index = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: index) as! SelectCityTableViewCell
            
            //validate form
            if cell.checkBtn.isSelected == true && cell.price.text?.count == 0 {
                formIsValid = false
             }
            //Append list
            if cell.checkBtn.isSelected == true && cell.price.text?.count ?? 0 > 0 {
                let price = cell.price.text!.numaric
                list.append(["city" : city.id!, "price": price ])
            }
        } // end loop
        
        //Call API
        if formIsValid {
            let params = [ "deliverables": list] as [String: Any]
            requestToSaveCities(params: params)
        }
        else {
            let error = "Please add amount of all the selected fields".localized
            nvMessage.showError(body: error )
         }
       
    }

    
    func requestToSaveCities(params: [String: Any]) {
        self.showNvLoader()
       
        ProfileManager.shared.updateStoreDeveliverables(params: params) { (result) in
            self.hideNvloader()
           
            switch result {
            case let .sucess(root):
                AppSettings.shared.setUser(model: root.user!)
                nvMessage.showSuccess(body: "updated successfully".localized, closure: {
                    self.callBack?()
                    self.navigationController?.popViewController(animated: true)
                })
            case let .failure(error):
                nvMessage.showError(body: error)
            }
            
        }
    }
}

extension SelectCityVC: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return cityList?.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectCityTableViewCell.id) as! SelectCityTableViewCell
            let city = cityList![indexPath.row]
            cell.setData(model: city)
            return cell
        default: //1
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.id) as! ButtonTableViewCell
            cell.btn.onTap {
                self.view.endEditing(true)
                self.getCheckedList()
            }
            return cell
        }
    
        
    }
    
    
    
}
