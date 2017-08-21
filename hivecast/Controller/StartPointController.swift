//
//  StartPointViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 6/28/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit

class StartPointController: UIViewController {
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize() {
        signupButton.layer.cornerRadius = button_cornor_radius
        loginButton.layer.cornerRadius = button_cornor_radius
        
        loginButton.layer.borderWidth = button_border_width
        loginButton.layer.borderColor = UIColor.colorFromRGB(0xFEC62E).cgColor
    }
}
