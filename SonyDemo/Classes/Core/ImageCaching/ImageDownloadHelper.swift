//
//  UIImageView.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import UIKit
var downloadsImages: [AnyHashable : Any] = [:]
var showLoader = false;
class ImageDownloadHelper: NSObject {
    
    class func setImageFromURL(_ url: String?, placeHolder: String?, show: Bool, headers:[String: String], completionBlock: @escaping (_ image: Data?) -> Void){
        showLoader = show
        downloadThumbImage(url, watermarkData: "", genericUrl: "", placeHolder: "", willHaveWaterMark: false, channelName: "", isDynamicThumbNail: false, cacheLocation: "", headers: headers, completionBlock: completionBlock)
    }
    
    class func downloadThumbImage(_ url: String?, watermarkData: String?, genericUrl: String?, placeHolder: String?, willHaveWaterMark: Bool, channelName: String?, isDynamicThumbNail: Bool, cacheLocation location: String?, headers:[String: String], completionBlock: @escaping (_ image: Data?) -> Void) {
        var url = url
        if url?.contains("http://") ?? false {
            url = url?.replacingOccurrences(of: "http://", with: "https://")
        }
        
        if (downloadsImages[url] == nil){
            // hideLoader(forIndexPath: indexPath)
            completionBlock(nil)
        } else {
            downloadsImages[url] = "YES"
        }
        
        downloadAndSaveImage(url: url, location: "", path: "", isDynamicThumbNail: false, placeolder: "", channelName: "", headers:headers, completionBlock: completionBlock)
    }
    
    class func downloadAndSaveImage(url: String?, location: String?, path: String?, isDynamicThumbNail: Bool, placeolder: String?, channelName: String?, headers:[String: String], completionBlock: @escaping (_ image: Data?) -> Void) {
        
        startAsyncImageDownload(url, headers: headers, completionBlock: completionBlock)
    }
    
    class func startAsyncImageDownload(_ urlString: String?, headers:[String: String], completionBlock: @escaping (_ imageData: Data?) -> Void) {
        
        let imageUrl = URL(string: urlString ?? "")
        
        var imageRequest: URLRequest?
        if imageUrl != nil {
            imageRequest = URLRequest(url: imageUrl!)
        }
        
        imageRequest?.allHTTPHeaderFields = headers
        imageRequest?.httpMethod = "GET"
        
        // let session = URLSession.shared
        let imagesession = URLSession(configuration: .default)
        if imageRequest != nil {
            let task = imagesession.dataTask(with: imageRequest!) { (data, response, error) in
                let res = response as? HTTPURLResponse
                if res?.statusCode == 200 {
                    // print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        DispatchQueue.main.async {                            
                            completionBlock(imageData)
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print(#function, error?.localizedDescription as Any)
                }
            }
            task.resume()
        }
    }
    
    func downloadThumbImage(_ url:String?){
        let assetImageURL = URL(string: url!)!
        
        // Creating a session object with the default configuration.
        // You can read more about it here
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: assetImageURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if (response as? HTTPURLResponse) != nil {
                    //print("Downloaded cat picture with response code \(res.statusCode)")
                    if data != nil {
                        // Finally convert that Data into an image and do what you wish with it.
//                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            // self.imageVIew.image = image
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
        
    }
    
}


