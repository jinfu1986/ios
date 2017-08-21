//
//  UIViewController+StoryboardPresent.swift
//  hivecast-app
//
//  Created by Noah on 5/26/17.
//  Copyright © 2017 hivecast. All rights reserved.
//

import Foundation
import UIKit

class StoryboardPresenter {
    static func viewController(withIdentifier identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }

    static func presentViewController(withIdentifier identifier: String) {
        let vc = StoryboardPresenter.viewController(withIdentifier: identifier)
        presentFromStoryboard(next: vc)
    }

    static func presentFromStoryboard(next: UIViewController) {
        var top = UIApplication.shared.keyWindow!.rootViewController!
        while (top.presentedViewController) != nil {
            top = top.presentedViewController!
        }

        top.present(next, animated: true, completion: nil)
    }
}
