//
//  CustomTabBar.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home, orders, income, profile

    var title: String {
        switch self {
        case .home: "Главная"
        case .orders: "Заказы"
        case .income: "Доход"
        case .profile: "Профиль"
        }
    }

    var icon: String {
        switch self {
        case .home: "mainTab"
        case .orders: "ordersTab"
        case .income: "incomeTab"
        case .profile: "profileTab"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home: "mainSelectedTab"
        case .orders: "ordersSelectedTab"
        case .income: "incomeSelectedTab"
        case .profile: "profileSelectedTab"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selection: Tab
    private let activeColor = Color.purple8B5CF6
    private let inactiveColor = Color.black.opacity(0.3)

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.snappy) {
                            selection = tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(selection == tab ? tab.selectedIcon : tab.icon)
                                .resizable()
                                .frame(width: 26, height: 26)
                                .foregroundStyle(selection == tab ? activeColor : inactiveColor)
                            Text(tab.title)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(selection == tab ? activeColor : inactiveColor)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top)
            .padding(.bottom, 6)
            .background(Color.white)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}
