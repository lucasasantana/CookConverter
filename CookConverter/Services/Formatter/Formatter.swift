//
//  Formatter.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import Foundation

protocol Number {
    
    static var zero: Self { get }
    
    var value: NSNumber { get }
}

extension Double: Number {
    
    var value: NSNumber {
        return NSNumber(value: self)
    }
}

protocol Formatter {
    
    associatedtype NumberType: Number
    
    var localizedZero: String { get }
    
    func localizedString(from number: NumberType) -> String?
    
    func value(fromLocalizedString value: String) -> NumberType?
}
