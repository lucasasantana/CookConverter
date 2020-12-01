//
//  MeasureListView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 26/11/20.
//

import SwiftUI

protocol ConverterViewModelProtocol: ObservableObject {
    
    associatedtype MeasureModel: MeasureListViewModelProtocol
    
    var measures: MeasureModel { get set}
}

struct ConverterView<ViewModel: ConverterViewModelProtocol>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            
        ZStack {
            
            Color(Asset.Colors.defaultBackground)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                MeasureListView(viewModel: viewModel.measures)
                    .padding(.horizontal, 20)
            }
            .navigationTitle("Conversor Culinário")
            .navigationBarTitleDisplayMode(.inline)
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
