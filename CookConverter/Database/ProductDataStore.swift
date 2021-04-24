//
//  ProductDataStore.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 07/12/20.
//

import Foundation

/// Describres a DAO for the Product object type
protocol ProductDataStore {
    
    /// Loads the list of avaliable products
    func retrieveProducts() throws -> [Product]
}

enum ProductDataStoreError: Error {
    case invalidFile
}
