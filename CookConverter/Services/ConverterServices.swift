//
//  ConverterServices.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Foundation
import Combine

class ConverterServices: ConverterBusinessLogic, MeasurementItemBusinessLogic {
    
    let avaliableMassUnits: [UnitMass] = [.grams, .kilograms, .pounds, .ounces]
    let avaliableVolumeUnits: [UnitVolume] = [.liters, .milliliters, .teaspoons, .tablespoons]
    
    private var defaultMeasurements: AppDefaultMeasures
    
    private var subject: CurrentValueSubject<DefaultMeasures, Never>
    
    var defaultMeasuresPublisher: AnyPublisher<DefaultMeasures, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    enum UnitType {
        case mass
        case volume
    }
    
    private(set) var lastSelectedUnitType: UnitType
    
    private(set) var density: Double
    
    init(product: Product) {
        
        lastSelectedUnitType = .mass
        
        defaultMeasurements = AppDefaultMeasures()
        
        density = product.density
        
        subject = CurrentValueSubject(defaultMeasurements)
    }
    
    func convert(measure: Double, withUnit unit: UnitVolume) {
        
        self.lastSelectedUnitType = .volume
        
        let defaultVolume = defaultMeasurements.volume
        
        let receivedVolumeMeasure = Measurement(value: measure, unit: unit).converted(to: defaultVolume.unit)
        
        defaultMeasurements.updateVolume(value: receivedVolumeMeasure.value)
        
        let massValue: Double = defaultMeasurements.volume.value * density
        
        defaultMeasurements.updateMass(value: massValue)
        
        subject.send(defaultMeasurements)
    }
    
    func convert(measure: Double, withUnit unit: UnitMass) {
        
        self.lastSelectedUnitType = .mass
        
        let defaultMass = defaultMeasurements.mass
        
        let receivedMassMeasure = Measurement(value: measure, unit: unit).converted(to: defaultMass.unit)
        
        defaultMeasurements.updateMass(value: receivedMassMeasure.value)
        
        let volumeValue: Double
        
        if density == .zero {
            volumeValue = .zero
            
        } else {
            volumeValue = defaultMeasurements.mass.value / density
        }
        
        defaultMeasurements.updateVolume(value: volumeValue)
        
        subject.send(defaultMeasurements)
    }
    
    func update(product newProduct: Product) {
        
        self.density = newProduct.density
        
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