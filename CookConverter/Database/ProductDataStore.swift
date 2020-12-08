//
//  ProductDataStore.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 07/12/20.
//

import Foundation

struct ProductJSONEntity: Codable {
    
    let name: String
    let density: Double
}

protocol ProductDataStore {
    func retrieveProducts() throws -> [Product]
}

enum ProductDataStoreError: Error {
    case invalidFile
}

class ProductJSONDataStore: ProductDataStore {
    
    func retrieveProducts() throws -> [Product] {
        
        guard let path = Bundle.main.path(forResource: "products", ofType: "json") else {
            throw ProductDataStoreError.invalidFile
        }
        
        let productsURL = URL(fileURLWithPath: path)
        
        let productsData = try Data(contentsOf: productsURL)
        
        let productsEntities = try JSONDecoder().decode([ProductJSONEntity].self, from: productsData)
        
        return productsEntities
            .map {
                
                let localizedName = Bundle.main.localizedString(forKey: $0.name, value: $0.name, table: "Products")
                let iconName = $0.name.folding(options: .diacriticInsensitive, locale: .current)
                
                return Product(name: localizedName, icon: iconName, density: $0.density)
            }
    }
}
