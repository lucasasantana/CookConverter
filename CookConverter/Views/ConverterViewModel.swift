//
//  MeasureListViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Foundation

class ConverterViewModel: ConverterViewModelProtocol {
    
    typealias MeasureModel = MeasureListViewModel
    
    typealias ProductModel = ProductListViewModel
    
    @Published var measures: MeasureListViewModel
    
    @Published var products: ProductListViewModel
    
    init() {
        measures = MeasureListViewModel()
        products = ProductListViewModel()
    }
}
