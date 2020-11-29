//
//  InnerShadow.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 27/11/20.
//

import SwiftUI

struct AnyShape: Shape {
    
    private let builder: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        builder = { rect in
            let path = shape.path(in: rect)
            return path
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return builder(rect)
    }
}

struct InnerShadow: ViewModifier {
    
    enum Style {
        case circle
        case roundedRect(cornerRadius: CGFloat)
    }
    
    private var style: Style
    
    private var backgroundColor: Color
    
    private var shadowColor: Color
    private var shadowRadius: CGFloat
    
    private var borderWidth: CGFloat
    
    private var offset: CGPoint
    
    init(
        _ style: Style,
        backgroundColor: Color = .white,
        shadowColor: Color = .black,
        shadowRadius: CGFloat = 4,
        borderWidth: CGFloat = 0.0,
        offset: CGPoint = CGPoint(x: 2.0, y: 2.0)
    ) {
        
        self.style = style
        
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        
        self.borderWidth = borderWidth
        
        self.offset = offset
        
        self.backgroundColor = backgroundColor
    }
    
    func body(content: Content) -> some View {
        
        ZStack {
            content.overlay(
                shape()
                    .stroke(backgroundColor, lineWidth: borderWidth)
                    .shadow(color: shadowColor, radius: shadowRadius, x: offset.x, y: offset.y)
                    .clipShape(
                        shape()
                    )
                    .shadow(color: shadowColor, radius: shadowRadius, x: -offset.x, y: -offset.y)
                    .clipShape(
                        shape()
                    )
            )
            .background(backgroundColor)
            .clipShape(shape())
        }
    }
    
    func shape() -> AnyShape {
        
        switch self.style {
            
            case .circle:
                return AnyShape(Circle())
                
            case .roundedRect(let cornerRadius):
                return AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

extension View {
    
    func innerShadow(
        _ style: InnerShadow.Style,
        backgroundColor: Color = .white,
        shadowColor: Color = .black,
        shadowRadius: CGFloat = 4,
        borderWidth: CGFloat = 0.0,
        offset: CGPoint = CGPoint(x: 2.0, y: 2.0)
    ) -> some View {
        self.modifier(InnerShadow(style,
                                  backgroundColor: backgroundColor,
                                  shadowColor: shadowColor,
                                  shadowRadius: shadowRadius,
                                  borderWidth: borderWidth,
                                  offset: offset))
    }
}
