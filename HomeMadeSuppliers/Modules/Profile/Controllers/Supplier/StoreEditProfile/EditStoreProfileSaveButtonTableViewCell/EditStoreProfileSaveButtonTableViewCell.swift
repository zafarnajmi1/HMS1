//
//  StoreEditProfileFooterTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/27/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class EditStoreProfileSaveButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailPlaceHolder: UILabel!
    @IBOutlet weak var detailTv: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
        self.detailPlaceHolder.isHidden = true
        self.detailTv.delegate = self
    }
    
    
    private func setLocalization() {
        self.detailPlaceHolder.text = "Write something about your store".localized
        self.detailLabel.text = "Detail".localized
        self.saveBtn.setTitle("Save".localized, for: .normal)
        AppLanguage.updateTextViewsDirection([detailTv])
        
    }
    
    

    func setData(model: User)  {
        self.detailTv.text = model.descriptionField ?? ""
        if self.detailTv.text.count == 0 {
            self.detailPlaceHolder.isHidden = false
        }
    }

    func  formIsvalid() -> Bool {
        
        let title = "Edit Profile".localized
        
        
        if detailTv.text.count == 0 {
            let msg = "please write something about your store".localized
            nvMessage.showError(title: title, body: msg)
            return false
        }
        
        return true
    }
    
}

extension EditStoreProfileSaveButtonTableViewCell: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        detailPlaceHolder.isHidden = true
        return true
    }
    
}
