//
//  EditProfileViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/10/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyUserDefaults

class UserCreateViewController: UIViewController {
    @IBOutlet var avoidingView: UIView!
    
    @IBOutlet var profileImageView: AsyncImageView!
    @IBOutlet var displayNameText: UITextField!
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var phoneNumberText: UITextField!
    
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    @IBAction func doneBtn_pushed(_ sender: Any) {
        guard validate() else { return }
        
        resignFirstResponder()
        
        let imageData = UIImagePNGRepresentation(profileImageView.image!)
        let displayName = displayNameText.text
        let userName = userNameText.text
        let phoneNumber = phoneNumberText.text
        
        let hcProfile = User()
        
        hcProfile.profileImage = imageData
        hcProfile.displayName = displayName!
        hcProfile.userName = userName!
        hcProfile.phoneNumber = phoneNumber!
        
        SwiftSpinner.show("Creating account...")
        
        UserAPI.createUserProfile(profile: hcProfile) { (result, errorMessage) in
            SwiftSpinner.hide()
            
            if let profile = result {
                self.save(profile: profile)
                
                self.performSegue(withIdentifier: "ToShowTabBarSegue", sender: self)
            }
        }
    }
    
    
    @IBAction func profileImageButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: nil,
                                                message: "Select a profile image:",
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (_ action: UIAlertAction) in
                                            
        }
        alertController.addAction(cancelAction)
        
        let cameraAction = UIAlertAction(title: "Take with Camera",
                                         style: .default) { (_ action: UIAlertAction) in
                                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                                let picker = UIImagePickerController()
                                                picker.sourceType = .camera
                                                picker.cameraDevice = .front
                                                picker.delegate = self
                                                picker.allowsEditing = true
                                                self.present(picker, animated: true, completion: nil)
                                            }
        }
        alertController.addAction(cameraAction)
        
        let albumsAction = UIAlertAction(title: "Choose from Photos",
                                         style: .default) { (_ action: UIAlertAction) in
                                            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                                                let picker = UIImagePickerController()
                                                picker.sourceType = .photoLibrary
                                                picker.delegate = self
                                                picker.allowsEditing = true
                                                self.present(picker, animated: true, completion: nil)
                                            }
        }
        alertController.addAction(albumsAction)
        
        self.present(alertController, animated: true)
    }
    
    func initialize() {
        KeyboardAvoiding.avoidingView = self.avoidingView
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        
        self.phoneNumberText.text = Defaults[.phoneNumber]
    }
    
    func validate() -> Bool {
        var messages = [String]()
        
        if displayNameText.text == "" {
            messages.append("Display Name is required.")
        }
        
        if userNameText.text == "" {
            messages.append("Username is required.")
        }
        
        return messages.count == 0
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

extension UserCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            avatarImage = editedImage
        } else {
            avatarImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        profileImageView.image = avatarImage;
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
