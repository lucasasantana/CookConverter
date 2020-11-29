//
//  UIColor+Asset.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 27/11/20.
//  Copyright © 2020 LucasAntevere. All rights reserved.

import SwiftUI

extension Color {
    
    init(_ colorAsset: ColorAsset) {
        self.init(colorAsset.color)
    }
}
