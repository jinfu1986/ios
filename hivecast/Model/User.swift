//
//  User.swift
//  Hivecast
//
//  Created by Mingming Wang on 6/30/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

class User: NSObject {
    var userId: String=""
    var displayName: String = ""
    var userName: String = ""
    var siteUrl: String = ""
    var phoneNumber: String = ""
    var bioText: String = ""
    var profileImageUrl: String?
    
    var isFollowing: Bool?
    var profileImage: Data?
    
    var followers_count: Int = 0
    var following_count: Int = 0
    var videos_count: Int = 0
}

extension DefaultsKeys {
    // Hivecast profile information
    static let userId = DefaultsKey<String>("userId")
    static let otherUserId = DefaultsKey<String>("otherUserId")
    static let displayName = DefaultsKey<String?>("displayName")
    static let userName = DefaultsKey<String?>("userName")
    static let siteUrl = DefaultsKey<String?>("siteUrl")
    static let phoneNumber = DefaultsKey<String?>("phoneNumber")
    static let profileImageUrl = DefaultsKey<String?>("profileImageUrl")
    static let followers_count = DefaultsKey<Int?>("followers_count")
    static let following_count = DefaultsKey<Int?>("following_count")
    static let videos_count = DefaultsKey<Int?>("video_count")
    static let bioText = DefaultsKey<String?>("bioText")
    static let isFollowing = DefaultsKey<String?>("isFollowing")
    
    static let followCase = DefaultsKey<Int?>("followCase")
    
}
