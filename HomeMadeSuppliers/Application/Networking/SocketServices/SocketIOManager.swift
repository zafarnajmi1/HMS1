//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SocketIO
import AVKit

class SocketIOManager: NSObject {
    
    
    static let sharedInstance = SocketIOManager()
    var socket : SocketIOClient!
    var manager : SocketManager!
    var objPlayer: AVAudioPlayer?
    let notificaitonSoundURL = Bundle.main.url(forResource: "notification", withExtension: "mp3")
    var playNotificationSound : Bool = true
    
    
   private func getConfigrations() -> SocketIOClientConfiguration! {
        if let token = AppSettings.shared.userToken{
            let locale = myDefaultLanguage.rawValue
            let usertoken = [
                "token":  token,
                "locale" : locale,
                "mtLocale": locale
            ]
            
            let specs : SocketIOClientConfiguration = [
            .forcePolling(false),
            .forceWebsockets(true),
            .compress,
            .path(AppNetwork.current.socketPath),
            .connectParams(usertoken),
            .log(true)]
        print("Socket Specs :\(specs)")
            return specs
        }
        else{
            let specs : SocketIOClientConfiguration = [
                .forcePolling(false),
                .forceWebsockets(true),
                .compress,
                .path(""),
                .log(true)]
            print("Socket Specs :\(specs)")
            return specs
        }

    }
    
    private override init() {
        super.init()
        setupSocket()
    }
    func setupAndEstablisConnection(){
        self.setupSocket()
        self.establishConnection()
    }
    
    //--
    
    func setupSocket(){
        let url = URL(string: AppNetwork.current.domain)
        manager = SocketManager(socketURL: url! , config: getConfigrations())
        socket = manager.defaultSocket
    }
    
    func getSocket() -> SocketIOClient {
        return socket
    }



     // --
    func establishConnection() {
        socket.connect()
        
        socket.on("connected") { (data, emitter) in
            print("Scoket ON connected respone :\(data)")
            self.startListeningCommonMethods()
        }
    }

    // --
    func closeConnection() {
        socket.disconnect()
    }
    
    @discardableResult
    func once(_ event: String, callback: @escaping NormalCallback) -> UUID {
        return self.socket.once(event, callback: callback)
    }
    
    @discardableResult
    func on(_ event: String, onList addIn : inout [String], callback: @escaping NormalCallback) -> UUID {
        
        
//            addIn.append(event)
        
//        onEvents.append(event)
        return self.socket.on(event, callback: callback)
        
    }
    
    @discardableResult
    func on(_ event: String, addToOff value: Bool = true, callback: @escaping NormalCallback) -> UUID {
        
//        if value {
//            onEvents.append(event)
//        }
//        else{
//            print("Event will not turned OFF :\(event)")
//        }
        
        return self.socket.on(event, callback: callback)
        
    }
    func emit(_ event: String){
        self.socket.emit(event)
    }
    func emit(_ event: String, with items: [Any]){
        self.socket.emit(event, with: items)
    }
    func emit(_ event: String, with items: [Any] , completion: (() -> ())? = nil){
        self.socket.emit(event, with: items , completion: completion)
    }
    
    func startListeningCommonMethods() {
        

        socket.on("notificationsChanged"){(data, ack)in
            self.socket.emit("unseenNotifications")
        }
      
       
        
        self.socket.on("newNotification") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            if(self.playNotificationSound){
                self.playAudioFile()
            }
            self.socket.emit("unseenNotifications")
            
        }

        self.socket.on("unseenNotifications") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print("Unseen Notification Response :\(dictionary)")
            NotificationCenter.default.post(name: .didUpdateUnseenNotification, object: dictionary)
        }
         self.socket.emit("unseenNotifications")
        
    }
    
    
    func stopListeningCommonEvents(events : [String] = []){
        for event in events {
            print("Closing Event :\(event)")
            self.socket.off(event)
        }
    }
    
    
    
    
    
    
    func playAudioFile() {
//        guard let url = Bundle.main.url(forResource: "notification", withExtension: "mp3") else { return }
//        do {
//            let audioPlayer = try AVAudioPlayer(contentsOf: notificaitonSoundURL!)
//            audioPlayer.play()
//        }
//        catch let error {
//            print("Notification could not played Error :\(error)")
//        }
        
        AudioServicesPlayAlertSound(SystemSoundID(1322))
    }
}
