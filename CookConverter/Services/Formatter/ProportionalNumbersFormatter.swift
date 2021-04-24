//
//  ProportionalNumbersServices.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import Foundation

/// Describes a Formatter that convert fractions to Number
protocol FractionNumbersFormatter: Formatter {
    
    /// The Integer and Decimal parts avaliable on this formatter
    var avaliableNumbers: [[String]] { get }
    
    /// The indexes of the avaliable numbers based on a given number
    /// - Parameter number: The number to be evaluated
    func indexes(from number: NumberType) -> (integer: Int, decimal: Int)
    
    /// Converts the pair of indexes into a full string
    /// - Parameter indexes: The indexes of the avaliableNumbers attribute
    func localizedString(indexes: (integer: Int, decimal: Int)) -> String?
    
    /// Converts the pair of indexes into a number
    /// - Parameter indexes: The indexes of the avaliableNumbers attribute
    func value(indexes: (integer: Int, decimal: Int)) -> NumberType?
}

class ProportionalNumbersFormatter: FractionNumbersFormatter {
    
    typealias NumberType = Double
    
    var localizedZero: String {
        return "0"
    }
    
    private(set) var avaliableNumbers: [[String]]
    
    private var doubleFormatter: DoubleFormatter
    
    static let appFormatter: ProportionalNumbersFormatter = ProportionalNumbersFormatter()
    
    init(formatter: DoubleFormatter = .appFormatter) {
        self.doubleFormatter = formatter
        self.avaliableNumbers = [(0...500 ).map {String($0)}, ["0", "1/4", "1/3", "1/2", "2/3", "3/4"]]
    }
    
    func value(fromLocalizedString value: String) -> Double? {
        return computeFromFraction(string: value)
    }
    
    func value(indexes: (integer: Int, decimal: Int)) -> Double? {
        
        guard let string = self.localizedString(indexes: indexes) else {
            return nil
        }
        
        return self.value(fromLocalizedString: string)
    }
    
    func localizedString(indexes: (integer: Int, decimal: Int)) -> String? {
        
        guard
            
            indexes.integer < avaliableNumbers[0].count,
            indexes.decimal < avaliableNumbers[1].count
        
        else {
            return nil
        }
        
        let value: ProportionalNumber
        
        let integerPart = avaliableNumbers[0][indexes.integer]
        let decimalPart = avaliableNumbers[1][indexes.decimal]
        
        if integerPart != "0" && decimalPart != "0" {
            value =  .integerAndDecimal(integer: integerPart, decimal: decimalPart)
            
        } else if integerPart == "0" && decimalPart != "0" {
            value = .decimal(value: decimalPart)
            
        } else {
            value = .integer(value: integerPart)
        }
        
        return value.localizedString()
    }
    
    func localizedString(from number: Double) -> String? {
        return numberComponents(number: number).localizedString()
    }
    
    func indexes(from number: Double) -> (integer: Int, decimal: Int) {
        
        switch self.numberComponents(number: number) {
            
            case .integer(let value):
                return (elementIndex(column: 0, string: value) ?? .zero, .zero)
                
            case .decimal(let value):
                return (.zero, elementIndex(column: 1, string: value) ?? .zero)
                
            case .integerAndDecimal(let integerPart, let decimalPart):
                
                if let int = elementIndex(column: 0, string: integerPart),
                   let dec = elementIndex(column: 1, string: decimalPart) {
                    return (int, dec)
                }
                
                return (.zero, .zero)
        }
    }
    
    private func elementIndex(column: Int, string: String) -> Int? {
        return avaliableNumbers[column].firstIndex(of: string)
    }
    
    private func numberComponents(number: Double) -> ProportionalNumber {
        
        let integerPart = String(Int(number))
        let decimalPart: String
        
        let decimal = number.truncatingRemainder(dividingBy: 1)
        
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
                return .integer(value: String(Int(number + 1.0)))
                
            default:
                return .integer(value: integerPart)
        }
        
        if integerPart == "0" {
            return .decimal(value: decimalPart)
        }

        return .integerAndDecimal(integer: integerPart, decimal: decimalPart)
    }
    
    private func computeFromFraction(string: String) -> Double? {
        
        var integerValue: String
        var decimalValue: String
        
        let text = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let integerAndDecimalParts = text.components(separatedBy: " ")
        
        switch integerAndDecimalParts.count {
            
            case 1:
                integerValue = "0"
                decimalValue = integerAndDecimalParts[0]
                
            case 2:
                
                integerValue = integerAndDecimalParts[0]
                decimalValue = integerAndDecimalParts[1]
                
            case 3:
                
                integerValue = integerAndDecimalParts[0]
                decimalValue = integerAndDecimalParts[2]
                
            default:
                return nil
        }
        
        let doubleDecimalValue: Double
        let doubleIntegerValue: Double = doubleValue(from: integerValue)
        
        let decimalComps = decimalValue.components(separatedBy: "/")
        
        switch decimalComps.count {
            
            case 1:
                doubleDecimalValue = doubleValue(from: decimalComps[0])
                
            case 2:
                
                let upper = doubleValue(from: decimalComps[0])
                let lower = doubleValue(from: decimalComps[1])
                
                guard lower != .zero else {
                    return nil
                }
                
                doubleDecimalValue = upper/lower
                
            default:
                return nil
        }
        
        return doubleIntegerValue + doubleDecimalValue
    }
    
    private func doubleValue(from string: String) -> Double {
        return doubleFormatter.value(fromLocalizedString: string) ?? .zero
    }
}
