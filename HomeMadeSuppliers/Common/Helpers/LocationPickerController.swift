//
//  LocationPickerController.swift
//  TailerOnline
//
//  Created by apple on 12/10/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import LocationPicker
import CoreLocation




class LocationPickerController {
    private var viewController: UIViewController?
   
    typealias  completionHandler = ((_ coordiante: CLLocationCoordinate2D?, _ address: String? ) -> ())
    
    fileprivate func backbutton () -> UIBarButtonItem {
        
        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        let imageName = myDefaultLanguage == .ar ? "BackArrowAr": "BackArrow"
        imageView.image = UIImage(named: imageName)
        
        view.addSubview(imageView)
        
        view.addTapGesture { (UITapGestureRecognizer) in
            self.viewController?.dismiss(animated: true, completion: nil)
        }

        return  UIBarButtonItem(customView: view )
    
    }
    
   
   
    
}

extension LocationPickerController {
    
    func open(completion: completionHandler?)  {
        
        guard let rootController =  UIApplication.shared.keyWindow?.rootViewController else {
            return print("Root Controller not found")
        }
        
        self.viewController = rootController
         AppLanguage.updateNavigationBarSementic(vc: rootController)
        
        let locationPicker = LocationPickerViewController()
        
        // locationPicker.location = selectedLocation
        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true
        locationPicker.showNavigationBar()
    
        // default: navigation bar's `barTintColor` or `UIColor.white`
        locationPicker.currentLocationButtonBackground = .gray
        
        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true
        
        locationPicker.mapType = .standard // default: .Hybrid
        
        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false
        
        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"
        
        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"
        
        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600
        
        locationPicker.completion = { location in
            // self.parentVC?.navigationController?.popViewController(animated: true)
            if let location = location {
                completion?(location.coordinate, location.address)
            }
            
            print(location?.address ?? "")
            print(location?.coordinate ?? 0)
        }
        
        
        locationPicker.navigationItem.title = "Select Location".localized
        
        locationPicker.navigationItem.leftBarButtonItem =  backbutton()
        
        
        let navigationController = UINavigationController(rootViewController: locationPicker)
        navigationController.modalPresentationStyle = .fullScreen
        
        let theme = ThemeManager.currentTheme()
        
        navigationController.navigationBar.barStyle = theme.barStyle
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController.navigationBar.barTintColor = theme.navigationBarBgColor
        navigationController.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: robotoBold18 , NSAttributedString.Key.foregroundColor: UIColor.white]
        rootController.present(navigationController, animated: true, completion: nil)
     
        
    }
    
    
    

    
}

