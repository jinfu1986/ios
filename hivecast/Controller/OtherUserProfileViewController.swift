//
//  OtherUserProfileViewController.swift
//  hivecast
//
//  Created by Mingming Wang on 7/19/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class OtherUserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var displayLabel: UINavigationItem!
    @IBOutlet weak var profileImageView: AsyncImageView!
    
    @IBOutlet weak var videoCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var bioLabel: UITextView!
    @IBOutlet weak var siteLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserAPI.retrieveUserProfileById(userId:Defaults[.otherUserId]) { (profile, errorMessage) in
            if let profile = profile {
                self.displayLabel.title = profile.displayName
                self.profileImageView.url = NSURL(string: profile.profileImageUrl!)
                self.followersCountLabel.text = profile.followers_count.description
                self.followingCountLabel.text = profile.following_count.description
                self.bioLabel.text = profile.bioText
                self.siteLabel.text = profile.siteUrl
                self.videoCountLabel.text = profile.videos_count.description
            }
        }
        
        UserAPI.retrieveUserVideos(userId: Defaults[.otherUserId]) { (hiveVideos, errorMessage) in
            if let hiveVideos = hiveVideos {
                self.videos = hiveVideos
                
                self.initialize()
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtn_pushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initialize() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VideoCell = self.tableView.dequeueReusableCell(withIdentifier: "userCell") as! VideoCell
        
        let entry = videos[indexPath.row]
        
        cell.titleLabel.text = entry.videoTitle
        cell.timeLabel.text = entry.timeStamp
        cell.viewsLabel.text = String(entry.viewCount) + " views"
        cell.thumbImageView.url = NSURL(string: entry.thumbnailUrl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = self.videos[(indexPath as NSIndexPath).row]
        
        Defaults[.videoUrl] = video.videoUrl
        
        UserAPI.increaseVideoViewCount(videoId: video.videoId, completion: { (result, errorMessage) in
            
        })
        
        self.performSegue(withIdentifier: "ToVideoPlaySegue", sender: self)
    }
}
