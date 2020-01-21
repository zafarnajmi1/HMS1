//
//  ChatVC.swift
//  TailerOnline
//
//  Created by apple on 3/19/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ObjectMapper
import PullToRefreshKit



class ChatVC: BaseImagePickerVC {

     //MARK:-  outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myHeader: UIView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myHeaderTitle: UILabel!
    @IBOutlet weak var myPrice: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var attachBtn: LoaderButton!
    @IBOutlet weak var txtMsg: UITextField!
    
    
    
     //MARK:- Properties
    
    var navigationTitle: String?
    var notificationId: String?
    var product : Product?
    var conversation: Conversation?
    var fetchingMore = false
    var delegate: CallBackDelegate?
    
    
    var messageList = [MessageModel]()
    var page = 1
    var totalPage = 0;
    var objPage = 0;
    
    let socket = SocketIOManager.sharedInstance.getSocket()
    let user = AppSettings.shared.user
    
   
     //MARK:-  life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackBarButton()
        setLocalization()
        setDeleteBtn(tintColor: .white)
        
        self.title = navigationTitle ?? "Conversation"
        
        setupView()
    }
    
    func setupView()  {
        txtMsg.delegate = self
        IQKeyboardManager.shared.enableAutoToolbar = false
        tableView.keyboardDismissMode = .onDrag // .interactive
        navigationController?.hidesBarsWhenKeyboardAppears = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        imagePickerDelegate = self
        
        reloadChatHeader()
        fetchMessageList()
        tableView.transform = CGAffineTransform (scaleX: 1,y: -1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      
        IQKeyboardManager.shared.enableAutoToolbar = true
       
    }
    

    
    override func backToMain() {
        socket.off("newConversation")
        self.socket.off("getConversation")
        self.socket.off("messagesList")
        self.socket.off("conversationsList")
        self.socket.off("newMessage")
        self.socket.off("moreData")
        delegate?.reloadData()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func deleteBtnTapped() {
        
        
        if messageList.count == 0 {
           
            self.alertMessage(message: "There are no conversation messages to delete".localized, btnTitle: "Cancel".localized) {
                print("cancel Tapped")
            }
        }
        else {
            self.presentAlert(message: "Do you want to  delete all conversation messages?".localized, yes: {
                self.deleteAllMessage()
            }, no: nil)
        }
        
        
      
    }
    
    
    //MARK:-  localization
    func loadLocalization()  {
        self.sendBtn.setTitle("Send".localized, for: .normal)
        let imageName = myDefaultLanguage == .ar ? "SendMessageAr": "SendMessage"
        self.sendBtn.setImage(UIImage(named: imageName), for: .normal)
        self.txtMsg.placeholder = "Write message...".localized
        let tfs = [txtMsg] as [UITextField]
        self.setTextFieldDirectionByLanguage(textFields: tfs)
        
    }
    
  
   
    
    func reloadChatHeader(){
        
        if let conversation = self.conversation {
        
            self.myHeaderTitle.text = conversation.product?.title
            if let price = conversation.product?.price {
                      self.myPrice.text = setDefualtCurrency(price: price)
            }
            
            if let price = product?.price {
                self.myPrice.text = setDefualtCurrency(price: price)
            }
            
           
            self.myImage.setPath(image: conversation.product?.image, placeHolder: AppConstant.placeHolders.product)
            
            if conversation.product == nil{
                print("Chat is Active against Store")
                let image = conversation.store?.image?.resizeImage(width: 100, height: 100)
                myImage.setPath(image: image, placeHolder: AppConstant.placeHolders.store)
                self.myHeader.heightAnchor.constraint(equalToConstant: 0).isActive = true
                self.myHeader.isHidden = true
            }
            
            
            switch myDefaultAccount {
                
            case .seller:
               
                self.title =  conversation.user?.fullName ?? "Chat"
                
            case .buyer:
                self.title = conversation.store?.storeName ?? "Chat"
                
            default:
                print("No Account Selected")
            }
        
        }

        


    }
    
    //MARK:- FetchPagesMoreData
    func beginBatchFetch() {
        
        fetchingMore = true
        
        print(self.objPage)
        print(self.totalPage)
        
        if (self.objPage) < (self.totalPage) {
            
            page += 1
            let params = ["conversation": conversation?.id!,"page": page] as [String : Any]
            self.socket.emit("messagesList", with: [params])
            
        }
        
    }
    //MARK:- SendMessage
    @IBAction func tbnSendMessageClick(_ sender: UIButton) {
        
        guard let msg = txtMsg.text else {
            return
        }
        if (msg  == ""){
            nvMessage.showStatusWarning(body: "Please Write something".localized)
        }
        else{
            let conversationID = ["conversation":conversation?.id!,
                                  "content" : msg]
            self.socket.emit("sendMessage", with: [conversationID])
            self.txtMsg.text = ""
        }
        
        
    }
    
    @IBAction func pickImageBtnTapped(sender: UIButton) {
        self.view.endEditing(true)
        self.alertPickerOptions()
    }
    
    
    
    //MARK:- Base Configuration
    fileprivate func configureTableViewRefresh() {
        let header = DefaultRefreshHeader.header()
        self.tableView.configRefreshHeader(with: header,container:self) { [weak self] in
            //call your function to update table View
            self?.messageList.removeAll()
            self?.fetchMessageList()
            if (self?.fetchingMore)! == false {
                self!.beginBatchFetch()
            }
        }
        delay(bySeconds: 0.2, closure: {
            self.tableView.switchRefreshHeader(to: .refreshing)
        })
        
    }
    
    
}



extension ChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
}

