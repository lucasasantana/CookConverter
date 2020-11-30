//
//  MeasureListViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Foundation

class MeasureListViewModel: MeasureListViewModelProtocol {
    
    typealias MeasureViewModel = MeasureListItemViewModel
    
    var measures: [MeasureListItemViewModel]
    
    init(measures: [(name: String, imageName: String)]) {
        self.measures = measures.map {MeasureListItemViewModel(title: $0.name, imageName: $0.imageName)}
    }
}
