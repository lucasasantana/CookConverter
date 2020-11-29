//
//  VerticalListItem.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 27/11/20.
//

import SwiftUI

protocol VerticalListItemViewModelProtocol: ObservableObject {
    
    var imageName: String { get }
    
    var title: String { get }
    
    var number: String { get }
    
    var isEditing: Bool { get set }
    
    func setNumber(_ value: String)
}

struct VerticalListItem<ViewModel: VerticalListItemViewModelProtocol>: View {
    
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
        
        HStack(spacing: 16) {
            
            IconView(viewModel.imageName)
            
            Text(viewModel.title)
                .appFont(weight: .bold, textStyle: .body)
                .foregroundColor(.white)
            
            Spacer(minLength: 20)
            
            VStack {
            
                Spacer()
                
                NumberTextField(input: bindingText, isEditing: bindingIsEditing)
                    
                    .frame(
                        maxWidth: 120,
                        maxHeight: 31,
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

struct VerticalListItem_Previews: PreviewProvider {
    
    final class MockViewModel: VerticalListItemViewModelProtocol {
        
        var isEditing: Bool = false
        
        var number: String = "0.0"
        
        var imageName: String = "cup"
        
        var title: String = "Cup"
        
        func setNumber(_ value: String) {
            self.number = value
        }
    }
    
    static var previews: some View {
        
        VerticalListItem(viewModel: MockViewModel())
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/375.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
            .environment(\.colorScheme, .light)
    }
}
