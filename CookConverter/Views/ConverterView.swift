//
//  MeasureListView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 26/11/20.
//

import SwiftUI

protocol ConverterViewModelProtocol: ObservableObject {
    
    associatedtype MeasureModel: MeasureListViewModelProtocol
    associatedtype ProductModel: ProductListViewModelProtocol
    
    var products: ProductModel { get }
    var measures: MeasureModel { get }
}

struct ConverterView<ViewModel: ConverterViewModelProtocol>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            
        ZStack {
            
            Color(Colors.defaultBackground)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                
                Spacer()
                    .frame(height: 40)
                
                ProductListView(viewModel: viewModel.products)
                    .horizontalPadding(20)
                
                MeasureListView(viewModel: viewModel.measures)
                    .horizontalPadding(20)
                
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ConverterView(viewModel: ConverterViewModel())
    }
}
