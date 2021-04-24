//
//  MeasurementFormatter.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 30/11/20.
//

import Foundation

/// A Number Formatter that can also convert an unit
protocol MeasureFormatter: Formatter {
    func localizedString(from unit: Unit) -> String
}

struct AppMeasureFormatter: MeasureFormatter {
    
    typealias NumberType = Double
    
    private var doubleFormatter: DoubleFormatter
    private var measurementFormatter: MeasurementFormatter
    
    static let appFormatter = AppMeasureFormatter()
    
    var localizedZero: String {
        return doubleFormatter.localizedZero
    }
    
    init(locale: Locale = .current) {
        
        self.doubleFormatter = DoubleFormatter(locale: locale)
        
        self.measurementFormatter = MeasurementFormatter()
        self.measurementFormatter.locale = locale
        self.measurementFormatter.unitStyle = .long
    }
    
    func localizedString(from number: Double) -> String? {
        return doubleFormatter.localizedString(from: number)
    }
    
    func value(fromLocalizedString value: String) -> Double? {
        return doubleFormatter.value(fromLocalizedString: value)
    }
    
    func localizedString(from unit: Unit) -> String {
        return measurementFormatter.string(from: unit)
    }
}
