//
//  DefaultMeasures.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 30/11/20.
//

import Foundation

protocol DefaultMeasures {
    var mass: Measurement<UnitMass> { get }
    var volume: Measurement<UnitVolume> { get }
}

struct AppDefaultMeasures: DefaultMeasures {
    
    private(set) var mass: Measurement<UnitMass>
    private(set) var volume: Measurement<UnitVolume>
    
    init(massUnit: UnitMass = .grams, volumeUnit: UnitVolume = .cubicCentimeters) {
        mass = Measurement(value: .zero, unit: massUnit)
        volume = Measurement(value: .zero, unit: volumeUnit)
    }
    
    mutating func updateMass(value: Double) {
        self.mass.value = value
    }
    
    mutating func updateVolume(value: Double) {
        self.volume.value = value
    }
}
