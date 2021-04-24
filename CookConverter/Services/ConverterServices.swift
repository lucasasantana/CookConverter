//
//  ConverterServices.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Foundation
import Combine

/// The app converter
class ConverterServices: ConverterBusinessLogic, MeasurementBusinessLogic {
   
    /// All dimensions supported by this converter
    let avaliableDimensions: [Dimension] = [
        UnitMass.grams,
        UnitMass.kilograms,
        UnitVolume.tablespoons,
        UnitVolume.teaspoons,
        UnitVolume.cups,
        UnitVolume.milliliters,
        UnitVolume.liters,
        UnitMass.pounds,
        UnitMass.ounces
    ]
    
    /// The current app default measures
    private var defaultMeasurements: AppDefaultMeasures
    
    /// The subject that stream a Default Measures whenever a conversion is made
    private var subject: CurrentValueSubject<DefaultMeasures, Never>
    
    /// The publisher that stream a Default Measures whenever a conversion is made
    var defaultMeasuresPublisher: AnyPublisher<DefaultMeasures, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    /// Describes the nature of the unit
    enum UnitType {
        case mass
        case volume
    }
    
    /// The type of the unit of the last convert call
    private(set) var lastSelectedUnitType: UnitType
    
    /// The density used in the convertions
    private(set) var density: Double
    
    init(initialDensity: Double = 1.0) {
        
        lastSelectedUnitType = .mass
        defaultMeasurements = AppDefaultMeasures()
        
        density = initialDensity
        subject = CurrentValueSubject(defaultMeasurements)
    }
    
    /// Perform a conversion from the given volume measure
    /// - Parameters:
    ///   - measure: The value of the measure
    ///   - unit: The volume unit of the measure
    func convert(measure: Double, withUnit unit: UnitVolume) {
        
        self.lastSelectedUnitType = .volume
        
        let defaultVolume = defaultMeasurements.volume
        
        let receivedVolumeMeasure = Measurement(
            value: measure,
            unit: unit
        ).converted(to: defaultVolume.unit)
        
        defaultMeasurements.updateVolume(value: receivedVolumeMeasure.value)
        
        let massValue: Double = defaultMeasurements.volume.value * density
        
        defaultMeasurements.updateMass(value: massValue)
        subject.send(defaultMeasurements)
    }
    
    /// Perform a conversion from the given mass measure
    /// - Parameters:
    ///   - measure: The value of the measure
    ///   - unit: The mass unit of the measure
    func convert(measure: Double, withUnit unit: UnitMass) {
        
        self.lastSelectedUnitType = .mass
        
        let defaultMass = defaultMeasurements.mass
        
        let receivedMassMeasure = Measurement(
            value: measure,
            unit: unit
        ).converted(to: defaultMass.unit)
        
        defaultMeasurements.updateMass(value: receivedMassMeasure.value)
        
        let volumeValue: Double
        
        // If the current density is zero, the volume value is also zero
        if density == .zero {
            volumeValue = .zero
            
        } else {
            volumeValue = defaultMeasurements.mass.value / density
        }
        
        defaultMeasurements.updateVolume(value: volumeValue)
        
        subject.send(defaultMeasurements)
    }
    
    /// Updates the density used in conversions
    /// - Parameter newDensity: The new density value
    func update(density newDensity: Double) {
        
        self.density = newDensity
        
        // Updates current measures, mantaining the nature of the last selected unit
        switch lastSelectedUnitType {
            case .mass:
                convert(
                    measure: defaultMeasurements.mass.value,
                    withUnit: defaultMeasurements.mass.unit
                )
                
            case .volume:
                convert(
                    measure: defaultMeasurements.volume.value,
                    withUnit: defaultMeasurements.volume.unit
                )
        }
    }
}
