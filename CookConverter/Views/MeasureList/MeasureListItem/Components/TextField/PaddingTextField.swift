//
//  PaddingTextField.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import UIKit

class PaddingTextField: UITextField {
    
    var inset: CGFloat
    
    var axis: [Axis]
    
    enum Axis {
        case vertical
        case horizontal
    }
    
    init(inset: CGFloat, axis: [Axis]) {
        
        self.inset = inset
        self.axis = axis
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        
        self.inset = .zero
        self.axis = [.horizontal, .vertical]
        
        super.init(coder: coder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        let dx = axis.contains(.horizontal) ? inset : .zero
        let dy = axis.contains(.vertical) ? inset : .zero
        
        return bounds.insetBy(dx: dx, dy: dy)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
