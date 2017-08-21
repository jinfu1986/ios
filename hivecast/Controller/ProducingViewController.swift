//
//  ProducingViewController.swift
//  hivecast
//
//  Created by Mingming Wang on 7/22/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SocketIO
import IJKMediaFramework
import SwiftyUserDefaults

class ProducingViewController: UIViewController {
    @IBOutlet weak var streamContainer1: UIView!
    @IBOutlet weak var streamContainer2: UIView!
    @IBOutlet weak var streamContainer3: UIView!
    @IBOutlet weak var streamContainer4: UIView!
    
    var streamView1: ProduceView!
    var streamView2: ProduceView!
    var streamView3: ProduceView!
    var streamView4: ProduceView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkStreamSelection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func checkStreamSelection() {
        if (Defaults[.produce_streamUrl] != "") {
            switch Defaults[.produce_index] {
            case 1:
                streamView1.playStream(streamUrl: Defaults[.produce_streamUrl] , roomKey: Defaults[.produce_roomKey], userId: Defaults[.produce_userId], streamId: Defaults[.produce_streamId])
                
                break
            case 2:
                streamView2.playStream(streamUrl: Defaults[.produce_streamUrl] , roomKey: Defaults[.produce_roomKey], userId: Defaults[.produce_userId], streamId: Defaults[.produce_streamId])
                
                break
            case 3:
                streamView3.playStream(streamUrl: Defaults[.produce_streamUrl] , roomKey: Defaults[.produce_roomKey], userId: Defaults[.produce_userId], streamId: Defaults[.produce_streamId])
                
                break
            case 4:
                streamView4.playStream(streamUrl: Defaults[.produce_streamUrl] , roomKey: Defaults[.produce_roomKey], userId: Defaults[.produce_userId], streamId: Defaults[.produce_streamId])
                
                break
            default:
                break
            }
        }
    }
    
    func setupUI() {
        Defaults[.produce_index] = 0
        
        var rect = CGRect(
            origin: CGPoint(x:0, y:0),
            size: self.streamContainer1.bounds.size
        )
        
        if let objects = Bundle.main.loadNibNamed("ProduceView", owner: self, options: nil) {
            streamView1 = objects[0] as! ProduceView
            streamView1.index = 1
            streamView1.frame = rect
            
            self.streamContainer1.addSubview(streamView1)
        }
        
        rect = CGRect(
            origin: CGPoint(x:0, y:0),
            size: self.streamContainer2.bounds.size
        )
        
        if let objects = Bundle.main.loadNibNamed("ProduceView", owner: self, options: nil) {
            streamView2 = objects[0] as! ProduceView
            streamView2.index = 2
            streamView2.frame = rect
            
            self.streamContainer2.addSubview(streamView2)
        }
        
        rect = CGRect(
            origin: CGPoint(x:0, y:0),
            size: self.streamContainer3.bounds.size
        )
        
        if let objects = Bundle.main.loadNibNamed("ProduceView", owner: self, options: nil) {
            streamView3 = objects[0] as! ProduceView
            streamView3.index = 3
            streamView3.frame = rect
            
            self.streamContainer3.addSubview(streamView3)
        }
        
        rect = CGRect(
            origin: CGPoint(x:0, y:0),
            size: self.streamContainer4.bounds.size
        )
        
        if let objects = Bundle.main.loadNibNamed("ProduceView", owner: self, options: nil) {
            streamView4 = objects[0] as! ProduceView
            streamView4.index = 4
            streamView4.frame = rect
            
            self.streamContainer4.addSubview(streamView4)
        }
        
        self.streamView1.initialize(vc: self)
        self.streamView2.initialize(vc: self)
        self.streamView3.initialize(vc: self)
        self.streamView4.initialize(vc: self)
    }
    
    func changeFocusing(index:Int) {
        switch index {
        case 1:
            self.streamView1.reFocus(isFocusing: true)
            self.streamView2.reFocus(isFocusing: false)
            self.streamView3.reFocus(isFocusing: false)
            self.streamView4.reFocus(isFocusing: false)
            
            break
        case 2:
            self.streamView1.reFocus(isFocusing: false)
            self.streamView2.reFocus(isFocusing: true)
            self.streamView3.reFocus(isFocusing: false)
            self.streamView4.reFocus(isFocusing: false)
            
            break
        case 3:
            self.streamView1.reFocus(isFocusing: false)
            self.streamView2.reFocus(isFocusing: false)
            self.streamView3.reFocus(isFocusing: true)
            self.streamView4.reFocus(isFocusing: false)
            
            break
        case 4:
            self.streamView1.reFocus(isFocusing: false)
            self.streamView2.reFocus(isFocusing: false)
            self.streamView3.reFocus(isFocusing: false)
            self.streamView4.reFocus(isFocusing: true)
            
            break
        default:
            break
        }
    }
    
    func closeStreams() {
        UserAPI.stopStreamOnProduce(seriesId: Defaults[.series_id], completion: { (result, errorMessage) in
            self.streamView1.stop()
            self.streamView2.stop()
            self.streamView3.stop()
            self.streamView4.stop()
        })
    }
    
    @IBAction func cancelBtn_pushed(_ sender: Any) {
        self.closeStreams()
        
        self.dismiss(animated: true, completion: nil)
    }
}
