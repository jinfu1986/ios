//
//  Stream.swift
//  Hivecast
//
//  Created by Mingming Wang on 6/30/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class Stream: NSObject {
    var userId: String = ""
    var streamId: String = ""
    var streamUrl: String = ""
    var thumbnailUrl: String = ""
    var streamTitle: String = ""
    var location: String = ""
    var key: String = ""
    
    var viewCount: Int = 0
    
}

extension DefaultsKeys {
    static let streamTitle = DefaultsKey<String>("streamTitle")
    static let streamUrl = DefaultsKey<String>("streamUrl")
    static let roomKey = DefaultsKey<String>("roomKey")
    static let produce_index = DefaultsKey<Int>("produce_index")
    static let produce_streamId = DefaultsKey<String>("produce_streamId")
    static let produce_userId = DefaultsKey<String>("produce_userId")
    static let produce_streamUrl = DefaultsKey<String>("produce_streamUrl")
    static let produce_roomKey = DefaultsKey<String>("produce_roomKey")
    static let series_id = DefaultsKey<String>("seriesId")
}

