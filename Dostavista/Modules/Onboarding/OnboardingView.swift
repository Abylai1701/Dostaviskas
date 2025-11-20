//
//  OnboardingView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 13.11.2025.
//

import SwiftUI
import StoreKit

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
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.black)
                Text(step.title2)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.purple8B5CF6)
                    .padding(.bottom, 8)
                
                Text(step.descr)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.gray6B7280)
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
                        requestReviewOrOpenStore()
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
    
    func requestReviewOrOpenStore() {
        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            SKStoreReviewController.requestReview(in: scene)
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
            "Свободный"
        case .onb2:
            "Быстрый"
        case .onb3:
            "Мы ценим"
        case .onb4:
            "Следи"
        }
    }
    
    var title2: String {
        switch self {
        case .onb1:
            "график"
        case .onb2:
            "заработок"
        case .onb3:
            "ваше мнение"
        case .onb4:
            "за прогрессом"
        }
    }
    
    var descr: String {
        switch self {
        case .onb1:
            "Выбирай время и темп, который подходит тебе, зарабатывай без строгих смен и расписаний"
        case .onb2:
            "Работай курьером, выбирай удобные маршруты и получай оплату сразу после доставки"
        case .onb3:
            "Поделитесь своим мнением о нашем приложении, чтобы мы могли сделать его лучше!"
        case .onb4:
            "Смотри, как растёт твой доход, отслеживай бонусы и улучшай рейтинг, чтобы достичь новых высот"
        }
    }
}
