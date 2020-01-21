//
//  TableViewExtension.swift
//  Delivigo
//
//  Created by Muhammad Naveed on 10/2/18.
//  Copyright © 2018 Muhammad Naveed. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCell( id: String) {
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forCellReuseIdentifier: id)
    }
    func registerHeaderFooterCell( id: String) {
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: id)
    }
    
    

}

extension UITableView {
    
    func reloadWithoutAnimation() {
        self.reloadData()
        let lastScrollOffset = contentOffset
        beginUpdates()
        endUpdates()
        layer.removeAllAnimations()
        setContentOffset(lastScrollOffset, animated: false)
    }
    
    func reloadSection(section: Int) {

        self.beginUpdates()
        self.reloadSections([section], with: .none)
        self.endUpdates()
        
    }
    
    
}

extension UICollectionView {
    func registerCell( id: String) {
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: id)
    }
    
    func registerCustomHeader(id: String)  {
        self.register(UINib(nibName: id, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: id)
        
    }
    func registerCustomFooter(id: String)  {
        self.register(UINib(nibName: id, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier:id)
    }
}




extension UITableView {
    
    func setEmptyView(title: String = "Heads-up!".localized , message: String = "No record found".localized, imageName: String = "Logo") {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -100).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 8).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor).isActive = true

        messageLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor).isActive = true
        
        messageImageView.image = UIImage(named: imageName)
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 5
        messageLabel.textAlignment = .center
        
//        UIView.animate(withDuration: 1, animations: {
//
//            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
//        }, completion: { (finish) in
//            UIView.animate(withDuration: 1, animations: {
//                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
//            }, completion: { (finishh) in
//                UIView.animate(withDuration: 1, animations: {
//                    messageImageView.transform = CGAffineTransform.identity
//                })
//            })
//
//        })
        messageImageView.topOffsetAnimate()
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        
        self.backgroundView = nil
        self.separatorStyle = .none
        
    }
    
}

extension UICollectionView {
    
    func setEmptyView(title: String = "Heads-up!".localized , message: String = "No record found".localized, imageName: String = "Logo") {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -100
        ).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.image = UIImage(named: imageName)
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 4
        messageLabel.textAlignment = .center
        
//        UIView.animate(withDuration: 1, animations: {
//
//            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
//        }, completion: { (finish) in
//            UIView.animate(withDuration: 1, animations: {
//                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
//            }, completion: { (finishh) in
//                UIView.animate(withDuration: 1, animations: {
//                    messageImageView.transform = CGAffineTransform.identity
//                })
//            })
//
//        })
        messageImageView.topOffsetAnimate()
        self.backgroundView = emptyView
       
    }
    
    func restore() {
        
        self.backgroundView = nil
    
    }
    
}
