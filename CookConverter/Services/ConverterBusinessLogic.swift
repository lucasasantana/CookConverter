//
//  ConverterBusinessLogic.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 30/11/20.
//

import Combine
import Foundation

/// Describes an object responsable to deal with all convertions, stream new values and return all avaliable dimensions to convert
protocol ConverterBusinessLogic {
    
    /// All dimensions supported by this converter
    var avaliableDimensions: [Dimension] { get }
    
    /// The current density that is used in conversions
    var density: Double { get }
    
    /// The publisher that stream a Default Measures whenever a conversion is made
    var defaultMeasuresPublisher: AnyPublisher<DefaultMeasures, Never> { get }
    
    /// Perform a conversion from the given volume measure
    /// - Parameters:
    ///   - measure: The value of the measure
    ///   - unit: The volume unit of the measure
    func convert(measure: Double, withUnit unit: UnitVolume)
    
    /// Perform a conversion from the given mass measure
    /// - Parameters:
    ///   - measure: The value of the measure
    ///   - unit: The mass unit of the measure
    func convert(measure: Double, withUnit unit: UnitMass)
    
    /// Updates the density used in conversions
    /// - Parameter newDensity: The new density value
    func update(density newDensity: Double)
}
