//
//  Formatter.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import Foundation

/// Describes a object as a number that is bridged to NSNumber
protocol Number {
    static var zero: Self { get }
    
    var value: NSNumber { get }
}

extension Double: Number {
    var value: NSNumber {
        return NSNumber(value: self)
    }
}

/// Describes a Number Formatter
protocol Formatter {
    
    associatedtype NumberType: Number
    
    var localizedZero: String { get }
    
    func localizedString(from number: NumberType) -> String?
    func value(fromLocalizedString value: String) -> NumberType?
}
