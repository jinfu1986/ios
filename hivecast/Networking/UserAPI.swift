//
//  UserAPI.swift
//  hivecast-app
//
//  Created by Mingming on 3/13/17.
//  Copyright © 2017 hivecast. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

class UserAPI {
    static func retrieveUserProfileByPhone(phoneNumber: String, completion: @escaping UserCompletionHandler) {
        let endpoint = API_ENDPOINT + "/user/login"
        
        let parameters : Parameters = [
            "phone_number": phoneNumber
        ]
        
        Alamofire.request(endpoint, method: .post,
                          parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    guard let jsonDict = response.result.value as? NSDictionary else {
                        completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                        return
                    }
                    
                    if let dataDict = jsonDict["user"]  as? NSDictionary {
                        let user = userFromDict(dataDict)
                        
                        let session = URLSession(configuration: .default)
                        
                        let URL_IMAGE = URL(string: user.profileImageUrl!)
    
                        //creating a dataTask
                        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
                            
                            if let e = error {
                                print("Error Occurred: \(e)")
                                
                            } else {
                                //in case of now error, checking wheather the response is nil or not
                                if (response as? HTTPURLResponse) != nil {
                                    
                                    //checking if the response contains an image
                                    if let imageData = data {
                                        
                                        //getting the image
                                        let image = UIImage(data: imageData)
                                        
                                        if let data = UIImagePNGRepresentation(image!) {
                                            let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
                                            try? data.write(to: filename)
                                        }
                                        
                                    } else {
                                        print("Image file is currupted")
                                    }
                                } else {
                                    print("No response from server")
                                }
                            }
                        
                            completion(user, "")
                        }
                    
                        // starting the download task
                        getImageFromUrl.resume()
                    }
                    
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(nil, errorMessage)
                }
        }
    }
    
    static func retrieveUserProfileByEmail(email: String, completion: @escaping UserCompletionHandler) {
        let endpoint = API_ENDPOINT + "/user/fb_login"
        
        let parameters : Parameters = [
            "user_name": email
        ]
        
        Alamofire.request(endpoint, method: .post,
                          parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    guard let jsonDict = response.result.value as? NSDictionary else {
                        completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                        return
                    }
                    
                    if let dataDict = jsonDict["user"]  as? NSDictionary {
                        let user = userFromDict(dataDict)
                        
                        let session = URLSession(configuration: .default)
                        
                        let URL_IMAGE = URL(string: user.profileImageUrl!)
                        
                        //creating a dataTask
                        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
                            
                            if let e = error {
                                print("Error Occurred: \(e)")
                                
                            } else {
                                //in case of now error, checking wheather the response is nil or not
                                if (response as? HTTPURLResponse) != nil {
                                    
                                    //checking if the response contains an image
                                    if let imageData = data {
                                        
                                        //getting the image
                                        let image = UIImage(data: imageData)
                                        
                                        if let data = UIImagePNGRepresentation(image!) {
                                            let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
                                            try? data.write(to: filename)
                                        }
                                        
                                    } else {
                                        print("Image file is currupted")
                                    }
                                } else {
                                    print("No response from server")
                                }
                            }
                            
                            completion(user, "")
                        }
                        
                        // starting the download task
                        getImageFromUrl.resume()
                    }
                    
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(nil, errorMessage)
                }
        }
    }
    
    static func retrieveUserProfileById(userId: String, completion: @escaping UserCompletionHandler) {
        let endpoint = API_ENDPOINT + "/user/get/" + userId
        
        Alamofire.request(endpoint, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    guard let jsonDict = response.result.value as? NSDictionary else {
                        completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                        return
                    }
                    
                    if let dataDict = jsonDict["user"]  as? NSDictionary {
                        let user = userFromDict(dataDict)
                        
                        completion(user, "")
                    }
                    
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(nil, errorMessage)
                }
        }
    }
    
    static func createProduceStream(title:String, userId: String, completion: @escaping ProduceCompletionHandler) {
        let endpoint = API_ENDPOINT + "/series"
        
        let parameters : Parameters = [
            "title": title,
            "user_id": userId
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    guard let jsonDict = response.result.value as? NSDictionary else {
                        completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                        return
                    }
                    
                    let seriesId = jsonDict["series_id"]  as? String
                    
                    completion(seriesId, "")
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(nil, errorMessage)
                }
        }
    }
    
    static func activeStreamOnProduce(streamId: String, seriesId: String, completion: @escaping BoolCompletionHandler) {
        let endpoint = API_ENDPOINT + "/series/" + seriesId
        
        let parameters : Parameters = [
            "stream_id": streamId
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    completion(true, "")
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(false, errorMessage)
                }
        }
    }
    
    static func stopStreamOnProduce(seriesId: String, completion: @escaping BoolCompletionHandler) {
        let endpoint = API_ENDPOINT + "/series/stop/" + seriesId
        
        Alamofire.request(endpoint, method: .post)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    completion(true, "")
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(false, errorMessage)
                }
        }
    }
    
    static func follow(userId: String, isFollow: Bool, completion: @escaping BoolCompletionHandler) {
        var follow = ""
        
        if (isFollow == false)
        {
            follow = "/follow/"
        }
        else
        {
            follow = "/unfollow/"
        }
        
        let endpoint = API_ENDPOINT + follow + Defaults[.userId] + "/" + userId
        
        Alamofire.request(endpoint, method: .post)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    completion(true, "")
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(false, errorMessage)
                }
        }
    }
    
    static func increaseVideoViewCount(videoId: String, completion: @escaping BoolCompletionHandler) {
        let endpoint = API_ENDPOINT + "/viewed/" + videoId
        
        Alamofire.request(endpoint, method: .post)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    completion(true, "")
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(false, errorMessage)
                }
        }
    }
    
    static func retrieveOtherUsers(userId: String, searchKey: String, completion: @escaping MultipleUsersCompletionHandler) {
        let endpoint = API_ENDPOINT + "/user/" + userId + "/others/" + searchKey
        
        Alamofire.request(endpoint, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    guard let jsonDict = response.result.value as? NSDictionary else {
                        completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                        return
                    }
                    
                    guard let dataDict = jsonDict.value(forKey: "users") as? NSArray else {
                        completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                        return
                    }
                    
                    var users = [User]()
                    
                    for userJson in dataDict {
                        if let userDict = userJson as? NSDictionary {
                            let user = userFromDict(userDict)
                            users.append(user)
                        }
                    }
                    
                    completion(users, nil)
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(nil, errorMessage)
                }
                
        }
    }
    
    static func retriveFollowUsers(userId: String, searchKey: String, isFollow: Int, completion: @escaping MultipleUsersCompletionHandler) {
        var endpoint = ""
        
        if (isFollow == 0) {
            endpoint = API_ENDPOINT + "/user/" + userId + "/followers/" + searchKey
        }
        else {
            endpoint = API_ENDPOINT + "/user/" + userId + "/followings/" + searchKey
        }
        
        Alamofire.request(endpoint, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    guard let jsonDict = response.result.value as? NSDictionary else {
                        completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                        return
                    }
                    
                    guard let dataDict = jsonDict.value(forKey: "users") as? NSArray else {
                        completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                        return
                    }
                    
                    var users = [User]()
                    
                    for userJson in dataDict {
                        if let userDict = userJson as? NSDictionary {
                            let user = userFromDict(userDict)
                            users.append(user)
                        }
                    }
                    
                    completion(users, nil)
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(nil, errorMessage)
                }
        }
    }
    
    static func retrieveUserVideos(userId: String, completion: @escaping MultipleVideosCompletionHandler) {
        let endpoint = API_ENDPOINT + "/videos/" + userId
        
        Alamofire.request(endpoint, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    guard let dataDict = response.result.value as? NSArray else {
                        completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                        return
                    }
                    
                    var videos = [Video]()
                    
                    for videoJson in dataDict {
                        if let videoDict = videoJson as? NSDictionary {
                            let video = videoFromDict(videoDict)
                            videos.append(video)
                        }
                    }
                    
                    completion(videos, nil)
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(nil, errorMessage)
                }
                
        }
    }
    
    static func retrieveUserStreams(userId: String, searchKey: String, completion: @escaping MultipleStreamsCompletionHandler) {
        let endpoint = API_ENDPOINT + "/streams/" + searchKey
        
        Alamofire.request(endpoint, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    guard let dataDict = response.result.value as? NSArray else {
                        completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                        return
                    }
                    
                    var streams = [Stream]()
                    
                    for streamJson in dataDict {
                        if let streamDict = streamJson as? NSDictionary {
                            let stream = streamFromDict(streamDict)
                            streams.append(stream)
                        }
                    }
                    
                    completion(streams, nil)
                case .failure(let error):
                    let errorMessage = "Failed to retrieve user's hive from backend: (" +
                    "\(response.response?.statusCode ?? -1): \(error)"
                    
                    completion(nil, errorMessage)
                }
                
        }
    }
    
    static func updateUserProfile(profile: User, completion: @escaping UserCompletionHandler) {
        let parameters = profileToParameters(hivecastProfile: profile)
        let endpoint = API_ENDPOINT + "/user/update/" + profile.userId
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(profile.profileImage!,
                                         withName: "profile_photo",
                                         fileName: "file.png",
                                         mimeType: "image/png")
                if let userParameters = parameters as? [String: String] {
                    for (key, value) in userParameters {
                        let valData = value.data(using: String.Encoding.utf8)!
                        multipartFormData.append(valData, withName:key)
                    }
                }
        },
            to: endpoint,
            method: .post,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success:
                            guard let jsonDict = response.result.value as? NSDictionary else {
                                completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                                return
                            }
                            
                            if let dataDict = jsonDict["user"]  as? NSDictionary {
                                let user = userFromDict(dataDict)
                                
                                completion(user, "")
                            }
                        case .failure(let error):
                            completion(nil, "\(error)")
                        }
                    }
                case .failure(let encodingError):
                    completion(nil, "\(encodingError)")
                }
        }
        )
    }
    
    static func createUserProfile(profile: User, completion: @escaping UserCompletionHandler) {
        let parameters = profileToParametersForCreation(hivecastProfile: profile)
        let endpoint = API_ENDPOINT + "/user/signup"
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(profile.profileImage!,
                                         withName: "profile_photo",
                                         fileName: "file.png",
                                         mimeType: "image/png")
                if let userParameters = parameters as? [String: String] {
                    for (key, value) in userParameters {
                        let valData = value.data(using: String.Encoding.utf8)!
                        multipartFormData.append(valData, withName:key)
                    }
                }
        },
            to: endpoint,
            method: .post,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success:
                            guard let jsonDict = response.result.value as? NSDictionary else {
                                completion(nil, "Failed to retrieve user's hive from backend: Invalid JSON response")
                                return
                            }
                            
                            if let dataDict = jsonDict["user"]  as? NSDictionary {
                                let user = userFromDict(dataDict)
                                
                                let session = URLSession(configuration: .default)
                                
                                let URL_IMAGE = URL(string: user.profileImageUrl!)
                                
                                //creating a dataTask
                                let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
                                    
                                    if let e = error {
                                        print("Error Occurred: \(e)")
                                        
                                    } else {
                                        //in case of now error, checking wheather the response is nil or not
                                        if (response as? HTTPURLResponse) != nil {
                                            
                                            //checking if the response contains an image
                                            if let imageData = data {
                                                
                                                //getting the image
                                                let image = UIImage(data: imageData)
                                                
                                                if let data = UIImagePNGRepresentation(image!) {
                                                    let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
                                                    try? data.write(to: filename)
                                                }
                                                
                                            } else {
                                                print("Image file is currupted")
                                            }
                                        } else {
                                            print("No response from server")
                                        }
                                    }
                                    
                                    completion(user, "")
                                }
                                
                                // starting the download task
                                getImageFromUrl.resume()
                            }
                        case .failure(let error):
                            completion(nil, "\(error)")
                        }
                    }
                case .failure(let encodingError):
                    completion(nil, "\(encodingError)")
                }
        }
        )
    }
    
    static func userFromDict(_ dict: NSDictionary) -> User {
        let hcProfile = User()
        
        let userId = dict.value(forKey: "_id") as? String ?? ""
        let followers_cnt = dict.value(forKey: "follower_count") as? Int ?? 0
        let following_cnt = dict.value(forKey: "following_count") as? Int ?? 0
        let videos_cnt = dict.value(forKey: "video_count") as? Int ?? 0
        let profile_photo = dict.value(forKey: "profile_photo") as? String ?? ""
        let display_name = dict.value(forKey: "display_name") as? String ?? ""
        let user_name = dict.value(forKey: "user_name") as? String ?? ""
        let website = dict.value(forKey: "website") as? String ?? ""
        let phone_number = dict.value(forKey: "phone_number") as? String ?? ""
        let bio = dict.value(forKey: "bio") as? String ?? ""
        let is_following = dict.value(forKey: "is_following") as? Bool ?? false
        
        hcProfile.userId = userId
        hcProfile.followers_count = followers_cnt
        hcProfile.following_count = following_cnt
        hcProfile.profileImageUrl = profile_photo
        hcProfile.displayName = display_name
        hcProfile.userName = user_name
        hcProfile.siteUrl = website
        hcProfile.bioText = bio
        hcProfile.phoneNumber = phone_number
        hcProfile.videos_count = videos_cnt
        hcProfile.isFollowing = is_following
        
        return hcProfile
    }
    
    static func streamFromDict(_ dict: NSDictionary) -> Stream {
        let stream = Stream()
        
        let streamId = dict.value(forKey: "_id") as? String ?? ""
        let userId = dict.value(forKey: "user_id") as? String ?? ""
        let thumbnailUrl = dict.value(forKey: "thumb_url") as? String ?? ""
        let streamUrl = dict.value(forKey: "stream_url") as? String ?? ""
        var location = dict.value(forKey: "location") as? String ?? ""
        let viewCount = dict.value(forKey: "views") as? Int ?? 0
        let title = dict.value(forKey: "title") as? String ?? ""
        let key = dict.value(forKey: "key") as? String ?? ""
        
        // test code
        location = "Unavailable now"
        
        stream.streamId = streamId
        stream.userId = userId
        stream.thumbnailUrl = thumbnailUrl
        stream.streamUrl = streamUrl
        stream.streamTitle = title
        stream.location = location
        stream.viewCount = viewCount
        stream.key = key
        
        return stream
    }
    
    static func videoFromDict(_ dict: NSDictionary) -> Video {
        let videoId = dict["_id"] as? String
        let videoUrl = dict["video_url"] as? String
        let thumbnailUrl = dict["thumb_url"] as? String
        let videoTitle = dict["event_name"] as? String
        let viewCount = dict["views"] as? Int
        let timeStamp = dict["started"] as? String
        
        let video = Video(videoId:videoId!, videoUrl:videoUrl!, thumbnailUrl:thumbnailUrl!, videoTitle:videoTitle!, viewCount:viewCount!, timeStamp:timeStamp!)
        
        return video
    }
    
    static func profileToParameters(hivecastProfile: User) -> Parameters {
        let parameters: Parameters = [
            "display_name": hivecastProfile.displayName,
            "website": hivecastProfile.siteUrl,
            "bio": hivecastProfile.bioText
        ]
        
        return parameters
    }
    
    static func profileToParametersForCreation(hivecastProfile: User) -> Parameters {
        let parameters: Parameters = [
            "display_name": hivecastProfile.displayName,
            "user_name": hivecastProfile.userName,
            "phone_number": hivecastProfile.phoneNumber
        ]
        
        return parameters
    }
}
