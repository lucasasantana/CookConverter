//
//  MeasureListItemViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Combine

class MeasureListItemViewModel: MeasureListItemViewModelProtocol {
    
    @Published var isEditing: Bool
    
    @Published var imageName: String
    
    @Published var title: String
    
    @Published var number: String
    
    init(
        title: String,
        imageName: String,
        number: String = DoubleFormatter.appFormatter.localizedZero,
        isEditing: Bool = false
    ) {
    
        self.title = title
        self.imageName = imageName
        self.isEditing = isEditing
        self.number = number
    }
    
    func setNumber(_ value: String) {
        self.number = value.doubleInputFormatting()
    }
}
