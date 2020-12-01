//
//  MeasureListView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import SwiftUI

protocol MeasureListViewModelProtocol: ObservableObject {
    
    associatedtype MeasureViewModel: MeasureListItemViewModelProtocol
    
    var title: String { get }
    
    var measures: [MeasureViewModel] { get }
}

struct MeasureListView<ViewModel: MeasureListViewModelProtocol>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text(viewModel.title)
                .multilineTextAlignment(.leading)
                .appFont(weight: .semibold, textStyle: .largeTitle)
            
            ForEach(viewModel.measures) { measure in
                
                ZStack {
                    
                    Color(Asset.Colors.listCardBackground)
                    
                    MeasureListItem(viewModel: measure)
                    
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
            }
        }
    }
}

struct MeasureListView_Previews: PreviewProvider {
    
    static var previews: some View {
        MeasureListView(viewModel: MeasureListViewModel())
    }
}