extension ChatVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.messageList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let message = messageList.getElement(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        let senderid = message.sender
        let myId = self.user?.id
        
        if (senderid != myId ) {
            return receiverSetup(message, tableView, indexPath)
        }
        else{
            return senderSetup(message, tableView, indexPath)
        }
        
        
    }
    
   
    func receiverSetup(_ message: MessageModel, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        switch message.mimeType {
       
        case "image/jpeg","image/png":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverImageCell.id) as! ReceiverImageCell
            cell.setData(message: message, conversation: conversation)
    
            return cell
            
        case "text":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverMessageCell.id) as! ReceiverMessageCell
            cell.setData(message: message, conversation)
            return cell
       
        default:
         
            return UITableViewCell()
      }

    }
    
    
    
    func senderSetup(_ message: MessageModel, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        switch message.mimeType {
       
        case "image/jpeg","image/png" :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SenderImageCell.id) as! SenderImageCell
            cell.setData(message: message)
            cell.deleteBtn.onTap {
                self.presentAlert(message: "Do you want to delete this message?".localized, yes: {
                    self.deleteMessage(msgId: message._id, indexPath: indexPath, button: cell.deleteBtn)
                }, no: nil)
            }
            return cell
            
         case "text":
          
            let cell = tableView.dequeueReusableCell(withIdentifier: SenderMessageCell.id) as! SenderMessageCell
            cell.setData(message: message)
            cell.deleteBtn.onTap {
                self.presentAlert(message: "Do you want to delete this message?".localized, yes: {
                    self.deleteMessage(msgId: message._id, indexPath: indexPath, button: cell.deleteBtn)
                }, no: nil)
            }
            return cell;
            
        default:
             return UITableViewCell()
        }
        
    }
    
    
}


 //MARK:-  chat delete message/ conversation messages
extension ChatVC {
  
    
    
    func deleteAllMessage() {
        
        guard let conversationId = conversation?.id else {
            print("conversation id  not found")
            return
        }
        
        let params = ["_id":conversationId]
        self.socket.emit("removeConversationMessages", with: [params])
        
      
        self.showNvLoader()
        self.socket.once("removeConversationMessages") { (data, ack) in
            let modified =  (data[0] as AnyObject)
           self.hideNvloader()
            if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: modified) {
                
                if rootModel.success == true {
                    print(rootModel.message ?? "deleted all conversation messages")
                    self.messageList.removeAll()
                    self.tableView.reloadData()
                    nvMessage.showSuccess(body: rootModel.message ?? "deleted all conversation messages")
                }
                else {
                    nvMessage.showError(body: rootModel.message ?? "something went wrong")
                }
                
            }
        }
    }
    
    
    func deleteMessage(msgId: String?, indexPath: IndexPath, button: LoaderButton  ) {
        
        guard let conversationID = conversation?.id, let msgId = msgId else {
            print("conversation id / message id not found")
            return
        }
        
        let params = ["_id":msgId,
                      "conversation":conversationID]
        self.socket.emit("removeMessage", with: [params])
        
        button.indicatorLoadingColor = UIColor.red
        button.backgroundLoadingColor = UIColor.clear
        button.showLoading()
        self.socket.once("removeMessage") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            button.hideLoading()
            if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: modified) {
                
                if rootModel.success == true {
                    print(rootModel.message ?? "deleted")
                    self.messageList.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                else {
                    nvMessage.showError(body: rootModel.message ?? "something went wrong")
                }
                
            }
        }
    }
    
    
}


 //MARK:- notification seen
