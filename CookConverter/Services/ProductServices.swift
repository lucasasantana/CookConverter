//
//  ProductServices.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 07/12/20.
//

import Foundation
import Combine

protocol ProductBusinessLogic {
    
    var productsPublisher: AnyPublisher<[Product], Error> { get }
    
    func retrieveProducts()
}

class ProductServices: ProductBusinessLogic {
    
    var subject: CurrentValueSubject<[Product], Error>
    
    var productsPublisher: AnyPublisher<[Product], Error> {
        return subject.eraseToAnyPublisher()
    }
    
    private var dataStore: ProductDataStore
    
    init(dataStore: ProductDataStore = ProductJSONDataStore()) {
        self.dataStore = dataStore
        self.subject = CurrentValueSubject([])
    }
    
    func retrieveProducts() {
        
        let blockForExecutionInBackground = {
            
            do {
                
                let products = try self.dataStore.retrieveProducts()
                
                let sorted = products.sorted { (lhs, rhs) -> Bool in
                    
                    let lhsName = lhs.name.folding(options: .diacriticInsensitive, locale: .current)
                    let rhsName = rhs.name.folding(options: .diacriticInsensitive, locale: .current)
                    
                    return lhsName < rhsName
                }
                
                self.sendValue(sorted)
                
            } catch {
                self.sendError(error)
            }
        }
        
        self.executeInBackground(blockForExecutionInBackground)
    }
    
    private func executeInBackground(_ block: @escaping () -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
           block()
        }
    }
    
    private func sendValue(_ value: [Product]) {
        self.executeInMain {
            self.subject.send(value)
        }
    }
    
    private func sendError(_ error: Error) {
        self.executeInMain {
            self.subject.send(completion: Subscribers.Completion.failure(error))
        }
    }
    
    private func executeInMain(_ block: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            block()
        }
    }
}
