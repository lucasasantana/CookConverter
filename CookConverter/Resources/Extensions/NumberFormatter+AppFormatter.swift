//
//  NumberFormatter+AppFormatter.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 27/11/20.
//  Copyright © 2020 LucasAntevere. All rights reserved.

import UIKit

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

/// NumberFormatter specific to Currency Values
class DoubleFormatter: Formatter {
    
    typealias NumberType = Double
    
    private var doubleFormatter: NumberFormatter = NumberFormatter()
    
    public static var appFormatter: DoubleFormatter = DoubleFormatter()
    
    public var localizedZero: String {
        return self.localizedString(from: .zero) ?? "0.00"
    }
    
    public let style: NumberFormatter.Style = .decimal
    
    init(locale: Locale = .current) {
        self.doubleFormatter.numberStyle = style
        self.doubleFormatter.locale = locale
        self.doubleFormatter.maximumFractionDigits = 2
        self.doubleFormatter.minimumFractionDigits = 2
    }
    
    public func localizedString(from number: Double) -> String? {
        return self.doubleFormatter.string(from: number.value)
    }
    
    public func value(fromLocalizedString value: String) -> Double? {
        return self.doubleFormatter.number(from: value)?.doubleValue
    }
}
