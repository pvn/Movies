//
//  StringExtension.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import Foundation

extension String {

    func toDate(withFormat format: String = "yyyy'-'MM'-'dd")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date
    }
    
    func words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = self.components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
}
