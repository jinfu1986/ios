//
//  Room.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/10/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import Foundation

struct Room {
    var key: String
    var title: String
    
    init(dict: [String: AnyObject]) {
        title = dict["title"] as! String
        key = dict["key"] as! String
    }
    
    func toDict() -> [String: AnyObject] {
        return [
            "title": title as AnyObject,
            "key": key as AnyObject
        ]
    }
}
