//
//  AsyncImageView.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/8/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit

public class AsyncImageView: UIImageView {
    public var placeholderImage : UIImage?
    
    public var url : NSURL? {
        didSet {
            self.image = placeholderImage
            if let urlString = url?.absoluteString {
                ImageLoader.sharedLoader.imageForUrl(urlString: urlString) { [weak self] image, url in
                    if let strongSelf = self {
                        DispatchQueue.main.async(execute: { () -> Void in
                            if strongSelf.url?.absoluteString == url {
                                strongSelf.image = image ?? strongSelf.placeholderImage
                            }
                        })
                    }
                }
            }
        }
    }
    
    public func setURL(url: NSURL?, placeholderImage: UIImage?) {
        self.placeholderImage = placeholderImage
        self.url = url
    }
    
}
