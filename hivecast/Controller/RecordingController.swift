//
//  RecordingViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 6/28/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyUserDefaults
import LFLiveKit

class RecordingController: UIViewController, UITextFieldDelegate {
    @IBOutlet var previewView: UIView!
    @IBOutlet var avoidingView: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var produceButton: UIButton!
    
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .medium3)
        
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)!
        session.captureDevicePosition = .back
        session.preView = self.previewView
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        KeyboardAvoiding.avoidingView = self.avoidingView
        
        titleTextField.becomeFirstResponder()
        closeButton.alpha = 1.0
        
        session.running = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.running = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        titleTextField.resignFirstResponder()
        
        titleTextField.text = ""
        closeButton.alpha = 0.0
    }
    
    @IBAction func liveButtonPressed(_ sender: AnyObject) {
        let streamTitle = titleTextField.text
        
        if streamTitle != "" {
            Defaults[.streamTitle] = streamTitle!
            Defaults[.roomKey] = Defaults[.userId] + "_" + getTodayString()
            
            self.performSegue(withIdentifier: "ToStreamRecordSegue", sender: self)
            
            titleTextField.text = ""
        }
    }
    
    @IBAction func produceButtonPressed(_ sender: AnyObject) {
        let streamTitle = titleTextField.text
        
        if streamTitle != "" {
            SwiftSpinner.show("...")
            
            Defaults[.streamTitle] = streamTitle!
            Defaults[.roomKey] = Defaults[.userId]
            
            UserAPI.createProduceStream(title: Defaults[.streamTitle], userId: Defaults[.userId]) { (result, errorMessage) in
                SwiftSpinner.hide()
                
                self.titleTextField.text = ""
                
                if let seriesId = result {
                    Defaults[.series_id] = seriesId
                    
                    self.performSegue(withIdentifier: "ToShowProducingSegue", sender: self)
                }
            }
        }
    }
    
    func initialize() {
        titleTextField.attributedPlaceholder = NSAttributedString(string: "What are you showing?",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
       
        
        liveButton.layer.cornerRadius = button_cornor_radius
        produceButton.layer.cornerRadius = button_cornor_radius
        
        titleTextField.delegate = self;
        
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func getTodayString() -> String{
        let date = Date()
        
        return String(date.timeIntervalSince1970)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        closeButton.alpha = 0.0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (self.titleTextField.text?.characters.count != 0) {
            closeButton.alpha = 1.0
        }
        else
        {
            closeButton.alpha = 0.0
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if (self.titleTextField.text?.characters.count == 0) {
            closeButton.alpha = 0.0
        }
        else {
            closeButton.alpha = 1.0
        }
    }
}

