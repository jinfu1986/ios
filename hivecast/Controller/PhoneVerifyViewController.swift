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

class PhoneVerifyViewController: UIViewController {
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
        
        SwiftSpinner.show("Sending verification code...")
        
        let verifyMe = VerificationActions(phoneNumber: phoneNumber!)
        
        verifyMe.verify(completionHandler: { success in
            SwiftSpinner.hide()
            
            Defaults[.phoneNumber] = phoneNumber
            
            self.performSegue(withIdentifier: "ToShowConfirmSegue", sender: self)
            
            return
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.verifyIcon.isEnabled = false
        self.verifyButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialize()
    }
    
    func initialize() {
        KeyboardAvoiding.avoidingView = self.avoidingView
        
        phoneTextField.becomeFirstResponder()
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if (self.phoneTextField.text?.characters.count == 10) {
            self.verifyIcon.isEnabled = true
            self.verifyButton.isEnabled = true
        }
        else {
            self.verifyIcon.isEnabled = false
            self.verifyButton.isEnabled = false
        }
    }
}
