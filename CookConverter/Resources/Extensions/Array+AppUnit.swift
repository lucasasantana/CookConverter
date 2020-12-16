//
//  Array+AppUnit.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 16/12/20.
//

import Foundation

enum MassOrVolumeUnit {
    case mass(unit: UnitMass)
    case volume(unit: UnitVolume)
}

extension Array where Element == Dimension {
    
    func compactMapToMassOrVolume() -> [MassOrVolumeUnit] {
        
        self.compactMap { (dimension) -> MassOrVolumeUnit? in
            
            if let mass = dimension as? UnitMass {
                return .mass(unit: mass)
                
            } else if let volume = dimension as? UnitVolume {
                return .volume(unit: volume)
            }
            
            return nil
        }
    }
}
