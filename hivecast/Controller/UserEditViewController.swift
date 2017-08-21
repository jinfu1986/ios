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

class UserEditViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var avoidingView: UIView!
    
    @IBOutlet var profileImageView: AsyncImageView!
    @IBOutlet var displayNameText: UITextField!
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var webSiteText: UITextField!
    @IBOutlet var bioText: UITextView!
    
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    @IBAction func doneBtn_pushed(_ sender: Any) {
        guard validate() else { return }
        
        let imageData = UIImagePNGRepresentation(profileImageView.image!)
        let displayName = displayNameText.text
        let userName = userNameText.text
        let siteUrl = webSiteText.text
        let descText = bioText.text
        
        let hcProfile = User()
        
        hcProfile.userId = Defaults[.userId]
        hcProfile.profileImage = imageData
        hcProfile.displayName = displayName!
        hcProfile.userName = userName!
        hcProfile.siteUrl = siteUrl!
        hcProfile.bioText = descText!
        
        displayNameText.resignFirstResponder()
        userNameText.resignFirstResponder()
        webSiteText.resignFirstResponder()
        bioText.resignFirstResponder()
        
        SwiftSpinner.show("Updating profile...")
        
        UserAPI.updateUserProfile(profile: hcProfile) { (result, errorMessage) in
            SwiftSpinner.hide()
            
            if let profile = result {
                self.save(profile: profile)
                
                let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
                try? imageData?.write(to: filename)
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelBtn_pushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutBtn_pushed(_ sender: Any) {
        Defaults[.userId] = ""
        
        StoryboardPresenter.presentViewController(withIdentifier: "StartController")
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
        bioText.delegate = self
        
        KeyboardAvoiding.avoidingView = self.avoidingView
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        
        let image = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent("profile.png").path)
        
        if (image != nil) {
            profileImageView.image = image
        }
        else {
            profileImageView.url = NSURL(string: (Defaults[.profileImageUrl]?.description)!)
        }
        
        displayNameText.text = Defaults[.displayName]?.description
        userNameText.text = Defaults[.userName]?.description
        bioText.text = Defaults[.bioText]?.description
        webSiteText.text = Defaults[.siteUrl]?.description
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = range.range(for: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.characters.count <= 150
    }
}

extension UserEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension NSRange {
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}
