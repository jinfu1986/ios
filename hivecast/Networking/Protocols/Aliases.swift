//
//  Aliases.swift
//  hivecast-app
//
//  Created by Noah on 3/27/17.
//  Copyright © 2017 hivecast. All rights reserved.
//

// MARK: General type aliases

typealias MultipleUsersCompletionHandler = (_ result: [User]?, _ errorMessage: String?) -> Void

typealias MultipleVideosCompletionHandler = (_ result: [Video]?, _ errorMessage: String?) -> Void

typealias MultipleStreamsCompletionHandler = (_ result: [Stream]?, _ errorMessage: String?) -> Void

typealias UserCompletionHandler = (_ result: User?, _ errorMessage: String?) -> Void

typealias BoolCompletionHandler = (_ result: Bool, _ errorMessage: String?) -> Void

typealias ProduceCompletionHandler = (_ streamId: String?, _ errorMessage: String?) -> Void
