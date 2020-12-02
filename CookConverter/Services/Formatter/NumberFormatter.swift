//
//  NumberFormatter+AppFormatter.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 27/11/20.
//  Copyright © 2020 LucasAntevere. All rights reserved.

import UIKit

import Foundation

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
