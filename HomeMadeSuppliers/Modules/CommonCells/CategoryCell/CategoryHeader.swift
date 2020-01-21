//
//  CategoryHeader.swift
//  HomeMade2
//
//  Created by Apple on 13/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
protocol CategoryHeaderDelegate: class {
    func toggleSection(header: CategoryHeader, section: Int)
}
class CategoryHeader: UITableViewHeaderFooterView {

    
    @IBOutlet weak var lbl_name : UILabel!
    @IBOutlet weak var img_bg : UIImageView!
    @IBOutlet weak var img_upDown : UIImageView!
    
    @IBOutlet weak var supplierBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    
    var section: Int = 0
    private var myCategory: Category?
    
    weak var delegate: CategoryHeaderDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }

    func loadHeaderView(object : Category, section : Int){
        self.myCategory = object
        self.section = section
        lbl_name.text = object.title
        let url =  object.image?.resizeImage(width: 100, height: 100)
        img_bg.setPath(image: url, placeHolder: AppConstant.placeHolders.product)

    }
    
    @objc private func didTapHeader() {
        
        delegate?.toggleSection(header: self, section: section)
    }

    @IBAction func supplierBtnTapped(_ sender: UIButton) {
        
        let s = AppConstant.storyBoard.main
        let vc = s.instantiateViewController(withIdentifier: StoreListVC.id) as! StoreListVC
        vc.hidesBottomBarWhenPushed = true
        vc.isComeFromCategory = true
        vc.selectedCategory = myCategory
        self.parentVC?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func allBtnTapped(_ sender: UIButton) {
        
        let s = AppConstant.storyBoard.product
        let vc = s.instantiateViewController(withIdentifier: SearchProductVC.id) as! SearchProductVC
        vc.selectedCategory = myCategory
        self.parentVC?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension CategoryHeader {
    private func setLocalization() {
        self.supplierBtn.setTitle("Traders".localized, for: .normal)
        self.allBtn.setTitle("All".localized, for: .normal)
    }
}
