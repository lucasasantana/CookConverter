//
//  NumberTextField.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import SwiftUI

struct NumberTextField: View {
    
    @Binding var input: String
    @Binding var isEditing: Bool
    
     var proportionalInputViewModel: InputPickerViewModelProtocol?
    
    init(input: Binding<String>,
         isEditing: Binding<Bool>,
         proportionalInputViewModel: InputPickerViewModelProtocol?
    ) {
        
        self._input = input
        self._isEditing = isEditing
        self.proportionalInputViewModel = proportionalInputViewModel
    }
    
    var body: some View {
        
        ZStack {
            
            Color(Asset.Colors.iconBackground)
            
            makeTextField()
        }
        .clipShape(RoundedRectangle(cornerRadius: 6.0))
        .innerShadow(.roundedRect(cornerRadius: 6.0),
                     backgroundColor: Color(Asset.Colors.iconBackground),
                     shadowColor: Color.black.opacity(0.5),
                     borderWidth: 1.0,
                     offset: CGPoint(x: 0, y: 2))
    }
    
    func makeTextField() -> TextFieldView {
        
        var view = TextFieldView("Number Input", text: $input, isEditing: $isEditing, withToolbar: true)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.center)
            .appFont(weight: .bold, textStyle: .body)
            .foregroundColor(Asset.Colors.numberFieldLabel)
            .accentColor(.clear)
        
        if let inputViewModel = proportionalInputViewModel {
            view = view
                .proportionalInputView(viewModel: inputViewModel)
        }
        
        return view
    }
}

struct NumberTextField_Previews: PreviewProvider {
    
    @State static var input = "0.0"
    @State static var isEditing = false
    
    static var previews: some View {
        NumberTextField(
            input: $input,
            isEditing: $isEditing,
            proportionalInputViewModel: nil
        )
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: 31))
    }
}
