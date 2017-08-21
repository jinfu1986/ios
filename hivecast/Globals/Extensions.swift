//
//  Extensions.swift
//  Hivecast
//
//  Created by Mingming Wang on 6/28/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import Foundation
import Social

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

extension UIColor {
    class func colorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension UIViewController {
    /*
     * Displays a basic Alert when an error occurs in the app.
     *
     * Future: Eventually all of these should be replaced with proper error handling
     *      and in-app error messages.
     *
     * Notes: Must happen on the main thread.
     */
    func presentBasicAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error",
                                          message: message,
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            print(message)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentYesNoAlert(message: String,
                           yesHandler: @escaping (UIAlertAction) -> Void,
                           noHandler: @escaping (UIAlertAction) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Prompt",
                                          message: message,
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes",
                                          style: UIAlertActionStyle.default,
                                          handler: yesHandler))
            alert.addAction(UIAlertAction(title: "No",
                                          style: UIAlertActionStyle.cancel,
                                          handler: noHandler))
            
            print(message)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentSocialShareSheet(forServiceType service: String,
                                 withMessage message: String,
                                 andLoginMessage loginMessage: String) {
        if SLComposeViewController.isAvailable(forServiceType: service) {
            if let sheet = SLComposeViewController(forServiceType: service) {
                sheet.setInitialText(message)
                present(sheet, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Accounts", message: loginMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
