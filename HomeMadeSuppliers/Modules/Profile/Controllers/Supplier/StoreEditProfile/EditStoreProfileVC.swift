//
//  StoreEditProfileVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/27/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class EditStoreProfileVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
     //MARK:-  variables
    var callback: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile".localized
        addBackBarButton()
        
        tableView.registerCell(id: EditStoreProfileFormTableViewCell.id)
        tableView.registerCell(id: EditStoreProfileSaveButtonTableViewCell.id)
        tableView.registerCell(id: EmptyTableViewCell.id)

    }
    

    
    
    func validateFormCell()  {
        let index = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: index) as! EditStoreProfileFormTableViewCell
        
        let index2 = IndexPath(row: 2, section: 0)
        let cell2 = tableView.cellForRow(at: index2) as! EditStoreProfileSaveButtonTableViewCell
        
        if cell.formIsvalid() == true &&  cell2.formIsvalid() == true {
            requestToUpdateProfile()
        }
       
    }

    func requestToUpdateProfile() {
        
        let index = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: index) as! EditStoreProfileFormTableViewCell
        
        let index2 = IndexPath(row: 2, section: 0)
        let cell2 = tableView.cellForRow(at: index2) as! EditStoreProfileSaveButtonTableViewCell
       
        var params = ["locale": myDefaultLanguage.rawValue ] as [String: Any]
        
        params.updateValue(cell.myEmail ?? "", forKey: "email")
        params.updateValue(cell.phone.text!, forKey: "phone")
        params.updateValue(cell.address.text!, forKey: "address")
        let domesticPrice = cell.domesticShipping.text?.numaric ?? ""
        params.updateValue(domesticPrice, forKey: "domesticShipping")
        let internationalPrice = cell.internationalShipping.text?.numaric ?? ""
        params.updateValue(internationalPrice, forKey: "internationalShipping")
        
        switch myDefaultLanguage {
        case .ar:
            params.updateValue(cell2.detailTv.text!, forKey: "descriptionAr") //FixMe
            params.updateValue(cell.storeName.text!, forKey: "storeNameAr")
        default:
            params.updateValue(cell2.detailTv.text! , forKey: "descriptionEn") //FixMe
            params.updateValue(cell.storeName.text!, forKey: "storeNameEn")
           
        }
       
        if let path = cell.imagePath {
            params.updateValue(path, forKey: "image")
        }
        
        if let location = cell.myNewLocation {
            params.updateValue(location.latitude, forKey: "latitude")
            params.updateValue(location.longitude, forKey: "longitude")
        }
        else {
            params.updateValue(cell.myLocation.lat, forKey: "latitude")
            params.updateValue(cell.myLocation.long, forKey: "longitude")
        }
        
        self.showNvLoader()
        ProfileManager.shared.editProfile(params: params) { (result) in
        self.hideNvloader()
            switch result {
            case .sucess(let rootModel):
                
                self.saveUser(model: rootModel.user!)
                
                nvMessage.showSuccess(body: rootModel.message!, closure: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            case .failure(let error):
                nvMessage.showError(body: error)
            }
        }
        
    }
    
    
  
    func saveUser(model: User)  {
        AppSettings.shared.setUser(model: model)
        callback?()
    }
    
}


extension EditStoreProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let user = AppSettings.shared.user!
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditStoreProfileFormTableViewCell" ) as! EditStoreProfileFormTableViewCell
           
            cell.setData(model: user)
            
            cell.selectCityBtn.onTap {
                 let s = AppConstant.storyBoard.profile
                 let vc = s.instantiateViewController(withIdentifier: SelectCityVC.id) as! SelectCityVC
                vc.callBack = {
                    self.tableView.reloadData()
                    let indexpath = IndexPath(row: 2, section: 0)
                    self.tableView.scrollToRow(at: indexpath, at: .middle, animated: true)
                    
                }
                 self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            return cell
        case 1:
            
            let model = user.deliverableCities!
            
            if model.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
                
                cell.setData(model: model, isRemovableCell: true)
                cell.vcRefrence = self
                cell.callBack = {
                    self.tableView.reloadData()
                }
                return cell
            }
            else {
                 let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.id, for: indexPath) as! EmptyTableViewCell
                cell.label.text = "Cities record not found"
                return cell
            }
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditStoreProfileSaveButtonTableViewCell.id, for: indexPath) as! EditStoreProfileSaveButtonTableViewCell
            cell.setData(model: user)
            cell.saveBtn.onTap {
                self.view.endEditing(true)
                self.validateFormCell()
            }
            return cell
        default:
          return UITableViewCell()
            
        }
        
    }
  
}
