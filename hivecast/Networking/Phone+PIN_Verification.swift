//
//  Phone+PIN_Verification.swift
//  HedgeTactical
//
//  Created by Ryan Daulton on 2/3/17.
//  Copyright © 2017 Ryan Daulton. All rights reserved.
//

import Foundation
import SinchVerification

class VerificationActions{
    
    var verification:Verification!;
    var applicationKey = "a3ed3be3-9f9a-471d-98e5-b65604a31c43";
    
    var phone = ""
    var pin = ""
    
    init(phoneNumber: String){
        self.phone = "+1" + phoneNumber
        verification = SMSVerification(applicationKey, phoneNumber: phone)
    }
    
    func verify(completionHandler: @escaping (Bool) -> ()){
        verification.initiate { (didSendSMS:InitiationResult, error:Error?) -> Void in
            if (didSendSMS.success){
                //self.performSegueWithIdentifier("enterPin", sender: sender)
                completionHandler(true)
            } else {
                //self.status.text = error?.description;
                completionHandler(false)
            }
        }
    }
    
    func verifyPIN(pin: String,completionHandler: @escaping (Bool) -> ()){
        verification.verify(pin, completion: { (success:Bool, error:Error?) -> Void in
            if (success) {
                print("success")
                completionHandler(true)
            } else {
                print("failure")
                completionHandler(false)
            }
        });
    }
}
