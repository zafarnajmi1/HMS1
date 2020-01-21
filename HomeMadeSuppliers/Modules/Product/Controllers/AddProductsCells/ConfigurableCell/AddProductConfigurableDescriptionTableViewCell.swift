//
//  AddProductConfigurableDescriptionTableViewCell.swift
//  HomeMadeSuppliers
//
//  Created by apple on 11/5/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit


protocol AddProductConfigurableDescriptionTableViewCellDelegate: class {
    func didEnter(detailEn: String?)
    func didEnter(detailAr: String?)
}



class AddProductConfigurableDescriptionTableViewCell: UITableViewCell {
    @IBOutlet var detailTextViewEnLabel: UILabel!
    @IBOutlet var detailTextViewEnView: UIView!
    @IBOutlet var detailTextViewEn: UITextView!
    @IBOutlet var detailTextViewEnPlaceHolder: UILabel!
    @IBOutlet var detailTextViewARLabel: UILabel!
    @IBOutlet var detailTextViewARView: UIView!
    @IBOutlet var detailTextViewAR: UITextView!
    @IBOutlet var detailTextViewARPlaceHolder: UILabel!
    
    @IBOutlet var sendBtn: UIButton!
    
    
    var delegate: AddProductConfigurableDescriptionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLocalization()
        self.detailTextViewEn.delegate = self
        self.detailTextViewAR.delegate = self
    }

    func loadCell(model: ConfigProductParameters,
                  delegarte: AddProductConfigurableDescriptionTableViewCellDelegate?,
                  isEditProduct: Bool = false, localeType: LocaleType = .en) {
        self.delegate = delegarte
       //en
        self.detailTextViewEn.text = model.descriptionEn
        self.detailTextViewEnPlaceHolder.isHidden =  self.detailTextViewEn.text.count > 0 ? true:false
        
        //ar
        self.detailTextViewAR.text = model.descriptionAr
        self.detailTextViewARPlaceHolder.isHidden =  self.detailTextViewEn.text.count > 0 ? true:false
       // self.detailTextViewARView.isHidden = isEditProduct == true ? false:true
        
        if localeType == .en && isEditProduct ==  true {
            self.detailTextViewEnView.isHidden = false
            self.detailTextViewARView.isHidden = true
        }
        else if localeType == .ar && isEditProduct == true {
            self.detailTextViewARView.isHidden = false
            self.detailTextViewEnView.isHidden = true
        }
        else {
            self.detailTextViewEnView.isHidden = false
            self.detailTextViewARView.isHidden = true
        }
        
    }
    
}

 //MARK:-  localization
private extension AddProductConfigurableDescriptionTableViewCell {
    private func setLocalization() {
        self.detailTextViewEnLabel.text = "Description (English)".localized
        self.detailTextViewARLabel.text = "Description (Arabic)".localized
        self.detailTextViewARPlaceHolder.text = "Write Description...".localized
        self.detailTextViewEnPlaceHolder.text = "Write Description...".localized
        
        AppLanguage.updateTextViewsDirection([
            self.detailTextViewEn, self.detailTextViewAR
        ])
        
    }
}


extension AddProductConfigurableDescriptionTableViewCell: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == detailTextViewEn {
             detailTextViewEnPlaceHolder.isHidden = true
        }
        else if textView == detailTextViewAR {
           detailTextViewARPlaceHolder.isHidden = true
        }
        
       
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == detailTextViewEn {
            if detailTextViewEn.text.count == 0 {
                detailTextViewEnPlaceHolder.isHidden = false
            }
            self.delegate?.didEnter(detailEn: textView.text!)
        }
        else if textView == detailTextViewAR {
            if detailTextViewAR.text.count == 0 {
                detailTextViewARPlaceHolder.isHidden = false
            }
            self.delegate?.didEnter(detailAr: textView.text!)
        }
        
        
       
    }
}
