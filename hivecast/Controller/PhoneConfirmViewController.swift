//
//  PhoneConfirmViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/11/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyUserDefaults

class PhoneConfirmViewController: UIViewController {
    @IBOutlet var avoidingView: UIView!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBAction func cancelBtn_pushed(_ sender: Any) {
        codeTextField.resignFirstResponder()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func verifyBtn_pushed(_ sender: Any) {
        codeTextField.resignFirstResponder()
        
        let pinCode = codeTextField.text
        
        if pinCode == "" {
            return
        }
        
        SwiftSpinner.show("Verifying pin code...")
        
        let verify = VerificationActions(phoneNumber: Defaults[.phoneNumber]!)
        
        verify.verifyPIN(pin: pinCode!,completionHandler: { success in
            SwiftSpinner.hide()
            
            if success{
                self.performSegue(withIdentifier: "ToShowUserCreateSegue", sender: self)
            }else{
                self.presentBasicAlert(message: "Pin code doesn't match!")
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialize()
    }
    
    func initialize() {
        KeyboardAvoiding.avoidingView = self.avoidingView
        
        codeTextField.becomeFirstResponder()
    }
}
