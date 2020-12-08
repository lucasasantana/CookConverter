//
//  SwiftUIView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import SwiftUI

protocol ProductListViewModelProtocol: ObservableObject {
    
    associatedtype ViewModel: ProductViewModelProtocol
    
    var title: String { get }
    
    var products: [ViewModel] { get }
    
    func selectProduct(product: ViewModel)
}

struct ProductListView<ViewModel: ProductListViewModelProtocol>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    private var horizontalPadding: CGFloat
    
    init(viewModel: ViewModel, horizontalPadding: CGFloat = 0.0) {
        self.viewModel = viewModel
        self.horizontalPadding = horizontalPadding
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text(viewModel.title)
                .multilineTextAlignment(.leading)
                .appFont(weight: .semibold, textStyle: .largeTitle)
                .padding(.leading, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(alignment: .center, spacing: 16) {
                    
                    paddingSpacer()
                    
                    ForEach(viewModel.products) { product in
                        
                        ProductView(viewModel: product)
                            .aspectRatio(1.5, contentMode: .fit)
                            .fixedSize(horizontal: false, vertical: false)
                            .onTapGesture {
                                self.viewModel.selectProduct(product: product)
                            }
                    }
                    
                    paddingSpacer()
                }
                .padding(.vertical)
            }
        }
    }
    
    private func paddingSpacer() -> some View {
        
        let width = horizontalPadding > 16 ? horizontalPadding - 16 : .zero
        
        return Spacer()
            .frame(width: width)
    }
    
    func horizontalPadding(_ padding: CGFloat) -> some View {
        
        var view = self
        
        view.horizontalPadding = padding
        
        return view
    }
}

struct ProductListView_Previews: PreviewProvider {
    
    private final class PreviewViewModel: ProductListViewModelProtocol {
       
        typealias ViewModel = ProductViewModel
        
        var title: String
        
        var products: [ProductViewModel]
        
        internal init() {
            
            self.title = "Ingredients"
            
            self.products = [
                
                ProductViewModel(product: Product(name: "Water", icon: "cup", density: 1.0), isSelected: true),
                ProductViewModel(product: Product(name: "Sugar", icon: "cup", density: 1.0), isSelected: false),
                ProductViewModel(product: Product(name: "Rice", icon: "cup", density: 1.0), isSelected: false),
                ProductViewModel(product: Product(name: "Sugar", icon: "cup", density: 1.0), isSelected: false),
                ProductViewModel(product: Product(name: "Rice", icon: "cup", density: 1.0), isSelected: false)]
        }
        
        func selectProduct(product: ProductViewModel) {}
    }
    
    static var previews: some View {
        ProductListView(viewModel: PreviewViewModel())
            .previewLayout(.fixed(width: 414, height: 250))
    }
}
