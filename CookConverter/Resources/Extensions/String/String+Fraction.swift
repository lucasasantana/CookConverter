//
//  String+Fraction.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

extension String {
    
    var doubleValue: Double {
        return NSString(string: self).doubleValue
    }
    
    var fractionValue: Double {
        return self.computeFromFraction()
    }
    
    private func computeFromFraction() -> Double {
        
        var integerValue: String
        var decimalValue: String
        
        let text = self.trimmingCharacters(in: .whitespacesAndNewlines)
    
        let integerAndDecimalParts = text.components(separatedBy: " ")
        
        switch integerAndDecimalParts.count {
            
            case 1:
                integerValue = "0"
                decimalValue = integerAndDecimalParts[0]
                
            case 2:
                
                integerValue = integerAndDecimalParts[0]
                decimalValue = integerAndDecimalParts[1]
                
            default:
                return .zero
        }
        
        let doubleDecimalValue: Double
        let doubleIntegerValue: Double = integerValue.doubleValue
        
        let decimalComps = decimalValue.components(separatedBy: "/")
        
        switch decimalComps.count {
            
            case 1:
                doubleDecimalValue = decimalComps[0].doubleValue
                
            case 2 where decimalComps[1].doubleValue != .zero:
                doubleDecimalValue = decimalComps[0].doubleValue/decimalComps[1].doubleValue
                
            default:
                return .zero
        }
        
        return doubleIntegerValue + doubleDecimalValue
    }
}
