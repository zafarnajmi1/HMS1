//
//  nvMessage.swift
//  Baqala
//
//  Created by apple on 12/4/18.
//  Copyright © 2018 My Technology. All rights reserved.

import UIKit
import SwiftMessages

fileprivate enum defaultTitle {
    static let error = "Heads-up!".localized
    static let success = "Success!".localized
}



class nvMessage {
    //my custom messages
    //HeadesUp.an advance warning of something
    
    class func showError(title: String = defaultTitle.error, body: String  ) -> Void {
        print(body)
        
        let view: MessageView
        view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.error)
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        view.configureContent(title: title, body: body)
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: .statusBar)
        
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: 2)
        // Dim the background like a popover view. Hide when the background is tapped.
       // config.dimMode = .gray(interactive: true)
        // Disable the interactive pan-to-hide gesture.
        // config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed
        //directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        //        config.eventListeners.append() { event in
        //            if case .didHide = event { print("yep") }
        //        }
        
        SwiftMessages.show(config: config, view: view)
    }
    
    class func showWarning(title: String = defaultTitle.error, body: String  ) -> Void {
        print(body)
        
        let view: MessageView
        view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.warning)
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        view.configureContent(title: title, body: body)
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: .statusBar)
        
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: 2)
        // Dim the background like a popover view. Hide when the background is tapped.
        // config.dimMode = .gray(interactive: true)
        // Disable the interactive pan-to-hide gesture.
        // config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed
        //directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        //        config.eventListeners.append() { event in
        //            if case .didHide = event { print("yep") }
        //        }
        
        SwiftMessages.show(config: config, view: view)
    }
    
    class func showInfo(title: String = defaultTitle.error, body: String  ) -> Void {
        print(body)
        
        let view: MessageView
        view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.info)
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        view.configureContent(title: title, body: body)
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: .statusBar)
        
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: 2)
        // Dim the background like a popover view. Hide when the background is tapped.
        // config.dimMode = .gray(interactive: true)
        // Disable the interactive pan-to-hide gesture.
        // config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed
        //directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        //        config.eventListeners.append() { event in
        //            if case .didHide = event { print("yep") }
        //        }
        
        SwiftMessages.show(config: config, view: view)
    }
    
    
    
    class func showSuccess(title: String = defaultTitle.success, body: String ) -> Void {
        print(body)
        
        let view: MessageView
        view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.success)
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        view.configureContent(title: title, body: body)
        config.presentationStyle = .center
        config.presentationContext = .window(windowLevel: .statusBar)
        config.dimMode = .gray(interactive: true)
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: 3)
        // Dim the background like a popover view. Hide when the background is tapped.
       // config.dimMode = .gray(interactive: true)
        // Disable the interactive pan-to-hide gesture.
        // config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed
        //directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        config.eventListeners.append() { event in
            if case .didHide = event { print("NvMessage") }
        }
        
        SwiftMessages.show(config: config, view: view)
    }
    
    
    class func showSuccess(title: String = defaultTitle.success, body: String, closure: @escaping () -> Void){
        print(body)
        
        let view: MessageView
        view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.success)
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        view.configureContent(title: title, body: body)
        config.presentationStyle = .center
        config.presentationContext = .window(windowLevel: .statusBar)
        config.dimMode = .gray(interactive: true)
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: 3)
        // Dim the background like a popover view. Hide when the background is tapped.
        // config.dimMode = .gray(interactive: true)
        // Disable the interactive pan-to-hide gesture.
        // config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed
        //directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        config.eventListeners.append() { event in
            if case .didHide = event { closure() }
        }
        
        SwiftMessages.show(config: config, view: view)
    }
    
    class func showStatusError(title: String = defaultTitle.error, body: String, isStatusLine: Bool = false ) -> Void {
        print(body)
        
   
        let view: MessageView
        if isStatusLine == true {
            view = MessageView.viewFromNib(layout: .statusLine)
        }
        else {
            view = MessageView.viewFromNib(layout: .messageView)
        }
        view.configureTheme(.error)
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        view.configureContent(title: title, body: body)
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: 2)
        // Dim the background like a popover view. Hide when the background is tapped.
        // config.dimMode = .gray(interactive: true)
        // Disable the interactive pan-to-hide gesture.
        // config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed
        //directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        //        config.eventListeners.append() { event in
        //            if case .didHide = event { print("yep") }
        //        }
        
        SwiftMessages.show(config: config, view: view)
    }
    
    class func showStatusWarning(title: String = defaultTitle.error, body: String, isStatusLine: Bool = false ) -> Void {
        print(body)
        
        let view: MessageView
        if isStatusLine == true {
              view = MessageView.viewFromNib(layout: .statusLine)
        }
        else {
             view = MessageView.viewFromNib(layout: .messageView)
        }
       
        view.configureTheme(.warning)
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        view.configureContent(title: title, body: body)
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .normal)
        
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: 2)
        // Dim the background like a popover view. Hide when the background is tapped.
        // config.dimMode = .gray(interactive: true)
        // Disable the interactive pan-to-hide gesture.
        // config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed
        //directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        //        config.eventListeners.append() { event in
        //            if case .didHide = event { print("yep") }
        //        }
        
        SwiftMessages.show(config: config, view: view)
    }
    
    class func showStatusSuccess(title: String = defaultTitle.success, body: String ) -> Void {
        print(body)
        
        let view: MessageView
        view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.success)
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        view.configureContent(title: title, body: body)
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: 3)
        // Dim the background like a popover view. Hide when the background is tapped.
        // config.dimMode = .gray(interactive: true)
        // Disable the interactive pan-to-hide gesture.
        // config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed
        //directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        config.eventListeners.append() { event in
            if case .didHide = event { print("yep") }
        }
        
        SwiftMessages.show(config: config, view: view)
    }
    
    
}
