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
        
        var appDimensions = businessLogic.avaliableVolumeUnits.map { unit -> AppDimension in
            
            let valueType: AppDimensionValueType
            
            switch unit {
                
                case UnitVolume.tablespoons, UnitVolume.teaspoons:
                    valueType = .proportional
                    
                default:
                    valueType = .numeric
            }
            
            return AppDimension(iconName: "cup", unit: .volume(unit: unit), valueType: valueType)
        }
        
        appDimensions += businessLogic.avaliableMassUnits.map {
            AppDimension(iconName: "cup", unit: .mass(unit: $0), valueType: .numeric)
        }
        
        measures = []
        
        title = L10n.measures.capitalized
        
        measures = appDimensions
            .map {
                MeasureViewModel(measureFormatter: formatter, businessLogic: businessLogic, dimension: $0)
            }
            .sorted {$0.title < $1.title }
    }
}
