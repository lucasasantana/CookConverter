//
//  String+NumberFormat.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 27/11/20.
//  Copyright © 2020 LucasAntevere. All rights reserved.

import Foundation

extension String {
    
    func removeLast() -> String {
        String(self.dropLast())
    }
    
    func doubleInputFormatting(formatter: DoubleFormatter = .appFormatter) -> String {
        
        var amountWithPrefix = self
        
        // Remove from String: "$", ".", ","
        guard let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive) else {
            return formatter.localizedZero
        }
        
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix,
                                                          options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                          range: NSRange(location: 0, length: self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        let number = double / 100
        
        // If first number is 0 or all numbers were deleted
        guard number != .zero else {
            return formatter.localizedZero
        }
        
        return formatter.localizedString(from: number) ?? formatter.localizedZero
    }
    
    func toDouble(formatter: DoubleFormatter = .appFormatter) -> Double {
        formatter.value(fromLocalizedString: self) ?? .zero
    }
}
