//
//  ProductView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import SwiftUI

protocol ProductViewModelProtocol: ObservableObject, Identifiable {
    
    var imageName: String { get }
    var productName: String { get }
    
    var isSelected: Bool { get }
}

struct ProductView<ViewModel: ProductViewModelProtocol>: View {
    
    typealias Colors = Asset.Colors
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        
        if viewModel.isSelected {
            base
                .shadow(
                    color: Color.black.opacity(0.25),
                    radius: 4, x: 4.0, y: 4.0
                )
            
        } else {
            
            base
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(Colors.yellow), lineWidth: 2)
                )
        }
    }
    
    private var base: some View {
        
        ZStack {
            
            Color(viewModel.isSelected ? Colors.yellow : Colors.carouselBackground)
            
            VStack {
                
                IconView(viewModel.imageName)
                
                Text(viewModel.productName)
                    .appFont(weight: .bold, textStyle: .body)
                    .foregroundColor(viewModel.isSelected ? Color.black : Color.primary)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ProductView_Previews: PreviewProvider {
    
    private final class PreviewViewModel: ProductViewModelProtocol {
        
        var imageName: String
        
        var productName: String
        
        var isSelected: Bool
        
        init(isSelected: Bool) {
            self.imageName = "cup"
            self.productName = "Water"
            self.isSelected = isSelected
        }
    }
    
    static var previews: some View {
        
        ProductView(viewModel: PreviewViewModel(isSelected: true))
            .previewLayout(.fixed(width: 130, height: 130))
        
        ProductView(viewModel: PreviewViewModel(isSelected: false))
            .previewLayout(.fixed(width: 130, height: 130))
    }
}
