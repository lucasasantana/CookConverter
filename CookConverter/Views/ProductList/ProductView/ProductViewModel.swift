//
//  ProductViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import Foundation

class ProductViewModel: ProductViewModelProtocol, Equatable {
    
    @Published var isSelected: Bool
    
    let imageName: String
    
    let productName: String
    
    let density: Double
    
    init(product: Product, isSelected: Bool) {
        self.imageName = product.icon
        self.productName = product.name.capitalized
        self.isSelected = isSelected
        self.density = product.density
    }
    
    func select() {
        isSelected = true
    }
    
    func deselect() {
        isSelected = false
    }
    
    static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        return lhs.imageName == rhs.imageName &&
               lhs.productName == rhs.productName
    }
}
