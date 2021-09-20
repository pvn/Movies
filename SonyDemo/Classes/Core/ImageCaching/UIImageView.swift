//
//  UIImageView.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import UIKit

let UrlCacheKey = malloc(4)

extension UIImageView {
    
    /// This method accept the image url and return the cache images if asked for
    /// - Parameters:
    ///   - url: url of image
    ///   - cache: ImageCache instance as dependency injection
    ///   - cacheType: cache type (ram, disk, none)
    ///   - placeHolderImgName: default placeholder image incase of failure
    ///   - completion: return image ibn callback
    public func setUrl(_ url: URL, cache: ImageCache = .default, cacheType: CacheType = .none, placeHolderImgName: String, completion: ((UIImage?) -> Void)? = nil) {
        
        let fitSize = CGSize.zero
        urlCacheKey = url.absoluteString
        
        cache.loadImage(atUrl: url, fitSize: fitSize, cache: cacheType, placeHolderImgName: placeHolderImgName) { [weak self] (urlStr, image) in
            if self?.urlCacheKey == urlStr {
                DispatchQueue.main.async {
                    self?.image = image
                    completion?(image)
                }
            }
        }
    }
    
    /// Clear url cache key
    public func clear() {
        urlCacheKey = nil
    }
    
    fileprivate func value<T>(_ key:UnsafeMutableRawPointer?, _ defaultValue:T) -> T {
        return (objc_getAssociatedObject(self, key!) as? T) ?? defaultValue
    }
    
    private var urlCacheKey: String? {
        get {
            return value(UrlCacheKey, "")
        }
        set {
            objc_setAssociatedObject(self, UrlCacheKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }    
}

