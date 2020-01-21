//
//  CategoryVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 7/2/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

class CategoryVC: UIViewController {
    
    
    @IBOutlet weak var tableView : UITableView!
    var catList : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Categories".localized
        showNavigationBar()
        setupView()
        // Do any additional setup after loading the view.
    }
    
//    override func backToMain() {
//        self.dismiss(animated: true, completion: nil)
//    }
    func setupView() {
       
       
        addBackBarButton()
      
        tableView.registerHeaderFooterCell(id: CategoryHeader.id)
        tableView.registerCell(id: SubcategoryCell.id)
        
        fetchCategories()
        
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: - Network
    func fetchCategories()  {
        self.catList = AppSettings.shared.settingData?.categories ?? []
    }
    
}
extension CategoryVC : UITableViewDataSource, UITableViewDelegate, CategoryHeaderDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoryHeader.id) as? CategoryHeader{
            
            let category = catList[section]
            
            headerView.loadHeaderView(object: category, section: section)
            if category.isSelected ?? false {
                
                headerView.img_upDown.image = UIImage(named: "UpRed")
            }
            else{
                headerView.img_upDown.image = UIImage(named: "DownRed")
            }
            headerView.delegate = self
            return headerView
        }
        else{
            return UIView()
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return catList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let category = catList[section]
        if category.isSelected ?? false {
            return category.children?.count ?? 0
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubcategoryCell.id) as? SubcategoryCell  else { return UITableViewCell() }
        let category = catList[indexPath.section]
        if let subCat = category.children?[indexPath.row] {
            cell.loadCell(object: subCat)
            
            if  (category.children?.count)! - 1 == indexPath.row {
                cell.setBottomShadow(value: true)
            }
            else{
                cell.setBottomShadow(value: false)
            }
            
            
        }
        
        
        
        return cell
    }
    func toggleSection(header: CategoryHeader, section: Int) {
        let category = catList[section]
        if category.isSelected ?? false {
            category.isSelected = false
            header.img_upDown.image = UIImage(named: "dropdown")
        }
        else{
            category.isSelected = true
            header.img_upDown.image = UIImage(named: "dropdown_up")
        }
        
        tableView.beginUpdates()
        tableView.reloadSections([section], with: .fade)
        tableView.endUpdates()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: SearchProductVC.id ) as! SearchProductVC
        
        let category = catList[indexPath.section]
        
        vc.selectedCategory = category
        vc.selectedSubcategory = category.children?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
