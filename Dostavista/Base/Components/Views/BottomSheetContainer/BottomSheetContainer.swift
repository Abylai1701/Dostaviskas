//
//  BottomSheetContainer.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import SwiftUI

/// Очень удобная штука чтобы делать SHEETS с выборачными стопами

struct BottomSheetContainer<Content: View>: View {
    @Binding var fraction: CGFloat
    let snapFractions: [CGFloat]
    @ViewBuilder var content: () -> Content

    @GestureState private var dragDY: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let H = geo.size.height
            let current = fraction
            let dy = dragDY
            // Пересчет по жесту
            let newFraction = clamp( current - dy / H, 0.05, 1.0 )
            let offsetY = (1 - newFraction) * H

            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .offset(y: max(0, offsetY))
                .gesture(
                    DragGesture(minimumDistance: 2, coordinateSpace: .global)
                        .updating($dragDY) { value, state, _ in
                            state = value.translation.height
                        }
                        .onEnded { value in
                            let tentative = clamp( fraction - value.translation.height / H, 0.05, 1.0 )
                            if let target = snapFractions.min(by: { abs($0 - tentative) < abs($1 - tentative) }) {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                    fraction = target
                                }
                            } else {
                                withAnimation(.spring) { fraction = tentative }
                            }
                        }
                )
                .animation(.interactiveSpring(), value: dragDY)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private func clamp(_ v: CGFloat, _ lo: CGFloat, _ hi: CGFloat) -> CGFloat {
        min(max(v, lo), hi)
    }
}
