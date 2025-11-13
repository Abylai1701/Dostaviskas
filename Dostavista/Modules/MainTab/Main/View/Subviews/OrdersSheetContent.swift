//
//  OrdersSheetContent.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import SwiftUI

struct OrdersSheetContent: View {
    @Environment(MainViewModel.self) private var vm
    
    private let filters = ["Все", "Пешком", "Авто", "Рядом", "Срочно"]
    
    var body: some View {
        VStack(spacing: .zero) {
            Capsule()
                .fill(Color.black.opacity(0.1))
                .frame(width: 80, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            HStack(alignment: .center) {
                Text("Доступные заказы")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.black)
                
                Spacer()
                
                Text("\(vm.orders.count) заказов")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.black.opacity(0.4))
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(filters.enumerated()), id: \.offset) { idx, name in
                        Chip(text: name, isSelected: vm.selectedFilterIndex == idx)
                            .onTapGesture { vm.selectedFilterIndex = idx }
                            .padding(.bottom)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(vm.orders, id: \.id) { order in
                        OrderCardView(data: order)
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                vm.push(order: order)
                            }
                    }
                    Spacer(minLength: 100)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct Chip: View {
    let text: String
    let isSelected: Bool
    
    var body: some View {
        Text(text)
            .font(.system(size: 15))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.purple8B5CF6
                          : Color.black.opacity(0.05))
            )
            .foregroundStyle(isSelected ? .white : .black)
            .shadow(color: isSelected ? Color.black.opacity(0.25) : .clear,
                    radius: isSelected ? 6 : 0, y: isSelected ? 4 : 0)
    }
}
