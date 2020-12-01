//
//  MeasureListViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Foundation

class ConverterViewModel: ConverterViewModelProtocol {
    
    typealias MeasureViewModel = MeasureListViewModel
    
    @Published var measures: MeasureListViewModel
    
    init() {
        measures = MeasureListViewModel()
    }
}
