//
//  AppUnit.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 30/11/20.
//

import Foundation

struct AppDimension {
 
    let iconName: String
    let unit: AppUnit
    
    let valueType: AppDimensionValueType
}
enum AppDimensionValueType {
    case proportional
    case numeric
}

enum AppUnit {
    
    case mass(unit: UnitMass)
    case volume(unit: UnitVolume)
}