extension ChatVC {
    
    func notificationSeenLlist() {
        guard let id = notificationId else {
            return
        }
        
        var seenList = [String]()
        seenList.append(id)
        let params = ["notifications": seenList]
        print(params)
        
        if(seenList.count > 0){
            self.socket.emit("notificationsSeen", with: [params])
        }
    }

}


 //MARK:- socket message list / getconversation / new message
extension ChatVC {
    
    
   
    
    func fetchMessageList() {
        
        
        ///notification  read request
        self.notificationSeenLlist()
        
        guard let conversationId = conversation?.id else { return }
        
         //fetch message List
        let params = ["conversation":conversationId,
                      "page": self.page] as [String : Any]
        
        self.socket.emit("messagesList", with: [params])
        
    
            self.socket.on("newConversation") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: modified) {
                 
                    if let conversationId = rootModel.data?.conversation?.id {
                        let params = [ "conversation":conversationId,
                                       "page": self.page] as [String : Any]
                        self.socket.emit("messagesList", with: [params])
                    }
                
                }
                
            }
            
            self.socket.on("getConversation") { (data, ack) in
                
                
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
                
                if let rootModel = Mapper<ConversationAPIResponse>().map(JSONObject: modified) {
                    
                    if let conversationId = rootModel.data?.conversation?.id {
                        let params = [ "conversation":conversationId,
                                       "page": self.page] as [String : Any]
                        self.socket.emit("messagesList", with: [params])
                    }
                    
                }
                
            }
            
            self.socket.once("messagesList") { (data, ack) in
                
                
                
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
                
                let Conversation = ChatModel.init(dictionary: dictionary as NSDictionary)
                
                self.messageList.removeAll()
                self.messageList +=  (Conversation?.data?.messages ?? [])
                
                self.totalPage = (Conversation?.data?.pagination?.pages ?? 0)
                print(self.totalPage)
                self.objPage =  (Conversation?.data?.pagination?.page ?? 0)
                self.fetchingMore = false
                
                
                
              
                self.messageList.reverse()
                self.tableView.reloadData()
                self.tableView.switchRefreshHeader(to: .normal(.success, 0.0))
                
                
                if( self.messageList.count > 0) {
                    
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
                    
                }
            
            }
        
            self.socket.on("conversationsList") { (data, ack) in
                
                let params = ["conversation":conversationId,
                              "page": self.page] as [String : Any]
              
                self.socket.emit("messagesList", with: [params])
            }
        
       
            self.socket.on("newMessage") { (data, ack) in
                
                
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print( dictionary)
                
                let objData = NewMessageModel.init(dictionary: dictionary as NSDictionary)
                
                if let message = objData?.data?.data_new_message {
                
                    if self.conversation?.id == message.conversation {
                        self.messageList.insert(message, at: 0)
                        
                        if self.messageList.count > 0{
                            self.tableView.reloadData()

                             self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
                        }
                    }
                
                }
                
                

            }
            
        
    }
    
    
}

extension ChatVC: BaseImagePickerVCDelegate {
   
    
    func mySelectedImage(image: UIImage) {
        attachBtn.showLoading()
        SocketEventManager.shared.uploadImage(image: image) { (result) in
            switch result {
            case .progress(let value):
                let counter = Int(value)
                print("File Upload Progress Status:\(counter)")
            case .path(let fileName):
               self.attachBtn.hideLoading()
                let params = [
                    "conversation":  self.conversation!.id!,
                    "type" : "image/jpeg",
                    "fileName" : fileName
                    ] as [String : Any]
                
                self.socket.emit("sendMessage", with: [params])
            }
        }
    }
    
   
}


 //MARK:-  localization
extension ChatVC {
    private func setLocalization() {
        self.txtMsg.placeholder = "Write message...".localized
        AppLanguage.updateTextFieldsDirection([txtMsg])
        self.setViewDirectionByLanguage()
    }
}
