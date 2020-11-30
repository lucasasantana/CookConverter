//
//  NumberTextField.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import SwiftUI

public struct AppTextFieldStyle: TextFieldStyle {
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(8)
    }
}

struct NumberTextField: View {
    
    @Binding var input: String
    @Binding var isEditing: Bool
    
    init(input: Binding<String>, isEditing: Binding<Bool>) {
        self._input = input
        self._isEditing = isEditing
    }
    
    var body: some View {
        
        ZStack {
            
            Color(Asset.Colors.iconBackground)
            
            TextFieldView("Number Input", text: $input, isEditing: $isEditing)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .appFont(weight: .bold, textStyle: .body)
                .foregroundColor(Asset.Colors.numberFieldLabel)
                .accentColor(.clear)
        }
        .clipShape(RoundedRectangle(cornerRadius: 6.0))
        .innerShadow(.roundedRect(cornerRadius: 6.0),
                     backgroundColor: Color(Asset.Colors.iconBackground),
                     shadowColor: Color.black.opacity(0.5),
                     borderWidth: 1.0,
                     offset: CGPoint(x: 0, y: 2))
    }
}

struct NumberTextField_Previews: PreviewProvider {
    
    @State static var input = "0.0"
    @State static var isEditing = false
    
    static var previews: some View {
        NumberTextField(input: $input, isEditing: $isEditing)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: 31))
    }
}
