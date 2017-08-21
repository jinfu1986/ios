//
//  SignupViewController.swift
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

class SignupController: UIViewController {
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    @IBAction func backBtn_pushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fbBtn_pushed(_ sender: Any) {
        let login = FBSDKLoginManager()
        
        SwiftSpinner.show("Signup...")
        
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
    
    @IBAction func phoneBtn_pushed(_ sender: Any) {
        self.performSegue(withIdentifier: "ToShowVerifySegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.layer.cornerRadius = button_cornor_radius
        phoneButton.layer.cornerRadius = button_cornor_radius
        
        phoneButton.layer.borderWidth = button_border_width
        phoneButton.layer.borderColor = UIColor.colorFromRGB(0x37353A).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUserProfile()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) == nil)
            {
                let dict = result as? NSDictionary
                
                let userName = dict?.value(forKey: "email") as! String
                let displayName = dict?.value(forKey: "name") as! String
               
                let hcProfile = User()
                
                hcProfile.userName = userName
                hcProfile.displayName = displayName
                
                if let profilePictureObj = dict?.value(forKey: "picture") as? NSDictionary
                {
                    let data = profilePictureObj.value(forKey: "data") as! NSDictionary
                    let pictureUrlString  = data.value(forKey: "url") as! String
                    
                    let pictureUrl = URL(string: pictureUrlString)
                    
                    self.getDataFromUrl(url: pictureUrl!) { (data, response, error)  in
                        guard let data = data, error == nil else { return }
                       
                        hcProfile.profileImage = data
                        
                        UserAPI.createUserProfile(profile:hcProfile) { (profile, errorMessage) in
                            SwiftSpinner.hide()
                            
                            if let profile = profile {
                                self.save(profile: profile)
                                
                                self.performSegue(withIdentifier: "ToShowTabBarSegue", sender: self)
                            }
                            else {
                                self.presentBasicAlert(message: "User already exist!")
                            }
                        }
                    }
                }
            }
        })
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
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
