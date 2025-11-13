//
//  StepView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import SwiftUI

struct StepView: View {
    let title: String
    let visual: FullDetailViewModel.StepVisual

    var body: some View {
        VStack(spacing: 8) {
            Image(iconName)
                .resizable()
                .frame(width: 32, height: 32)
                .shadow(color: visual == .active ? .black.opacity(0.3) : .clear, radius: 3, y: 4)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(textColor)
                .oneLineMinimumScale()
        }
    }

    private var iconName: ImageResource {
        switch visual {
        case .active: return .orderInProgressIcon
        case .done:   return .orderDoneIcon
        case .idle:   return .orderNotStartedIcon
        }
    }

    private var textColor: Color {
        switch visual {
        case .active: return .purple8B5CF6
        case .done:   return .purple8B5CF6
        case .idle:   return .black.opacity(0.4)
        }
    }
}
