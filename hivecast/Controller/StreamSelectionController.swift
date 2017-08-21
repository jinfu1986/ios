//
//  StreamSelectionController.swift
//  hivecast
//
//  Created by Mingming Wang on 7/26/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class StreamSelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var locationIndicator: UIView!
    @IBOutlet weak var searchIndicator: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var streams = [Stream]()
    
    override func viewWillAppear(_ animated: Bool) {
        UserAPI.retrieveUserStreams(userId: Defaults[.userId], searchKey: "") { (hiveStreams, errorMessage) in
            if let hiveStreams = hiveStreams {
                self.streams = hiveStreams
                
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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // hide search bar
        self.searchBar.alpha = 0.0
        self.searchBar.delegate = self
        self.searchBar.enablesReturnKeyAutomatically = false
        
        self.tableView.frame = CGRect(x: 0, y: self.tableView.frame.origin.y - self.searchBar.frame.size.height, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height + self.searchBar.frame.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.streams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VideoCell = self.tableView.dequeueReusableCell(withIdentifier: "userCell") as! VideoCell
        
        let entry = streams[indexPath.row]
        
        cell.titleLabel.text = entry.streamTitle
        cell.timeLabel.text = entry.location
        cell.viewsLabel.text = String(entry.viewCount) + " views"
        cell.thumbImageView.url = NSURL(string: entry.thumbnailUrl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stream = self.streams[(indexPath as NSIndexPath).row]
        
        Defaults[.produce_userId] = stream.userId
        Defaults[.produce_streamUrl] = stream.streamUrl
        Defaults[.produce_roomKey] = stream.key
        Defaults[.produce_streamId] = stream.streamId
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        Defaults[.produce_streamUrl] = ""
        Defaults[.produce_roomKey] = ""
        Defaults[.produce_streamId] = ""
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func locationBtn_pushed(_ sender: Any) {
        self.locationButton.setImage(UIImage(named: "LocationActive"), for: .normal)
        self.searchButton.setImage(UIImage(named: "SearchInactive"), for: .normal)
        
        self.locationIndicator.backgroundColor = UIColor.colorFromRGB(0xFEC62E)
        self.searchIndicator.backgroundColor = UIColor.colorFromRGB(0xFFFFFF)
        
        if (self.searchBar.alpha == 1.0) {
            self.searchBar.alpha = 0.0
            
            self.tableView.frame = CGRect(x: 0, y: self.tableView.frame.origin.y - self.searchBar.frame.size.height, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height + self.searchBar.frame.size.height)
        }
        
        self.searchBar.resignFirstResponder()
    }
    
    @IBAction func searchBtn_pushed(_ sender: Any) {
        self.locationButton.setImage(UIImage(named: "LocationInactive"), for: .normal)
        self.searchButton.setImage(UIImage(named: "SearchActive"), for: .normal)
        
        self.locationIndicator.backgroundColor = UIColor.colorFromRGB(0xFFFFFF)
        self.searchIndicator.backgroundColor = UIColor.colorFromRGB(0xFEC62E)
        
        if (self.searchBar.alpha == 0.0) {
            self.searchBar.alpha = 1.0
            
            self.tableView.frame = CGRect(x: 0, y: self.tableView.frame.origin.y + self.searchBar.frame.size.height, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height - self.searchBar.frame.size.height)
        }
        
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
        
        UserAPI.retrieveUserStreams(userId: Defaults[.userId], searchKey: self.searchBar.text!) { (hiveStreams, errorMessage) in
            if let hiveStreams = hiveStreams {
                self.streams = hiveStreams
                
                self.tableView.reloadData()
            }
        }
    }
}
