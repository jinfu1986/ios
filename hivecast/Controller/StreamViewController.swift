
//
//  AudienceViewController.swift
//  Live
//
//  Created by leo on 16/7/11.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import SocketIO
import IJKMediaFramework
import SwiftyUserDefaults

class StreamViewController: UIViewController {
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var player: IJKFFMoviePlayerController!
    let socket = SocketIOClient(socketURL: URL(string: Defaults[.streamUrl])!, config: [.log(true), .forcePolling(true)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = IJKFFMoviePlayerController(contentURLString: Defaults[.streamUrl], with: IJKFFOptions.byDefault())
        
        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player.view.frame = previewView.bounds
        previewView.addSubview(player.view)
        
        player.prepareToPlay()
        
        socket.on("connect") {[weak self] data, ack in
            self?.joinRoom()
        }
    }
    
    func joinRoom() {
        socket.emit("join_room", Defaults[.roomKey])
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.play()
        socket.connect()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player, queue: OperationQueue.main, using: { [weak self] notification in
            guard let this = self else {
                return
            }
            let state = this.player.loadState
            switch state {
            case IJKMPMovieLoadState.playable:
                this.statusLabel.text = "Playable"
            case IJKMPMovieLoadState.playthroughOK:
                this.statusLabel.text = "Playing"
            case IJKMPMovieLoadState.stalled:
                this.statusLabel.text = "Buffering"
            default:
                this.statusLabel.text = "Playing"
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.shutdown()
        socket.disconnect()
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
