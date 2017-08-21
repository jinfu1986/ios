//
//  OtherUserViewController.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/16/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyUserDefaults

class OtherUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        UserAPI.retrieveOtherUsers(userId: Defaults[.userId], searchKey: "") { (hiveUsers, errorMessage) in
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
    
    
    func initialize() {
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
        cell.actionButton.tag = indexPath.row
        
        cell.followButton.addTarget(self, action: #selector(follow), for: .touchUpInside)
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
        
        UserAPI.retrieveOtherUsers(userId: Defaults[.userId], searchKey: self.searchBar.text!) { (hiveUsers, errorMessage) in
            if let hiveUsers = hiveUsers {
                self.users = hiveUsers
                
                self.tableView.reloadData()
            }
        }
    }
    
    func follow(sender: UIButton){
        let entry = users[sender.tag]
        
        SwiftSpinner.show("...")
        
        UserAPI.follow(userId: entry.userId, isFollow:entry.isFollowing!, completion: { (result, errorMessage) in
            SwiftSpinner.hide()
            
            if (entry.isFollowing == true)
            {
                entry.isFollowing = false
            }
            else {
                entry.isFollowing = true
            }
            
            let indexPath = IndexPath(item: sender.tag, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .top)
        })
    }
    
    func action(sender: UIButton){
        let entry = users[sender.tag]
        
        Defaults[.otherUserId] = entry.userId
        
        self.performSegue(withIdentifier: "ToShowOtherUserSegue", sender: self)
    }
}
