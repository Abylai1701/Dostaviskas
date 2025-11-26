//
//  AuthMainView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 07.11.2025.
//

import SwiftUI

struct AuthMainView: View {

    @State var vm: AuthMainViewModel

    init(vm: AuthMainViewModel) {
        _vm = State(initialValue: vm)
    }

    var body: some View {
        ZStack {
            VStack(spacing: .zero) {
                
                header
                Image(.cur)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: 400.fitH)
                    .mask(
                        LinearGradient(
                            colors: [.black, .black, .black, .black, .black, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                Spacer(minLength: 0)
                
                VStack(spacing: 12.fitH) {
                    Button(action: { vm.sighUp() }) {
                        Text("Зарегистрироваться")
                            .font(.system(size: 16.fitW, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16.fitH)
                            .background(.purple8B5CF6)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 4)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 24.fitW)

                    Button(action: { vm.signIn() }) {
                        Text("У меня уже есть аккаунт")
                            .font(.system(size: 16.fitW, weight: .medium))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16.fitH)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 24.fitW)

                }
                .padding(.top, 8.fitH)
            }
            .padding(.top, 20.fitH)
            .padding(.bottom, 10.fitH)
        }
        .background(
            LinearGradient(
                colors: [.blueCEEBFE, .blueCEEBFE,  .grayF2F2F2],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationBarHidden(true)
    }

    private var header: some View {
        VStack(alignment: .center, spacing: .zero) {
            Image(.geoMainIcon)
                .resizable()
                .frame(width: 80.fitH, height: 80.fitH)
                .padding(.bottom, 24.fitH)
            
            Text("WB Курьер")
                .font(.system(size: 28.fitW, weight: .bold))
                .foregroundStyle(.black)
                .padding(.top, 4.fitH)
                .padding(.bottom, 8.fitH)

            Text("Работа курьером")
                .font(.system(size: 17.fitW, weight: .regular))
                .foregroundStyle(.black.opacity(0.4))
        }
    }
}

// MARK: - Компоненты

struct FeatureRow: View {
    let systemIcon: ImageResource
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12.fitH) {
            Image(systemIcon)
                .resizable()
                .frame(width: 40.fitH, height: 40.fitH)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16.fitW, weight: .medium))
                    .foregroundStyle(.black)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.system(size: 13.fitW, weight: .regular))
                    .foregroundStyle(.black.opacity(0.4))
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14.fitH)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 2)
    }
}

#Preview {
    AuthMainView(vm: AuthMainViewModel(coordinator: AuthMainCoordinator(router: AuthRouter())))
}
