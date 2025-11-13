//
//  AvailableOrderView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import Foundation
import SwiftUI

enum OrderTag: Hashable {
    case urgent
    case nearby
    
    var title: String {
        switch self {
        case .urgent:
            return "Срочно"
        case .nearby: 
            return "Рядом"
        }
    }
    var foreground: Color {
        switch self {
        case .urgent:
            return .redFB2C361A
        case .nearby:
            return .blue2B7FFF1A
        }
    }
    var background: Color {
        switch self {
        case .urgent:
            return .redFB2C361A.opacity(0.1)
        case .nearby:
            return .blue2B7FFF1A.opacity(0.1)
        }
    }
}

enum PaymentBadge: Hashable {
    case card, cash, other(systemName: String)
    
    var icon: String {
        switch self {
        case .card: return "card_icon"
        case .cash: return "banknote.fill"
        case .other(let name): return name
        }
    }
}

// MARK: - View

struct OrderCardView: View {
    var data: FullOrder

    var body: some View {
        VStack(spacing: 16) {
            header
            tagRow
            addressBlock
            
            Divider()
                .background(.black.opacity(0.1))
                .frame(height: 1)
            footer
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
                .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
        )
        .overlay(paymentBadge, alignment: .topTrailing)
    }
    
    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            Text("\(Int(data.price_usd)) ₽")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.purple8B5CF6)

            Text("\(String(format: "%.1f", data.distance_km)) км · \(data.delivery_minutes) мин")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.black.opacity(0.4))
            
            Spacer(minLength: 0)
        }
    }
    
    private var tagRow: some View {
        HStack(spacing: 8) {
            Pill(
                text: OrderTag.urgent.title,
                foreground: OrderTag.urgent.foreground,
                background: OrderTag.urgent.background
            )
            if Bool.random() {
                Pill(
                    text: OrderTag.nearby.title,
                    foreground: OrderTag.nearby.foreground,
                    background: OrderTag.nearby.background
                )
            }
            Spacer()
        }
    }
    
    private var addressBlock: some View {
        HStack(alignment: .center, spacing: 6) {
            VStack(alignment: .center, spacing: 10) {
                Image(.purpleAddressTag)
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Rectangle()
                    .fill(.purple8B5CF6.opacity(0.1))
                    .frame(width: 2, height: 12)
                    
                Image(.redAddressTag)
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            
            VStack(alignment: .leading, spacing: .zero) {
                Text(data.from_address)
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                
                Spacer()
                
                Text(data.to_address)
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
            }
            .frame(maxHeight: 70)
            
            Spacer()
        }
    }
    
    // MARK: Footer
    private var footer: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                Image(systemName: "cube.box")
                    .imageScale(.medium)
                    .foregroundStyle(.black.opacity(0.4))
                Text("\(data.weight_kg) кг")
                    .foregroundStyle(.black.opacity(0.4))
                    .font(.system(size: 13))
            }
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .imageScale(.medium)
                    .foregroundStyle(.black.opacity(0.4))
                Text("\(data.delivery_minutes) мин")
                    .foregroundStyle(.black.opacity(0.4))
                    .font(.system(size: 13))
            }
        }
    }
    
    // MARK: Payment badge
    private var paymentBadge: some View {
        Image("card_icon")
            .resizable()
            .frame(width: 28, height: 28)
            .padding()
    }
}

// MARK: - Subviews

struct Pill: View {
    var text: String
    var foreground: Color
    var background: Color
    var forMain: Bool = true
    
    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .medium))
            .padding(.horizontal, 11)
            .padding(.vertical,forMain ?  4 : 6)
            .foregroundStyle(foreground)
            .background(
                Capsule(style: .continuous).fill(background)
            )
    }
}
