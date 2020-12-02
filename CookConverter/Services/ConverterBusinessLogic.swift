//
//  ConverterBusinessLogic.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 30/11/20.
//

import Combine
import Foundation

protocol ConverterBusinessLogic {
    
    var avaliableMassUnits: [UnitMass] { get }
    var avaliableVolumeUnits: [UnitVolume] { get }
    
    var density: Double { get }
    
    var defaultMeasuresPublisher: AnyPublisher<DefaultMeasures, Never> { get }
    
    func convert(measure: Double, withUnit unit: UnitVolume)
    func convert(measure: Double, withUnit unit: UnitMass)
    
    func update(product newProduct: Product)
}