//
//  MainView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import Foundation
import MapKit
import SwiftUI

struct MainView: View {
    @State private var vm: MainViewModel
    
    init(vm: MainViewModel) {
        _vm = State(initialValue: vm)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            (
                Map(position: $vm.camera, interactionModes: [.pan, .zoom, .rotate]) {
                    ForEach(vm.points) { p in
                        Annotation("", coordinate: p.coord) {
                            MapPinWithPrice(price: p.price)
                        }
                    }
                }
            )
            .ignoresSafeArea()
            
            Color.black
                .opacity(vm.overlayOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            
            BottomSheetContainer(
                fraction: $vm.sheetFraction,
                snapFractions: vm.snapFractions
            ) {
                OrdersSheetContent()
                    .environment(vm)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.whiteF8F6FF)
                            .shadow(color: .black.opacity(0.08), radius: 16, y: 6)
                    )
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await vm.onAppear()
        }
    }
}
