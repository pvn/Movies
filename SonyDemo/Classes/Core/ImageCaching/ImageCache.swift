//
//  ImageCache.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import UIKit

open class ImageCache {
    
    public static let `default` = ImageCache()
    
    let imageCacheQueue = DispatchQueue(label: "ImageCache")
    var workItems = NSCache<NSString, DispatchWorkItem>()
    
    // to store the images for caching
    var images = NSCache<NSString, UIImage>()
    
    // set the cache type as default none
    open var cacheType = CacheType.none
    
    public init() {
    }
    
    /// added observers for memory leak
    func addObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("UIApplicationDidReceiveMemoryWarning"),
                                               object: self, queue: nil) {
            notification in
        }
    }
    
    /// Returns the UIImage objects from cache if exists
    /// - Parameters:
    ///   - url: url of image
    ///   - size: size of image
    ///   - cache: cache type
    ///   - completion: callback to caller
    ///   - placeHolderImgName: placeholder image name
    open func loadImage(atUrl url: URL, fitSize size: CGSize? = nil, cache: CacheType, placeHolderImgName: String, completion: ((String, UIImage?) -> Void)? = nil) {
        print(#function, self)
        
        cacheType = cache
        // if cache type is none, need to clear the ram, and disk images
        if(cacheType == .none) {
            self.clear()
        }
        let urlString = url.absoluteString
        //used urlString or image url string as key to store in RAM or DISK
        let key = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? urlString
        DispatchQueue(label: "LoadImageQueue").async { [weak self] in
            guard self != nil else {
                return
            }
            
            let workItem = DispatchWorkItem { [weak self] in
                //Keep your initial image download code here:-
                ImageDownloadHelper.setImageFromURL(urlString, placeHolder: placeHolderImgName, show: false, headers: [:]) { (imageData) in
                    if imageData != nil {
                        if(self?.cacheType == CacheType.none) {
                            DispatchQueue.main.async {
                                let image = UIImage(data: imageData!)
                                completion?(urlString, image)
                            }
                            return
                        }
                    }else{
                        DispatchQueue.main.async {
                            completion?(urlString, UIImage(named: placeHolderImgName) )
                        }
                    }
                }
            }
            self!.workItems.setObject(workItem, forKey: key as NSString)
            self!.imageCacheQueue.async(execute: workItem)
        }
    }
    
    /// Clear all the caches
    open func clear() {
        workItems.removeAllObjects()
        images.removeAllObjects()
    }
}
