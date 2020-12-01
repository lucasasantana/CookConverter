//
//  Double+Fraction.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 30/11/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

extension Double {
    
    var fractionStringComponents: (integer: String?, decimal: String?) {
        
        let integerPart = String(Int(self))
        let decimalPart: String
        
        let decimal = self.truncatingRemainder(dividingBy: 1)
        
        switch decimal {
            
            case 0...0.25 where decimal != 0:
                decimalPart = "1/4"
                
            case 0.25...0.34 where decimal > 0.25:
                decimalPart = "1/3"
                
            case 0.34...0.5 where decimal > 0.34:
                decimalPart = "1/2"
                
            case 0.5...0.67 where decimal > 0.5:
                decimalPart = "2/3"
                
            case 0.67...0.75 where decimal > 0.67:
                decimalPart = "3/4"
                
            case 0.75...1.0 where decimal > 0.75:
                return (String(Int(self + 1.0)), nil)
                
            default:
                return (integerPart, nil)
        }
    
        if integerPart == "0" {
            return (nil, decimalPart)
        }
        
        return (integerPart, decimalPart)
    }
}
