//
//  IconView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 27/11/20.
//

import SwiftUI

struct IconView: View {
    
    private let imageName: String
    
    init(_ imageName: String) {
        self.imageName = imageName
    }
    
    var body: some View {
        
        Image(imageName)
            .padding(.all, 16)
            .cornerRadius(20)
            .clipShape(Circle())
            .innerShadow(
                .circle,
                backgroundColor: Color(Colors.iconBackground),
                shadowColor: Color.black.opacity(0.5),
                borderWidth: 2.0,
                offset: CGPoint(x: 0, y: 2)
            )
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView("cup")
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
    }
}
