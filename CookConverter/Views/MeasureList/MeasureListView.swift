//
//  MeasureListView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import SwiftUI

protocol MeasureListViewModelProtocol: ObservableObject {
    
    associatedtype MeasureViewModel: MeasureListItemViewModelProtocol
    
    var measures: [MeasureViewModel] { get }
}

struct MeasureListView<ViewModel: MeasureListViewModelProtocol>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            ForEach(viewModel.measures) { measure in
                
                ZStack {
                    
                    Color(Asset.Colors.listCardBackground)
                    
                    MeasureListItem(viewModel: measure)
                    
                }
                .frame(
                    maxHeight: 84
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
    
    private class MockViewModel: MeasureListViewModelProtocol {
        
         typealias MeasureViewModel = MeasureListItemViewModel
        
        var measures: [MeasureListItemViewModel] = [.init(title: "Cup", imageName: "cup")]
    }
    
    static var previews: some View {
        MeasureListView(viewModel: MockViewModel())
    }
}
