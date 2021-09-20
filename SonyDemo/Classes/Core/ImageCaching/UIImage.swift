//
//  UIImage.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.
import UIKit
import ImageIO

extension UIImage {
    
    func scaleToFit(in size: CGSize) -> UIImage? {
        var ratio = max(size.width / self.size.width, size.height / self.size.height)
        if ratio >= 1.0 {
            return self
        }
        
        ratio = ceil(ratio * 100) / 100
        
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

