//
//  ItemViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Combine

class ItemViewModel: VerticalListItemViewModelProtocol {
    
    @Published var isEditing: Bool = false
    
    @Published var imageName: String = "cup"
    
    @Published var title: String = "Cup"
    
    @Published var number: String = "0.0"
    
    func setNumber(_ value: String) {
        self.number = value.doubleInputFormatting()
    }
}
