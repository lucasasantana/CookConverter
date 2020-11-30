//
//  UIApplication+EndEditting.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//  Copyright © 2020 LucasAntevere. All rights reserved.

import UIKit

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
