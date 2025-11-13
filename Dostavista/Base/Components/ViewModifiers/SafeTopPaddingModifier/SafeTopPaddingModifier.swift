//
//  SafeTopPaddingModifier.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import SwiftUI

struct SafeTopPaddingModifier: ViewModifier {
    let paddingTop: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.top, paddingTop + topSafeAreaInset)
    }
    
    private var topSafeAreaInset: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.safeAreaInsets.top }
            .first ?? 0
    }
}
