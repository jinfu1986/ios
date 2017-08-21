//
//  Video.swift
//  Hivecast
//
//  Created by Mingming Wang on 6/30/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class Video: NSObject {
    var videoId: String = ""
    var videoUrl: String = ""
    var thumbnailUrl: String = ""
    var videoTitle: String = ""
    
    var viewCount: Int = 0
    var timeStamp: String = ""
    
    init(videoId : String, videoUrl : String, thumbnailUrl : String, videoTitle : String, viewCount : Int, timeStamp : String) {
        self.videoId = videoId
        self.videoUrl = videoUrl
        self.thumbnailUrl = thumbnailUrl
        self.videoTitle = videoTitle
        self.viewCount = viewCount
        self.timeStamp = timeStamp
    }
}

extension DefaultsKeys {
    static let videoUrl = DefaultsKey<String>("videoUrl")
}


