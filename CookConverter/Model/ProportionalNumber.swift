//
//  ProportionalNumber.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import Foundation

enum ProportionalNumber {
    
    case integer(value: String)
    case decimal(value: String)
    case integerAndDecimal(integer: String, decimal: String)
    
    func localizedString() -> String {
        
        switch self {
            
            case .integer(let value), .decimal(let value):
                return value
                
            case .integerAndDecimal(let integerPart, let decimalPart):
                return "\(integerPart) & \(decimalPart)"
        }
    }
}
