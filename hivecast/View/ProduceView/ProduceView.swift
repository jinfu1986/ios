//
//  ProduceView.swift
//  hivecast
//
//  Created by Mingming Wang on 7/22/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SocketIO
import IJKMediaFramework
import SwiftyUserDefaults

class ProduceView: UIView {
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var disconnectView: UIView!
    @IBOutlet weak var removeView:UIView!
    
    @IBOutlet weak var removeThumbImageView: AsyncImageView!
    @IBOutlet weak var thumbImageView: AsyncImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var focusButton:UIButton!
    @IBOutlet weak var volumnButton: UIButton!
    @IBOutlet weak var liveButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var vc:ProducingViewController!
    
    var player: IJKFFMoviePlayerController!
    var socket: SocketIOClient! = nil
    
    var isFocusing: Bool
    var isPlaying: Bool
    
    var index:Int
    
    var streamId: String
    
    required init?(coder aDecoder: NSCoder) {
        self.isPlaying = false
        self.isFocusing = false
        self.index = 0
        self.streamId = ""
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject) {
        Defaults[.produce_index] = index
        
        vc.performSegue(withIdentifier: "ToShowStreamSelectionSegue", sender: vc)
    }
    
    @IBAction func yesButtonPressed(_ sender: AnyObject) {
        self.stop()
    }
    
    @IBAction func noButtonPressed(_ sender: AnyObject) {
        removeView.alpha = 0.0
    }

    @IBAction func volumeButtonPressed(_ sender: AnyObject) {
        
    }
    
    func changeActive(sender:UITapGestureRecognizer){
        if (isPlaying == true && isFocusing == false) {
            isFocusing = true
            
            vc.changeFocusing(index: index)
            
            UserAPI.activeStreamOnProduce(streamId: streamId, seriesId: Defaults[.series_id], completion: { (result, errorMessage) in
                
            })
            
            let room = Room(dict: [
                "title": Defaults[.series_id] as AnyObject,
                "key": streamId as AnyObject
                ])
            
            socket.emit("change_active", room.toDict())
        }
    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        if (isPlaying == true) {
            removeView.alpha = 0.6
        }
    }
    
    func reFocus(isFocusing:Bool) {
        self.isFocusing = isFocusing
        
        if (isFocusing == true)
        {
            previewView.layer.borderWidth = 0.0
            previewView.layer.borderColor = UIColor.red.cgColor
            
            liveButton.alpha = 1.0
        }
        else {
            previewView.layer.borderWidth = 0.0
            previewView.layer.borderColor = UIColor.clear.cgColor
            
            if (isPlaying == true) {
                let room = Room(dict: [
                    "title": Defaults[.series_id] as AnyObject,
                    "key": streamId as AnyObject
                    ])
                
                socket.emit("change_inactive", room.toDict())
            }
            
            liveButton.alpha = 0.0
        }
    }
    
    func initialize(vc:ProducingViewController) {
        self.vc = vc
        
        liveButton.layer.cornerRadius = 12
        
        yesButton.layer.cornerRadius = 18
        noButton.layer.cornerRadius = 18
        
        thumbImageView.layer.cornerRadius = thumbImageView.frame.size.width/2
        thumbImageView.clipsToBounds = true
        
        removeThumbImageView.layer.cornerRadius = removeThumbImageView.frame.size.width/2
        removeThumbImageView.clipsToBounds = true
        
        yesButton.backgroundColor = UIColor.white
        noButton.backgroundColor = UIColor.clear
        
        noButton.layer.borderColor = UIColor.white.cgColor
        noButton.layer.borderWidth = 1.0
        
        disconnectView.alpha = 0.0
        thumbImageView.alpha = 0.0
        volumnButton.alpha = 0.0
        liveButton.alpha = 0.0
        removeView.alpha = 0.0
    }
    
    func playStream(streamUrl:String, roomKey:String, userId:String, streamId:String) {
        player = IJKFFMoviePlayerController(contentURLString: streamUrl, with: IJKFFOptions.byDefault())
        
        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player.view.frame = previewView.bounds
        
        previewView.addSubview(player.view)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeActive))
        
        player.view.addGestureRecognizer(gesture)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        player.view.addGestureRecognizer(longPressRecognizer)
        
        player.prepareToPlay()
        
        self.streamId = streamId
        
        socket = SocketIOClient(socketURL: URL(string: streamUrl)!, config: [.log(true), .forcePolling(true)])
        
        socket.on("connect") {[weak self] data, ack in
            self?.joinRoom(roomKey: roomKey)
        }
        
        self.start()
        
        addButton.alpha = 0.0
        
        UserAPI.retrieveUserProfileById(userId:userId) { (profile, errorMessage) in
            if let profile = profile {
                self.thumbImageView.alpha = 1.0
                
                self.thumbImageView.url = NSURL(string: profile.profileImageUrl!)
                self.removeThumbImageView.url = NSURL(string: profile.profileImageUrl!)
            }
        }
    }
    
    func joinRoom(roomKey:String) {
        socket.emit("join_room", roomKey)
    }
    
    func start() {
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
                if (self?.isPlaying)! {
                    self?.disconnectView.alpha = 0.6
                }
                else {
                    this.statusLabel.text = "Buffering"
                    this.statusLabel.alpha = 0.0
                }
            default:
                this.statusLabel.text = "Playing"
                
                self?.isPlaying = true
                
                self?.disconnectView.alpha = 0.0
            }
        })
    }
    
    func stop() {
        if (isPlaying == true) {
            player.shutdown()
            
            let room = Room(dict: [
                "title": Defaults[.series_id] as AnyObject,
                "key": streamId as AnyObject
                ])
            
            socket.emit("stop_stream", room.toDict())
            
            socket.disconnect()
        
            NotificationCenter.default.removeObserver(self)
        
            isPlaying = false
            
            disconnectView.alpha = 0.0
            thumbImageView.alpha = 0.0
            volumnButton.alpha = 0.0
            liveButton.alpha = 0.0
            removeView.alpha = 0.0
            
            statusLabel.text = ""
            
            player.view.removeFromSuperview()
            
            addButton.alpha = 1.0
        }
    }
}

