//
//  OnboardingView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 13.11.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var step: OnbEnum = .onb1
    var onbEnd: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(step.image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            VStack(alignment: .center, spacing: .zero) {
                Text(step.title1)
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.black)
                Text(step.title2)
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.purple8B5CF6)
                    .padding(.bottom, 8)
                
                Text(step.descr)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.black.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Button {
                    switch step {
                    case .onb1:
                        step = .onb2
                    case .onb2:
                        step = .onb3
                    case .onb3:
                        step = .onb4
                    case .onb4:
                        onbEnd()
                    }
                } label: {
                    Text("Продолжить")
                        .font(.system(size: 17.fitW, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.vertical, 16.fitH)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.purple8B5CF6)
                        )
                }
            }
            .padding(.horizontal, 20.fitW)
            .padding(.bottom, 24)
            .safeAreaPadding(.bottom)
        }
    }
}

#Preview {
    OnboardingView() {
        
    }
}

enum OnbEnum {
    case onb1
    case onb2
    case onb3
    case onb4
    
    var image: ImageResource {
        switch self {
        case .onb1:
                .onb1
        case .onb2:
                .onb2
        case .onb3:
                .onb3
        case .onb4:
                .onb4
        }
    }
    var title1: String {
        switch self {
        case .onb1:
            "Выбор"
        case .onb2:
            "Бери заказы"
        case .onb3:
            "Мы ценим"
        case .onb4:
            "Следи за"
        }
    }
    
    var title2: String {
        switch self {
        case .onb1:
            "пользователей"
        case .onb2:
            "получай оплату сразу"
        case .onb3:
            "ваше мнение"
        case .onb4:
            "своим прогрессом"
        }
    }
    
    var descr: String {
        switch self {
        case .onb1:
            "Работай курьером по гибкому графику – выбирай удобные маршруты и получай оплату сразу после доставки"
        case .onb2:
            "Мы показываем заказы рядом – выбирай по маршруту и времени, доставляй пешком, на авто или самокате"
        case .onb3:
            "Поделитесь своим мнением о нашем приложении, чтобы мы могли сделать его лучше!"
        case .onb4:
            "Смотри, как растёт твой доход, отслеживай бонусы и улучшай рейтинг "
        }
    }
}
