//
//  BroadcastViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/10/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SocketIO
import LFLiveKit
import SwiftyUserDefaults

class BroadcastViewController: UIViewController {
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var room: Room!
    
    let socket = SocketIOClient(socketURL: URL(string: STREAM_ENDPOINT)!, config: [.log(true), .forceWebsockets(true)])
    
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .medium3)
        
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)!
        session.delegate = self
        session.captureDevicePosition = .back
        session.preView = self.previewView
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        session.running = true
        start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.running = false
        stop()
    }
    
    func start() {
        room = Room(dict: [
            "title": Defaults[.streamTitle] as AnyObject,
            "key": Defaults[.roomKey] as AnyObject
            ])
        
        let stream = LFLiveStreamInfo()
        stream.url = "\(STREAM_PUSH_ENDPOINT)\(room.key)"
        session.startLive(stream)
        
        socket.connect()
        socket.once("connect") {[weak self] data, ack in
            guard let this = self else {
                return
            }
            this.socket.emit("create_room", this.room.toDict())
        }
    }
    
    func stop() {
        guard room != nil else {
            return
        }
        session.stopLive()
        socket.disconnect()
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension BroadcastViewController: LFLiveSessionDelegate {
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        switch state {
        case .error:
            statusLabel.text = "error"
        case .pending:
            statusLabel.text = "pending"
        case .ready:
            statusLabel.text = "ready"
        case.start:
            statusLabel.text = "start"
        case.stop:
            statusLabel.text = "stop"
        default:
            statusLabel.text = "waiting"
        }
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("error: \(errorCode)")
        
    }
}

