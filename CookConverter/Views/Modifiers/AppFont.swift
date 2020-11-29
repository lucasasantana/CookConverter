//
//  AppFont.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//  Copyright © 2020 LucasAntevere. All rights reserved.

import SwiftUI

struct AppFont: ViewModifier {
   
    typealias Family = FontFamily.Rubik
    
    private var weight: SwiftUI.Font.Weight, textStyle: UIFont.TextStyle
    
    init(weight: SwiftUI.Font.Weight, textStyle: UIFont.TextStyle) {
        self.weight = weight
        self.textStyle = textStyle
    }
        
    func body(content: Content) -> some View {
        
        let font: FontConvertible
        
        switch weight {
            
            case .black:
                font = Family.black
                
            case .bold, .heavy:
                font = Family.bold
                
            case .light, .thin, .ultraLight:
                font = Family.light
                
            case .medium:
                font = Family.medium
                
            case .regular:
                font = Family.regular
                
            case .semibold:
                font = Family.semiBold
                
            default:
                font = Family.regular
        }
        
        if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
            font.register()
        }
        
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        
        return content
            .font(SwiftUI.Font.custom(font.name, size: descriptor.pointSize))
    }
}

extension View {
    
    func appFont(weight: SwiftUI.Font.Weight, textStyle: UIFont.TextStyle = .body) -> some View {
        return self.modifier(AppFont(weight: weight, textStyle: textStyle))
    }
}
