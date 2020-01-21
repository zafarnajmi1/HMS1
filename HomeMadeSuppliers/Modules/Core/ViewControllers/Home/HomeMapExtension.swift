//
//  HomeMapExtension.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/25/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import GoogleMaps

//MARK:-  Map implemenation
extension HomeVC {
    
    func loadPinsOnMap(){
        mapView.clear()
        for (index,store) in stores.enumerated(){
            
            guard let location =  store.location else { return }
            let long = location.first ?? 0
            let latt = location.last ?? 0
            let position = CLLocationCoordinate2D(latitude: latt, longitude: long)
            let pin = GMSMarker(position: position)
            //            london.title = "London"
            
            let image = "PinLocationRed2"
            
            let view = UIImageView(image: UIImage(named: (index == 0 ?image: image)))
            view.frame.size = CGSize(width: 40, height: 40)
            view.tag = index
            pin.iconView = view
            
            pin.map = mapView
            store.marker = pin
        }
        if !stores.isEmpty{
            zoomMapAtLocation(object: stores[0])
        }
        
    }
    
    
    func zoomMapAtLocation(object : Store){
        guard let location = object.location else{ return }
        
        let long = location.first ?? 0
        let lat = location.last ?? 0
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        delay(bySeconds: 0.5) {
            
            CATransaction.begin()
            CATransaction.setValue(0.5, forKey: kCATransactionAnimationDuration)
            let zoomOut = GMSCameraUpdate.zoom(to: 10)
            self.mapView.animate(with: zoomOut)
            let update = GMSCameraUpdate.setTarget(coordinate, zoom: 13)
            self.mapView.animate(with: update)
            CATransaction.commit()
            
        }
        
    }
    
    func zoomMapAtLocation(){
        mapView.clear()
        
        guard let location = mySelectedLocation else{ return }
        
        let pin = GMSMarker(position: location)
        //london.title = "London"
        
        let image = "PinLocationRed2"
        
        let view = UIImageView(image: UIImage(named: image))
        view.frame.size = CGSize(width: 40, height: 40)
        view.tag = 100
        pin.iconView = view
        
        pin.map = mapView
        
        
        let coordinate = location
        
        delay(bySeconds: 0.5) {
            
            CATransaction.begin()
            CATransaction.setValue(0.5, forKey: kCATransactionAnimationDuration)
            let zoomOut = GMSCameraUpdate.zoom(to: 10)
            self.mapView.animate(with: zoomOut)
            let update = GMSCameraUpdate.setTarget(coordinate, zoom: 13)
            self.mapView.animate(with: update)
            CATransaction.commit()
            
        }
        
    }
}


