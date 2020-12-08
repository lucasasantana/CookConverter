//
//  ProductListViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import Foundation
import Combine

class ProductListViewModel: ProductListViewModelProtocol {
    
    typealias ViewModel = ProductViewModel
   
    private(set) var title: String
    
    @Published private(set) var products: [ProductViewModel]
    
    private(set) var selectedIndex: Int
    
    private var productServices: ProductBusinessLogic
    private var converterServices: ConverterBusinessLogic
    
    private var subscribers: Set<AnyCancellable>
    
    internal init(
        converterServices: ConverterBusinessLogic,
        productServices: ProductBusinessLogic = ProductServices()
    ) {
        
        self.title = L10n.ingredients.capitalized
        
        self.products = []
        
        self.productServices = productServices
        self.converterServices = converterServices
        
        self.selectedIndex = 0
        
        self.subscribers = Set()
        
        self.configureSubscribers()
    }
    
    func configureSubscribers() {
        
        // swiftlint:disable no_space_in_method_call multiple_closures_with_trailing_closure
        
        self.productServices.productsPublisher.sink { (error) in
            NSLog("Unsolved error at Product List View Model: \(error)")
            
        } receiveValue: { (products) in
            self.products = products.enumerated().map {ProductViewModel(product: $0.element, isSelected: $0.offset == .zero)}
            
            if let first = self.products.first {
                self.selectProduct(product: first)
            }
            
        }
        .store(in: &subscribers)
        
        self.productServices.retrieveProducts()
        
        // swiftlint:enable no_space_in_method_call multiple_closures_with_trailing_closure
    }
    
    func selectProduct(product: ProductViewModel) {
        
        guard
            let index = products.enumerated().first(where: { $0.element == product })?.offset,
            index < products.count, index != selectedIndex
        else { return }
        
        products[selectedIndex].isSelected = false
        products[index].isSelected = true
        
        selectedIndex = index
        
        let newDensity = products[index].density
        
        self.converterServices.update(density: newDensity)
    }
}
