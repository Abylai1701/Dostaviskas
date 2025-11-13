//
//  MapPinWithPrice.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import SwiftUI

struct MapPinWithPrice: View {
    let price: String
    var body: some View {
        VStack(spacing: 4) {
            Image(.pinForMapIcon)
                .resizable()
                .frame(width: 48, height: 48)
                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
            
            Text(price)
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    Capsule().fill(.white)
                        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
                )
                .overlay(
                    Capsule().stroke(Color.purple8B5CF6.opacity(0.1), lineWidth: 1)
                )
        }
    }
}
