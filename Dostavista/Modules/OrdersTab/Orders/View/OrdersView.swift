//
//  OrdersView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import Foundation
import SwiftUI

struct OrdersView: View {
    @State private var vm: OrdersViewModel
    
    init(vm: OrdersViewModel) {
        _vm = State(initialValue: vm)
    }
    
    enum Tab: String, CaseIterable {
        case active = "Активные"
        case history = "История"
    }
    
    @State private var selectedTab: Tab = .active
    
    var body: some View {
        VStack(spacing: 0) {
            
            header

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(vm.orders, id: \.id) { order in
                        if selectedTab == .active {
                            OrderCardActiveView(data: order) {
                                vm.chat(order: order)
                            }
                            .onTapGesture {
                                vm.goToActiveDetail(order: order)
                            }
                        } else {
                            
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 150)
            }
        }
        .background(.grayF2F2F2)
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var header: some View {
        VStack(spacing: .zero) {
            Text("Заказы")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.black)
                .padding(.top, 16)
                .padding(.bottom, 14)

            Divider()
            
            HStack(spacing: .zero) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        VStack(spacing: 14) {
                            Text(tab.rawValue)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(selectedTab == tab ? .purple8B5CF6 : Color.gray6B7280)
                            
                            Rectangle()
                                .fill(selectedTab == tab ? .purple8B5CF6 : Color.clear)
                                .frame(height: 1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 14)
                    }
                }
            }
        }
        .background(Color.white)
    }
}
