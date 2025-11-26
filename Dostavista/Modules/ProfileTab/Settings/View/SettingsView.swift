//
//  SettingsView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 11.11.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State var vm: SettingsViewModel
    @State private var showRate = false
    @State private var showPolicy: Bool = false
    @State private var showTerms: Bool = false
    @State private var showAlert = false

    var onExit: () -> Void

    init(router: ProfileRouter, onExit: @escaping () -> Void) {
        let coordinator = SettingsCoordinator(router: router)
        _vm = State(initialValue: SettingsViewModel(coordinator: coordinator))
        self.onExit = onExit
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            header
                .padding(.bottom, 20)

            content
                .padding(.horizontal)
                .padding(.bottom, 24)

            Button {
                onExit()
                AuthStorage.shared.token = nil
                AuthStorage.shared.isTelegramConfirmed = false
                vm.pop()
            } label: {
                Text("Удалить аккаунт")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.redFB2C361A)
                    .frame(maxWidth: .infinity)
                    .padding(13)
            }
            Spacer()
        }
        .background(.grayF2F2F2)
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $showRate) {
            RateSheet()
        }
        .safari(urlString: "https://docs.google.com/document/d/17e4wZQqOWohrcMw7gPxMxdtOrbDBR1cTdktjnq3fJ74/edit?tab=t.0", isPresented: $showPolicy)
        .safari(urlString: "https://docs.google.com/document/d/1mjYIZDx4nG_EWMnGzIVArFQ1z2X7He7jNUkeEi8pSic/edit?usp=sharing", isPresented: $showTerms)
        .alert(isPresented: $showAlert) {
            return Alert(
                title: Text("App version"),
                message: Text("1.0"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
 
    private var content: some View {
        VStack(spacing: 14) {
            Button {
                showAlert = true
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(.versionInfoIcon)
                        .resizable()
                        .size(42)
                    
                    Text("Версия приложения")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                )
            }
            .buttonStyle(.plain)
            
            Button {
                shareApp()
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(.shareIcon)
                        .resizable()
                        .size(42)
                    
                    Text("Поделиться")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                )
            }
            .buttonStyle(.plain)
            
            Button {
                showRate = true
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(.rateIcon)
                        .resizable()
                        .size(42)
                    
                    Text("Поддержите нас")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                        .lineLimit(1)                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                )
            }
            .buttonStyle(.plain)
            
            Button {
                showPolicy = true
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(.policyIcon)
                        .resizable()
                        .size(42)
                    
                    Text("Политика конфиденциальности")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                )
            }
            .buttonStyle(.plain)
            
            Button {
                showTerms = true
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(.policyIcon)
                        .resizable()
                        .size(42)
                    
                    Text("Условия")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                )
            }
            .buttonStyle(.plain)
        }
    }
    private var header: some View {
        HStack {
            Button {
                vm.pop()
            } label: {
                Image(.backIcon)
                    .resizable()
                    .frame(width: 20, height: 16)
                    .padding(16)
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
        .overlay {
            Text("Настройки")
                .font(.system(size: 17.fitW, weight: .semibold))
                .foregroundStyle(.black)
        }
        .padding(.bottom, 8)
        .background(.white)
    }
    func shareApp() {
        let message = "Попробуй приложение Dostavista! 🚀"
        
        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = rootVC.view
                popover.sourceRect = CGRect(x: UIScreen.main.bounds.midX,
                                            y: UIScreen.main.bounds.maxY - 100,
                                            width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            rootVC.present(activityVC, animated: true)
        }
    }

}
