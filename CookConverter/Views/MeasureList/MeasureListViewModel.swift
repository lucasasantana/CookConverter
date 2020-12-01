//
//  MeasureListViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Foundation

class MeasureListViewModel: MeasureListViewModelProtocol {
    
    var title: String
    
    typealias MeasureViewModel = MeasureListItemViewModel
    
    var measures: [MeasureListItemViewModel]
    
    init(
        businessLogic: (ConverterBusinessLogic & MeasurementItemBusinessLogic) = ConverterServices(product: Product(name: "Water", density: 1.0)),
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
        
        title = "Measures"
        
        measures = appDimensions
            .map {
                MeasureListItemViewModel(measureFormatter: formatter, businessLogic: businessLogic, dimension: $0)
            }
            .sorted {$0.title < $1.title }
    }
}
