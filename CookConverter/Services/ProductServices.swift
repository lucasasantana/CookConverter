//
//  ProductServices.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 07/12/20.
//

import Foundation
import Combine

protocol ProductBusinessLogic {
    
    /// Publisher that stream the product list when changed
    var productsPublisher: AnyPublisher<[Product], Error> { get }
    
    /// Load the of all products
    func retrieveProducts()
}

class ProductServices: ProductBusinessLogic {
    
    /// Subject used to manage the product streams
    var subject: CurrentValueSubject<[Product], Error>
    
    /// Publisher that stream the product list when changed
    var productsPublisher: AnyPublisher<[Product], Error> {
        return subject.eraseToAnyPublisher()
    }
    
    /// Product DAO object
    private var dataStore: ProductDataStore
    
    init(dataStore: ProductDataStore = ProductJSONDataStore()) {
        self.dataStore = dataStore
        self.subject = CurrentValueSubject([])
    }
    
    /// Load the of all products
    func retrieveProducts() {
        
        // Loads async in background
        let blockForExecutionInBackground = { [weak weakSelf = self] in
            guard let strongSelf = weakSelf else { return }
            do {
                
                let products = try strongSelf.dataStore.retrieveProducts()
                
                // Sorts the products alphabetically
                let sorted = products.sorted { (lhs, rhs) -> Bool in
                    let lhsName = lhs.name.folding(options: .diacriticInsensitive, locale: .current)
                    let rhsName = rhs.name.folding(options: .diacriticInsensitive, locale: .current)
                    
                    return lhsName < rhsName
                }
                
                strongSelf.sendValue(sorted)
                
            } catch {
                strongSelf.sendError(error)
            }
        }
        
        executeInBackground(blockForExecutionInBackground)
    }
    
    // MARK: Streams
    
    /// Stream a product list in the main thread
    /// - Parameter value: The product list to be streamed
    private func sendValue(_ value: [Product]) {
        executeInMain { [weak weakSelf = self] in
            weakSelf?.subject.send(value)
        }
    }
    
    /// Stream a error in the main thread
    /// - Parameter error: The error to be streamed
    private func sendError(_ error: Error) {
        executeInMain { [weak weakSelf = self] in
            weakSelf?.subject.send(completion: Subscribers.Completion.failure(error))
        }
    }
    
    // MARK: Block Executions
    
    /// Executes a block in a User Initiated Thread
    /// - Parameter block: Block to be executed
    private func executeInBackground(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            block()
        }
    }
    
    /// Executes a block in the Main Thread
    /// - Parameter block: Block to be executed
    private func executeInMain(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
}
