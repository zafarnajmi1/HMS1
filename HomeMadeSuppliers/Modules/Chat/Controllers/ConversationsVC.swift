//
//  ConversationsVC.swift
//  TailerOnline
//
//  Created by apple on 3/19/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import ObjectMapper


class ConversationsVC: UIViewController {
 
    //MARK:- outlets
    @IBOutlet weak var tableView: UITableView!
    
     //MARK:- properties
    //var myRootConversation = ConversationAPIResponse()
    var conversations: [Conversation]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Conversations".localized
        showNavigationBar()
        setupView()
    }
    
//    override func backToMain() {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    //MARK:- Base Configuration
    fileprivate func setupView() {
        addBackBarButton()
        setDeleteBtn(tintColor: .white)
        tableView.pullToRefresh {
          self.fetchConversations()
        }
      
        // socket call
        self.showNvLoader()
        self.fetchConversations()
        
    }
    
    
    override func deleteBtnTapped() {
        if conversations?.count ?? 0 == 0 {
            self.alertMessage(message: "There are no conversations to delete".localized, btnTitle: "Cancel".localized) {
                print("cancel Tapped")
            }
        }
        else {
            self.presentAlert(message: "Do you want to delete all conversations?".localized, yes: {
                self.deleteAllMessage()
            }, no: nil)
        }
        
        
        
        
    }
    
    
    func fetchConversations(){
        
       let socket = SocketIOManager.sharedInstance.getSocket()
       
        
        // handle connected
       socket.emit("conversationsList")
        
    
        socket.on("conversationsList") { (data, ack) in
            self.tableView.switchRefreshHeader(to: .normal(.none, 0.0))
            self.hideNvloader()
            
            let modified =  (data[0] as AnyObject)
        
            let dictionary = modified as! [String: AnyObject]
            
            if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: dictionary) {
                print(rootModel.message ?? "" )
                self.conversations =  rootModel.data?.conversations
    
                if  self.conversations?.count ?? 0 == 0 {
                    self.tableView.setEmptyView(message: "No Record Found".localized)
                }
                else {
                    self.tableView.backgroundView = nil
                    self.tableView.reloadData()
                }
            }
            else {
                nvMessage.showStatusError(body: "Response Changed")
            }
            
          
           
        }
        
        socket.on("lastMessage") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            
            print(dictionary)
            socket.emit("conversationsList")
            
        }
        
        
            
    }
}

extension ConversationsVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationTableViewCell") as! ConversationTableViewCell
        
        let model = self.conversations?[indexPath.row]
        cell.setData(model: model!)
        cell.selectionStyle = .none
        cell.deleteButton.onTap {
            self.presentAlert(message: "Do you want to delete this conversation?".localized, yes: {
                self.deleteMessage(conversationId: model?.id, indexPath: indexPath, button: cell.deleteButton)
            }, no: nil)
            
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let s = AppConstant.storyBoard.chat
        let vc =   s.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        
        let model = self.conversations?[indexPath.row]
        vc.conversation = model
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ConversationsVC: CallBackDelegate {
    func reloadData() {
        self.fetchConversations()
    }
}




//MARK:-  chat delete message/ conversation messages
extension ConversationsVC {
  
    func deleteAllMessage() {
        
        let socket = SocketIOManager.sharedInstance.getSocket()
    
        socket.emit("removeAllConversations")
        
        
        self.showNvLoader()
        socket.once("removeAllConversations") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            self.hideNvloader()
            if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: modified) {
                
                if rootModel.success == true {
                    print(rootModel.message ?? "deleted all conversation messages".localized)
                    self.conversations?.removeAll()
                    self.tableView.backgroundView = nil
                    self.tableView.reloadData()
                    nvMessage.showSuccess(body: rootModel.message ?? "deleted all conversation messages".localized)
                  
                }
                else {
                    nvMessage.showError(body: rootModel.message ?? "something went wrong".localized)
                }
                
            }
        }
    }
    
    
    func deleteMessage(conversationId: String?, indexPath: IndexPath, button: LoaderButton  ) {
        
         let socket = SocketIOManager.sharedInstance.getSocket()
        
        guard let conversationId = conversationId else {
            print("conversation id not found")
            return
        }
        
        let params = ["conversations":[conversationId]]
     
        socket.emit("removeConversations", with: [params])
        
        button.indicatorLoadingColor = UIColor.red
        button.backgroundLoadingColor = UIColor.clear
        button.showLoading()
        socket.once("removeConversations") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            button.hideLoading()
            if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: modified) {
                
                if rootModel.success == true {
                    print(rootModel.message ?? "deleted")
                    self.conversations?.remove(at: indexPath.row)
                    self.tableView.backgroundView = nil
                    self.tableView.reloadData()
                }
                else {
                    nvMessage.showError(body: rootModel.message ?? "something went wrong".localized)
                }
                
            }
        }
    }
    
    
}
