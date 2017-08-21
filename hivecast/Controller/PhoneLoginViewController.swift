//
//  PhoneVerifyViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/11/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyUserDefaults

class PhoneLoginViewController: UIViewController {
    @IBOutlet var avoidingView: UIView!
    
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var verifyIcon: UIButton!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBAction func cancelBtn_pushed(_ sender: Any) {
        phoneTextField.resignFirstResponder()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func verifyBtn_pushed(_ sender: Any) {
        phoneTextField.resignFirstResponder()
        
        let phoneNumber = phoneTextField.text
        
        if phoneNumber == "" {
            return
        }
        
        SwiftSpinner.show("Logging in...")
        
        UserAPI.retrieveUserProfileByPhone(phoneNumber:phoneTextField.text!) { (profile, errorMessage) in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialize()
    }
    
    func initialize() {
        KeyboardAvoiding.avoidingView = self.avoidingView
        
        phoneTextField.becomeFirstResponder()
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
}
