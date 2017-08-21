//
//  UserViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 6/28/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class UserListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserAPI.retrieveUserProfileById(userId:Defaults[.userId]) { (profile, errorMessage) in
            if let profile = profile {
                self.save(profile: profile)
                
                self.initialize()
            }
        }
        
        UserAPI.retrieveUserVideos(userId: Defaults[.userId]) { (hiveVideos, errorMessage) in
            if let hiveVideos = hiveVideos {
                self.videos = hiveVideos
                
                self.initialize()
                
                self.tableView.reloadData()
            }
        }
        
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editBtn_pushed(_ sender: Any) {
       self.performSegue(withIdentifier: "ToShowUserEditSegue", sender: self)
    }
    
    @IBAction func followerBtn_pushed(_ sender: Any) {
        Defaults[.followCase] = 0
        
        self.performSegue(withIdentifier: "ToShowFollowingSegue", sender: self)
    }
    
    @IBAction func followingBtn_pushed(_ sender: Any) {
        Defaults[.followCase] = 1
        
        self.performSegue(withIdentifier: "ToShowFollowingSegue", sender: self)
    }
    
    func initialize() {
        displayLabel.title = Defaults[.displayName]?.description
        
        followersCountLabel.text = Defaults[.followers_count]?.description
        followingCountLabel.text = Defaults[.following_count]?.description
        bioLabel.text = Defaults[.bioText]?.description
        siteLabel.text = Defaults[.siteUrl]?.description
        videoCountLabel.text = Defaults[.videos_count]?.description
        
        let image = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent("profile.png").path)
        
        if (image != nil) {
            profileImageView.image = image
        }
        else {
            profileImageView.url = NSURL(string: (Defaults[.profileImageUrl]?.description)!)
        }
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VideoCell = self.tableView.dequeueReusableCell(withIdentifier: "userCell") as! VideoCell
        
        let entry = videos[indexPath.row]
        
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width/2
        cell.userImageView.clipsToBounds = true
        
        cell.titleLabel.text = entry.videoTitle
        cell.timeLabel.text = entry.timeStamp
        cell.viewsLabel.text = String(entry.viewCount) + " views"
        cell.thumbImageView.url = NSURL(string: entry.thumbnailUrl)
        
        let image = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent("profile.png").path)
        
        if (image != nil) {
            cell.userImageView.image = image
        }
        else {
            cell.userImageView.url = NSURL(string: (Defaults[.profileImageUrl]?.description)!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = self.videos[(indexPath as NSIndexPath).row]
        
        Defaults[.videoUrl] = video.videoUrl
        
        UserAPI.increaseVideoViewCount(videoId: video.videoId, completion: { (result, errorMessage) in
            
        })
        
        self.performSegue(withIdentifier: "ToVideoPlaySegue", sender: self)
    }
    
    func save(profile:User) {
        Defaults[.userId] = profile.userId
        Defaults[.displayName] = profile.displayName
        Defaults[.userName] = profile.userName
        Defaults[.siteUrl] = profile.siteUrl
        Defaults[.phoneNumber] = profile.phoneNumber
        Defaults[.profileImageUrl] = profile.profileImageUrl
        Defaults[.followers_count] = profile.followers_count
        Defaults[.following_count] = profile.following_count
        Defaults[.bioText] = profile.bioText
        Defaults[.videos_count] = profile.videos_count
    }
}
