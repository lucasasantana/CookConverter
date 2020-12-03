//
//  ProductListViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import Foundation

class ProductListViewModel: ProductListViewModelProtocol {
    
    typealias ViewModel = ProductViewModel
   
    private(set) var title: String
    
    private(set) var products: [ProductViewModel]
    
    private var selectedIndex: Int
    
    internal init() {
        
        self.title = "Ingredients"
        
        self.products = [
            ProductViewModel(product: Product(name: "água", icon: "cup", density: 1.0), isSelected: true),
            ProductViewModel(product: Product(name: "água", icon: "cup", density: 1.0), isSelected: false),
            ProductViewModel(product: Product(name: "água", icon: "cup", density: 1.0), isSelected: false),
            ProductViewModel(product: Product(name: "água", icon: "cup", density: 1.0), isSelected: false),
            ProductViewModel(product: Product(name: "água", icon: "cup", density: 1.0), isSelected: false),
            ProductViewModel(product: Product(name: "água", icon: "cup", density: 1.0), isSelected: false),
            ProductViewModel(product: Product(name: "água", icon: "cup", density: 1.0), isSelected: false)
        ]
        
        self.selectedIndex = 0
    }
    
    func selectProduct(index: Int) {
        
        guard index < products.count, index != selectedIndex else { return }
        
        products[selectedIndex].isSelected = false
        products[index].isSelected = true
        
        selectedIndex = index
    }
}
