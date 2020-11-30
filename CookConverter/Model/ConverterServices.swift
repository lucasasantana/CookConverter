//
//  ConverterServices.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Foundation
import Combine

protocol ConverterBusinessLogic {
    
    var avaliableMassUnits: [UnitMass] { get }
    var avaliableVolumeUnits: [UnitVolume] { get }
    
    var density: Double { get }
    
    func publisher(for dimension: Dimension) -> AnyPublisher<Double, Never>?
    
    func convert(measure: Double, withUnit unit: UnitVolume)
    func convert(measure: Double, withUnit unit: UnitMass)
}

class ConverterServices: ConverterBusinessLogic {
    
    let avaliableMassUnits: [UnitMass] = [.grams, .kilograms, .pounds, .ounces]
    let avaliableVolumeUnits: [UnitVolume] = [.liters, .milliliters, .teaspoons, .tablespoons]
    
    private var defaultMassMeasurement: Measurement<UnitMass> {
        didSet {
            massSubject.send(defaultMassMeasurement.value)
        }
    }
    private var defaultVolumeMeasurement: Measurement<UnitVolume> {
        didSet {
            volumeSubject.send(defaultVolumeMeasurement.value)
        }
    }
    
    private var massSubject: CurrentValueSubject<Double, Never>
    private var volumeSubject: CurrentValueSubject<Double, Never>
    
    enum UnitType {
        case mass
        case volume
    }
    
    private var lastSelectedUnitType: UnitType
    
    var density: Double
    
    init(product: Product) {
        
        lastSelectedUnitType = .mass
        
        defaultMassMeasurement = Measurement(value: .zero, unit: .grams)
        defaultVolumeMeasurement = Measurement(value: .zero, unit: .cubicCentimeters)
        
        density = product.density
        
        massSubject = CurrentValueSubject(.zero)
        volumeSubject = CurrentValueSubject(.zero)
    }
    
    func convert(measure: Double, withUnit unit: UnitVolume) {
        
        let receivedVolumeMeasure = Measurement(value: measure, unit: unit)
        
        defaultVolumeMeasurement = receivedVolumeMeasure.converted(to: defaultVolumeMeasurement.unit)
        
        let massValue: Double = measure * density
        
        defaultMassMeasurement = Measurement(value: massValue, unit: defaultMassMeasurement.unit)
    }
    
    func convert(measure: Double, withUnit unit: UnitMass) {
        
        let receivedMassMeasure = Measurement(value: measure, unit: unit)
        
        defaultMassMeasurement = receivedMassMeasure.converted(to: defaultMassMeasurement.unit)
        
        let volumeValue: Double
        
        if density == .zero {
            volumeValue = .zero
            
        } else {
            volumeValue = measure / density
        }
        
        defaultVolumeMeasurement = Measurement(value: volumeValue, unit: defaultVolumeMeasurement.unit)
    }
    
    func publisher(for dimension: Dimension) -> AnyPublisher<Double, Never>? {
        
        let subject: CurrentValueSubject<Double, Never>
        
        switch dimension {
            
            case is UnitVolume:
                subject = volumeSubject
            
            case is UnitMass:
                subject = massSubject
                
            default:
                return nil
        }
        
        return subject.eraseToAnyPublisher()
    }
}
