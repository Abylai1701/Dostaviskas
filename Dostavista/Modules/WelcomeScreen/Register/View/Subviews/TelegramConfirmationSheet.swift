//
//  TelegramConfirmationSheet.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 26.11.2025.
//

import SwiftUI

struct TelegramConfirmationSheet: View {
    @Binding var showTelega: Bool
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.grayF2F2F2.ignoresSafeArea()
            
            VStack(spacing: .zero) {
            
                ScrollView(.vertical) {
                    header
                        .padding(.horizontal, 40)
                        .padding(.top, 30)
                    
                    telegramCard
                        .padding(.bottom)
                        .padding(.horizontal, 24)
                    
                    FeatureRow(
                        systemIcon: .timeMainIcon,
                        title: "Свободный график",
                        subtitle: "Бери заказ хоть сейчас"
                    )
                    .padding(.bottom, 12.fitH)
                    .padding(.horizontal, 24)
                    
                    FeatureRow(
                        systemIcon: .geoMiniMainIcon,
                        title: "Рядом с домом",
                        subtitle: "Доставляй в своём районе"
                    )
                    .padding(.bottom, 12.fitH)
                    .padding(.horizontal, 24)
                    
                    FeatureRow(
                        systemIcon: .moneyMainIcon,
                        title: "Быстрый доход",
                        subtitle: "Всегда под рукой"
                    )
                    .padding(.bottom, 12.fitH)
                    .padding(.horizontal, 24)
                    
                    FeatureRow(
                        systemIcon: .dateMainIcon,
                        title: "Ежедневные выплаты",
                        subtitle: "С Пн по Чт"
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100.fitH)
                }
                
                Spacer(minLength: 0)
                
                bottomButton
                    .background(.white)
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .center, spacing: .zero) {
            Image(.champIcon)
                .resizable()
                .frame(width: 80.fitH, height: 80.fitH)
                .padding(.bottom, 24.fitH)
            
            Text("Подтвердите профиль")
                .font(.system(size: 22.fitW, weight: .bold))
                .foregroundStyle(.black)
                .padding(.top, 4.fitH)
                .padding(.bottom, 8.fitH)
            
            Text("Перед началом доставки, подтвердите профиль в телеграм-боте")
                .font(.system(size: 16.fitW, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(.black.opacity(0.4))
                .padding(.bottom, 20.fitH)
        }
    }
    
    private var telegramCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(.telega)
                .resizable()
                .size(52)
            
            Text("Перед началом доставки, подтвердите профиль в телеграм-боте")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.black)
        )
    }
    
    private var bottomButton: some View {
        VStack(alignment: .center, spacing: .zero) {
            Button {
                DispatchQueue.main.async {
                    showTelega = true
                }
            } label: {
                Text("Подтвердить")
                    .font(.system(size: 16.fitW, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16.fitH)
                    .background(Color("purple8B5CF6"))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24.fitW)
            .padding(.bottom, 14.fitH)
            .padding(.top, 20.fitH)
            
            Button {
                onDismiss()
            } label: {
                Text("Продолжить без подтверждения")
                    .font(.system(size: 15))
                    .foregroundStyle(.black.opacity(0.4))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .padding(.bottom, 10.fitH)
        }
    }
}
