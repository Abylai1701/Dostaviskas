//
//  FixedSizeModifier.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import SwiftUI

struct FixedSizeModifier: ViewModifier {
    let width: CGFloat?
    let height: CGFloat?
    
    func body(content: Content) -> some View {
        content.frame(width: width, height: height)
    }
}
