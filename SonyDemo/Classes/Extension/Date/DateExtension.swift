//
//  DateExtension.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//

import Foundation

extension Date {
    
    func toString(withFormat format: String = "yyyy'-'MM'-'dd") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
}
