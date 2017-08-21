//
//  TabbarController.swift
//  hivecast
//
//  Created by Mingming Wang on 8/17/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {
    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 1
    }
}
