//
//  VideoViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/8/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//


import UIKit
import AVKit
import AVFoundation
import SwiftyUserDefaults

class VideoViewController: AVPlayerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let videoURL = URL(string: Defaults[.videoUrl].description)
        let player = AVPlayer(url: videoURL!)
        
        self.player = player
        
        self.player?.play()
    }
}
