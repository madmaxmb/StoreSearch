//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Максим on 05.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageWithUrl(url: NSURL) -> NSURLSessionDownloadTask {
        let session = NSURLSession.sharedSession()
        
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: {[weak self] url, response, error in
            if error == nil, let url = url, data = NSData(contentsOfURL: url), image = UIImage(data: data) {
                dispatch_async(dispatch_get_main_queue()){
                    if let storeSelf = self {
                        storeSelf.image = image
                    }
                }
            }
        })
        downloadTask.resume()
        return downloadTask
    }
}