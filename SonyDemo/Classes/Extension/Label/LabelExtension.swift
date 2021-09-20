//
//  UILabel.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import UIKit

extension UILabel {
    func setHighlighted(_ text: String, with search: String) {
        let attributedText = NSMutableAttributedString(string: text) // 1
        let range = NSString(string: text).range(of: search, options: .caseInsensitive) // 2
        let highlighColor = traitCollection.userInterfaceStyle == .light ? UIColor.systemYellow : UIColor.systemRed // 3
        let highlightedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.backgroundColor: highlighColor] // 4
        
        attributedText.addAttributes(highlightedAttributes, range: range) // 5
        self.attributedText = attributedText // 6
    }
}
