//
//  SharedData.swift
//  TailerOnline
//
//  Created by apple on 3/8/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation

class AppUserDefault {
   
    static let shared = AppUserDefault()
    private init(){}
    
    // Handling in app login
    var email : String? {
        set {
            UserDefaults.standard.set(newValue, forKey:"Email" )
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "Email")
        }
    }
    
    var password : String? {
        set {
            UserDefaults.standard.set(newValue, forKey:"password" )
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "password")
        }
    }
    
    var fcmToken : String? {
        set {
            UserDefaults.standard.set(newValue, forKey:"fcmToken" )
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "fcmToken")
        }
    }
    
    
    var isUserLoggedIn : Bool? {
        set {
            UserDefaults.standard.set(newValue, forKey:"isUserLoggedIn" )
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        }
    }
    
    //handling social Login
    var socialId : String? {
        set {
            UserDefaults.standard.set(newValue, forKey:"socialId" )
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "socialId")
        }
    }
    var socialToken : String? {
        set {
            UserDefaults.standard.set(newValue, forKey:"socialToken" )
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "socialToken")
        }
    }
    var authMethod : String? {
        set {
            UserDefaults.standard.set(newValue, forKey:"authMethod" )
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "authMethod")
        }
    }
    
    var isUserLoggedInBySocialAccount : Bool? {
        set {
            UserDefaults.standard.set(newValue, forKey:"isUserLoggedInBySocialAccount" )
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "isUserLoggedInBySocialAccount")
        }
    }

    
    // Main Section Titles
    var selectedSectionTitle : String? {
        
        set{
            UserDefaults.standard.set(newValue, forKey:"selectedSectionTitle" )
            UserDefaults.standard.synchronize()
        }
        get{
           return  UserDefaults.standard.string(forKey: "selectedSectionTitle")
            
        }
    }
    
    var selectedSectionId : String? {
        
        set{
            UserDefaults.standard.set(newValue, forKey:"selectedSectionId" )
            UserDefaults.standard.synchronize()
        }
        get{
            return  UserDefaults.standard.string(forKey: "selectedSectionId")
            
        }
    }
    
    var viewAllTapped : Bool? {
        
        set{
            
            UserDefaults.standard.set(newValue, forKey:"viewAllTapped" )
            UserDefaults.standard.synchronize()
        }
        get{
            return  UserDefaults.standard.bool(forKey: "viewAllTapped")
            
        }
    }
    
    
   // cart Badge
    var cartBadgeItems : Int? {
        
        set{
         
            UserDefaults.standard.set(newValue, forKey:"cartBadgeItems" )
            UserDefaults.standard.synchronize()
        }
        get{
            return  UserDefaults.standard.integer(forKey: "cartBadgeItems")
            
        }
    }
    
    var notificationCount : Int? {
        
        set{
            
            UserDefaults.standard.set(newValue, forKey:"notificationCount" )
            UserDefaults.standard.synchronize()
        }
        get{
            return  UserDefaults.standard.integer(forKey: "notificationCount")
            
        }
    }
    
    //handling Language
    var rememberdMyDefaultLanguage : String? {
        
        set{
            UserDefaults.standard.set(newValue, forKey:"rememberdMyDefaultLanguage" )
            UserDefaults.standard.synchronize()
        }
        get{
            return  UserDefaults.standard.string(forKey: "rememberdMyDefaultLanguage")
            
        }
    }
    
    
    func resetUserDefault()  {
        
        socialId = nil
        authMethod = nil
        isUserLoggedInBySocialAccount =  false
        
        isUserLoggedIn = false
        email = nil
        password = nil
        cartBadgeItems = nil
        fcmToken = nil
      
    }
}
