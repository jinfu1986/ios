//
//  LoginViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 6/28/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyUserDefaults
import SwiftSpinner

class LoginController: UIViewController {
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    @IBAction func backBtn_pushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fbBtn_pushed(_ sender: Any) {
        let login = FBSDKLoginManager()
        
        SwiftSpinner.show("Logging in...")
        
        login.logIn(
            withReadPermissions: ["public_profile", "email", "user_friends"],
            from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
                if let _ = error {
                    _ = [
                        "LoginManagerResult": result.debugDescription,
                        "UserID": "n/a"
                        ] as [String : Any]
                    
                } else if result != nil && result!.isCancelled {
                    SwiftSpinner.hide()
                } else {
                    self.fetchUserProfile()
                }
        }
    }
    
    func initialize() {
        facebookButton.layer.cornerRadius = button_cornor_radius
        phoneButton.layer.cornerRadius = button_cornor_radius
        
        phoneButton.layer.borderWidth = button_border_width
        phoneButton.layer.borderColor = UIColor.colorFromRGB(0x37353A).cgColor
    }
    
    func save(profile:User) {
        Defaults[.userId] = profile.userId
        Defaults[.displayName] = profile.displayName
        Defaults[.userName] = profile.userName
        Defaults[.siteUrl] = profile.siteUrl
        Defaults[.phoneNumber] = profile.phoneNumber
        Defaults[.profileImageUrl] = profile.profileImageUrl
        Defaults[.followers_count] = profile.followers_count
        Defaults[.following_count] = profile.following_count
        Defaults[.bioText] = profile.bioText
        Defaults[.videos_count] = profile.videos_count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUserProfile()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            SwiftSpinner.hide()
            
            if ((error) == nil)
            {
                let dict = result as? NSDictionary
                
                let email = dict?.value(forKey: "email") as! String
                
                UserAPI.retrieveUserProfileByEmail(email:email) { (profile, errorMessage) in
                    SwiftSpinner.hide()
                    
                    if let profile = profile {
                        self.save(profile: profile)
                        
                        self.performSegue(withIdentifier: "ToShowTabBarSegue", sender: self)
                    }
                    else {
                        self.presentBasicAlert(message: "User doesn't exist!")
                    }
                }
            }
        })
    }
}

