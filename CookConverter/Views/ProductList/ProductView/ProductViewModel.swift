//
//  ProductViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import Foundation

class ProductViewModel: ProductViewModelProtocol {
    
    @Published var isSelected: Bool
    
    var imageName: String
    
    var productName: String
    
    init(product: Product, isSelected: Bool) {
        self.imageName = product.icon
        self.productName = product.name.capitalized
        self.isSelected = isSelected
    }
    
    func select() {
        isSelected = true
    }
    
    func deselect() {
        isSelected = false
    }
}
