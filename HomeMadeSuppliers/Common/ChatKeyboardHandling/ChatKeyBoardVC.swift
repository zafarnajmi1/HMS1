//
//  ChatKeyBoardVC.swift
//  ChatVCKeyboard
//
//  Created by apple on 10/3/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class ChatKeyBoardVC: UIViewController {
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var inputToolbar: UIView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {

        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

          // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        
    }
            
       
        deinit { NotificationCenter.default.removeObserver(self) }

           @objc func tapGestureHandler() {
               view.endEditing(true)
           }
    

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }

}
    
extension ChatKeyBoardVC: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}

