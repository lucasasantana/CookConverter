//
//  ContentView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 26/11/20.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 16) {
                
                ForEach(0..<5) { _ in
                    
                    ZStack {
                        
                        Color(Asset.Colors.listCardBackground)
                        
                        VerticalListItem(viewModel: ItemViewModel())
        
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
            .padding(.horizontal, 20)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
