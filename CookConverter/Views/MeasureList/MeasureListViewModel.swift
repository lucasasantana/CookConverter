//
//  MeasureListViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Foundation

class MeasureListViewModel: MeasureListViewModelProtocol {
    
    var title: String
    
    typealias ViewModel = MeasureViewModel
    
    var measures: [MeasureViewModel]
    
    init(
        businessLogic: (ConverterBusinessLogic & MeasurementBusinessLogic),
        formatter: AppMeasureFormatter = .appFormatter
    ) {
        
        measures = businessLogic.avaliableDimensions
            .compactMapToMassOrVolume()
            .map({ unit -> MeasureViewModel in
                
                let dimension: AppDimension
                
                switch unit {
                    
                    case .volume(let volumeUnit) where
                            volumeUnit == UnitVolume.tablespoons ||
                            volumeUnit == UnitVolume.teaspoons ||
                            volumeUnit == UnitVolume.cups:
                        dimension = AppDimension(iconName: "cup", unit: .volume(unit: volumeUnit), valueType: .proportional)
                        
                    case .volume(let volumeUnit):
                        dimension = AppDimension(iconName: "cup", unit: .volume(unit: volumeUnit), valueType: .numeric)
                        
                    case .mass(unit: let unitMass):
                        dimension = AppDimension(iconName: "cup", unit: .mass(unit: unitMass), valueType: .numeric)
                }
                
                return MeasureViewModel(measureFormatter: formatter, businessLogic: businessLogic, dimension: dimension)
            })
        
        title = AppStrings.Common.measures.capitalized
        
    }
}
