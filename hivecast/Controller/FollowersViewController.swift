//
//  FollowersViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/16/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyUserDefaults

class FollowersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var isfollow: Int!
    
    var users = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        UserAPI.retriveFollowUsers(userId: Defaults[.userId], searchKey: "", isFollow:isfollow) { (hiveUsers, errorMessage) in
            if let hiveUsers = hiveUsers {
                self.users = hiveUsers
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtn_pushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initialize() {
        isfollow = Defaults[.followCase]
        
        if (isfollow == 0){
            titleLabel.title = "Followers"
        }
        else {
            titleLabel.title = "Following"
        }
        
        self.searchBar.delegate = self
        self.searchBar.enablesReturnKeyAutomatically = false
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.frame = CGRect(x: 0, y: self.tableView.frame.origin.y - self.searchBar.frame.size.height, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height + self.searchBar.frame.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserCell = self.tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserCell
        
        let entry = users[indexPath.row]
        
        cell.thumbImageView.layer.cornerRadius = cell.thumbImageView.frame.size.width/2
        cell.thumbImageView.clipsToBounds = true
        
        cell.titleLabel.text = entry.displayName
        cell.thumbImageView.url = NSURL(string: entry.profileImageUrl!)
        
        cell.followButton.layer.cornerRadius = cell_button_cornor_radius
        cell.followButton.layer.borderWidth = button_border_width
        
        cell.followButton.tag = indexPath.row
        
        cell.followButton.alpha = 0.0
        
        cell.actionButton.tag = indexPath.row
        
        cell.actionButton.addTarget(self, action: #selector(action), for: .touchUpInside)
        
        if (entry.isFollowing == true) {
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.setTitleColor(UIColor.colorFromRGB(0xFFFFFF), for: .normal)
            
            cell.followButton.layer.borderColor = UIColor.colorFromRGB(0xFEC62E).cgColor
            cell.followButton.layer.backgroundColor = UIColor.colorFromRGB(0xFEC62E).cgColor
        }
        else {
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitleColor(UIColor.colorFromRGB(0xFEC62E), for: .normal)
            
            cell.followButton.layer.borderColor = UIColor.colorFromRGB(0xFEC62E).cgColor
            cell.followButton.layer.backgroundColor = UIColor.colorFromRGB(0xFFFFFF).cgColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
        
        UserAPI.retriveFollowUsers(userId: Defaults[.userId], searchKey: self.searchBar.text!, isFollow:isfollow) { (hiveUsers, errorMessage) in
            if let hiveUsers = hiveUsers {
                self.users = hiveUsers
                
                self.tableView.reloadData()
            }
        }
    }
    
    func action(sender: UIButton){
        let entry = users[sender.tag]
        
        Defaults[.otherUserId] = entry.userId
        
        self.performSegue(withIdentifier: "ToShowOtherUserSegue", sender: self)
    }
}
