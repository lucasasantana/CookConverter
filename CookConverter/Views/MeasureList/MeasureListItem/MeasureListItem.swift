//
//  MeasureListItem.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 27/11/20.
//

import SwiftUI

protocol MeasureListItemViewModelProtocol: ObservableObject, Identifiable {
    
    var proportionalInputViewModel: InputPickerViewModelProtocol? { get }
    
    var imageName: String { get }
    
    var title: String { get }
    
    var number: String { get }
    
    var isEditing: Bool { get set }
    
    func setNumber(_ value: String)
}

struct MeasureListItem<ViewModel: MeasureListItemViewModelProtocol>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    let bindingText: Binding<String>
    let bindingIsEditing: Binding<Bool>
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
        
        self.bindingText = Binding<String>(
            get: { viewModel.number },
            set: { viewModel.setNumber($0)}
        )
        
        self.bindingIsEditing = Binding<Bool>(
            get: { viewModel.isEditing },
            set: { viewModel.isEditing = $0 }
        )
    }
    
    var body: some View {
        
        HStack {
            
            IconView(viewModel.imageName)
            
            Spacer()
                .frame(width: 16)
            
            Text(viewModel.title)
                .appFont(weight: .bold, textStyle: .body)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .lineLimit(2)
            
            Spacer()
            
            VStack {
            
                Spacer()
                
                NumberTextField(
                    input: bindingText,
                    isEditing: bindingIsEditing,
                    proportionalInputViewModel: viewModel.proportionalInputViewModel
                )
                    .frame(width: 94)
                    .frame(
                        maxHeight: 55,
                        alignment: .center
                    )
                    .padding(.all, 16)
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

struct MeasureListItem_Previews: PreviewProvider {
    
    final class MockViewModel: MeasureListItemViewModelProtocol {
        
        var proportionalInputViewModel: InputPickerViewModelProtocol?
        
        var isEditing: Bool = false
        
        var number: String = "0.0"
        
        var imageName: String = "cup"
        
        var title: String = "Cup"
        
        func setNumber(_ value: String) {
            self.number = value
        }
        
        func selectProportionalInput(integer: Int, decimal: Int) {}
    }
    
    static var previews: some View {
        
        MeasureListItem(viewModel: MockViewModel())
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/375.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
            .environment(\.colorScheme, .light)
    }
}
