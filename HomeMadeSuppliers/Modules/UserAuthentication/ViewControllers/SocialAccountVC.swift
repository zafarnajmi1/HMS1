//
//  SocialAccountVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 5/21/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import InstagramLogin

class SocialAccountVC: UIViewController {

    
    //MARK:- properties
    var firstName: String?
    var lastName: String?
    var email: String?
    var socialToken: String?
    var socialId: String?
    
    var getProfileCompletionHandler: (() -> Void)?
    
    
    //Instagram
    var instagramLogin: InstagramLoginViewController!


    var currentAccessToken : String!
   // var dataInstagram : String!
    struct instgramUrls {
        static let clientId = "1a50df5f7e4a413b88059ece6c3de03f" //"42b51078b45b4e39b15674e24acfe423"
        static let redirectUri =  "https://www.projects.mytechnology.ae/car-insurance/"
        
       // static let clientScret = "54786ef7ce44467ba81408c1a9adf89d"
        static let authorization = "https://api.instagram.com/oauth/authorize/"
        static let scope = "likes+comments+relationships"
        
    }
    
    
    enum socialAccountType: String {
        case facebook
        case google
        case instagram
        case none
    }
    
    var socialAccountTypeSelected = socialAccountType.none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.delegate = self
       
    }
    
    
    func profileFetched() {
        
    }
    
    
    // App ID not found. Add a string value with your app ID for the key FacebookAppID to the Info.plist or call [FBSDKSettings setAppID:].'
    //add fbID in URL Type-> scheme> Item 0: value
    func setupFaceBookLogin() {
          socialAccountTypeSelected = .facebook
        
        let loginManger = LoginManager()
      
        loginManger.logIn(permissions: ["email", "public_profile"], from: self ){[weak self](loginResult, error)in
            
            if error != nil{
                print(error?.localizedDescription ?? "You are not login somthing wrong")
            }
            else if((loginResult?.isCancelled)!)
            {
                print("cancelled login screen")
                
            }
            else {
                //Validate permission granted
                guard let _ = loginResult?.grantedPermissions.contains("email")  else {
                    //Out from Function
                    return
                }
                //Validate Current Access Token
                guard let _ = AccessToken.current  else {
                    //Out from Function
                    return
                }
                
                let params = ["fields":"id, name, first_name, last_name, email, gender, picture.type(large)"]
                
                GraphRequest(graphPath: "/me", parameters: params )
                    .start(completionHandler: {(connection, result, error)in
                        
                        if(error == nil){
                            
                            let dic = result as! [String: AnyObject]
                            self!.socialToken = AccessToken.current?.tokenString ??  ""
                            print(self!.socialToken ?? "Not Found FB Token")
                            
                            self!.firstName = dic["first_name"] as? String
                            self!.lastName = dic["last_name"] as? String
                            
                            
                            self!.email = dic["email"] as? String
                            self!.socialId = dic["id"] as? String
                            
                            print(self!.socialId ?? "Facebook: Social ID Not Found")
                            //API call
                            self?.getProfileCompletionHandler?()
                        }
                        else{
                            print(error?.localizedDescription ??  "some thing is wrong")
                        }
                    })
            }
        }
        
    }
    
    
    func logoutFromFacebook(){
        let loginManger = LoginManager()
        loginManger.logOut()
    
    }
}

extension SocialAccountVC : GIDSignInDelegate  {
     //add Reversed Client ID in >info Plist > URL Type-> scheme> Item 1: value
    //make sure both facebook and google added in info plist
    func setupGmailLogin(){
        
        socialAccountTypeSelected = .google
        
        let googleLogin = GIDSignIn.sharedInstance()
        googleLogin?.shouldFetchBasicProfile = true
        googleLogin?.scopes = ["profile", "email"]
        googleLogin?.delegate = self
        googleLogin?.presentingViewController = self
        googleLogin?.signOut()
        googleLogin?.signIn() // call sign in screen
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Swift.Error!) {
        
        if let error = error{
            
            print(error.localizedDescription)
            
        }
        else if(error == nil) {
            
            socialToken = GIDSignIn.sharedInstance()?.currentUser.authentication.idToken
            socialId = user.userID
            //var GoogleDic : [String: Any] = ["": ""]
            
            email = user.profile.email
            let fullName = user.profile.name
            let list = fullName!.components(separatedBy: " ")
            firstName = list.getElement(at: 0)
            lastName = list.getElement(at: 1)
            print(email ?? "email")
            print(firstName ?? "firstName")
            print(lastName ?? "lastName")
            print(socialId ?? "soicalId")
            self.getProfileCompletionHandler?()
        }
    }
    
    
    
}



extension SocialAccountVC {
    
    func instagramLoginRequest(){
       
      
        
        let urlString = "https://api.instagram.com/v1/users/self/?access_token=\(self.currentAccessToken!)"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error!)")
                return
            }
            print("response = \(response!)")
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
            let jsonText = responseString
            
            var dictonary:NSDictionary?
            
            if let data = jsonText?.data(using: String.Encoding.utf8) {
                
                do {
                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                    
                    if let myDictionary = dictonary {
                        print(" First name is: \(myDictionary["data"]!)")
                        if let dataData = myDictionary["data"] as? [String:Any]{
                            
                            self.email = dataData["username"]! as? String
                            let fullName = dataData["full_name"]! as? String
                            let components = fullName?.components(separatedBy: " ")
                            if components?.count ?? 0 > 1 {
                                self.firstName = components?.first
                                self.lastName = components?.last
                            }
                            else {
                                  self.firstName = fullName ?? ""
                            }
                          
                          
                            self.socialId = dataData["id"]! as? String
                            self.socialToken = self.currentAccessToken
                            self.getProfileCompletionHandler?()
                        }
                        
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    func setupInsgramLogin(){
        
        socialAccountTypeSelected = .instagram
        
        instagramLogin = InstagramLoginViewController(clientId: instgramUrls.clientId, redirectUri: instgramUrls.redirectUri )
        instagramLogin.delegate = self
        instagramLogin.scopes = [.basic]
        print(instagramLogin)
        instagramLogin.navigationItem.title = "Instagram"
        instagramLogin.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissLoginViewController))
        instagramLogin.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPage))
        
        present(UINavigationController(rootViewController: instagramLogin), animated: true)
        
        
    }
    
    
    
    @objc func dismissLoginViewController() {
        instagramLogin.dismiss(animated: true)
    }
    
    @objc func refreshPage() {
        instagramLogin.reloadPage()
    }
    
   
   
   
    
    
}


extension SocialAccountVC: InstagramLoginViewControllerDelegate {
    
    func instagramLoginDidFinish(accessToken: String?, error: InstagramError?) {
        dismissLoginViewController()
        
        if accessToken != nil {
            
            // alertMessage(message: accessToken!, completionHandler: nil)//(title: "Successfully logged in! 👍", message: accessToken!)
            self.currentAccessToken = accessToken!
            instagramLoginRequest()
        } else {
            alertMessage(message: error?.localizedDescription ?? "" , btnTitle: "CANCEL".localized) {
                print("Cancel")
            }
        }
    }
    
}






class SocialProfile {
    var firstName: String?
    var lastName: String?
    var email: String?
    var socialToken: String?
    var socialId: String?
    var authMethod: String?
    init(firstName: String?, lastName: String?, email: String?, socialId: String?, socialToken: String?, authMethod: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.socialId = socialId
        self.socialToken = socialToken
        self.authMethod = authMethod
    }
}
