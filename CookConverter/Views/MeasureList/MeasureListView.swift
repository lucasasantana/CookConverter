//
//  MeasureListView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import SwiftUI

protocol MeasureListViewModelProtocol: ObservableObject {
    
    associatedtype ViewModel: MeasureViewModelProtocol
    
    var title: String { get }
    
    var measures: [ViewModel] { get }
}

struct MeasureListView<ViewModel: MeasureListViewModelProtocol>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    private var horizontalPadding: CGFloat
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.horizontalPadding = .zero
    }
    
    var body: some View {
        
        ZStack {
            
            Color(Asset.Colors.listBackground)
                .cornerRadius(24, corners: [UIRectCorner.topLeft, UIRectCorner.topRight])
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text(viewModel.title)
                    .multilineTextAlignment(.leading)
                    .appFont(weight: .semibold, textStyle: .largeTitle)
                    .padding(.horizontal, horizontalPadding)
                
                ForEach(viewModel.measures) { measure in
                    
                    ZStack {
                        
                        Color(Asset.Colors.listCardBackground)
                        
                        MeasureView(viewModel: measure)
                            
                    }
                    .frame(
                        idealHeight: 100
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                    .shadow(
                        color: Color.black.opacity(0.25),
                        radius: 4, x: 4.0, y: 4.0
                    )
                    .padding(.horizontal, horizontalPadding)
                }
                
                Spacer()
                    .frame(height: 40)
            }
            .padding(.top, 32)
        }
    }
    
    func horizontalPadding(_ padding: CGFloat) -> some View {
        
        var view = self
        
        view.horizontalPadding = padding
        
        return view
    }
}

struct MeasureListView_Previews: PreviewProvider {
    
    static var previews: some View {
        MeasureListView(viewModel: MeasureListViewModel())
    }
}
