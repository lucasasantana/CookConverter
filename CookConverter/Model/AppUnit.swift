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

enum AppUnit: Equatable {
    
    case mass(unit: UnitMass)
    case volume(unit: UnitVolume)
    
    static func == (lhs: AppUnit, rhs: AppUnit) -> Bool {
        
        switch lhs {
            
            case .mass(let lhsMassUnit):
                
                if case AppUnit.mass(let rhsMassUnit) = rhs {
                    return lhsMassUnit == rhsMassUnit
                    
                } else {
                    return false
                }
                
            case .volume(let lhsVolumeUnit):
                
                if case AppUnit.volume(let rhsVolumeUnit) = rhs {
                    return lhsVolumeUnit == rhsVolumeUnit
                    
                } else {
                    return false
                }
        }
    }
}
