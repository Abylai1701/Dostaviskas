//
//  ProfileView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 11.11.2025.
//

import SwiftUI

struct ProfileView: View {
    @State var vm: ProfileViewModel
    @State private var showSheet = false

    @AppStorage("selectedTransportTypes") private var savedTransportRaw: String = ""

    private var transportDisplay: String {
        let items = savedTransportRaw.split(separator: ",").map(String.init)
        return items.isEmpty ? "Не выбран" : items.joined(separator: ", ")
    }
    
    init(vm: ProfileViewModel) {
        _vm = State(initialValue: vm)
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: .zero) {
                header
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20.fitH) {
                        mainInfo
                        
                        documents

                        settings
                        
                        Button {
                            vm.onExit()
                            AuthStorage.shared.token = nil
                            AuthStorage.shared.isTelegramConfirmed = false
                        } label: {
                            Text("Выйти из аккаунта")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.redFB2C361A)
                                .frame(maxWidth: .infinity)
                                .padding(13)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.grayF2F2F2)

            }
            
            if showSheet {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showSheet) {
            TransportSheetView()
                .presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.hidden)
        }
        .animation(.spring(duration: 0.4), value: showSheet)
        .onAppear {
            Task {
                await vm.loadProfile()
            }
        }
    }
    
    
    private var mainInfo: some View {
        VStack(alignment: .center, spacing: .zero) {
            HStack(alignment: .center, spacing: 12) {
                Image(.profileBigIcon)
                    .resizable()
                    .size(64)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.fullName.isEmpty ? "Загрузка..." : vm.fullName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.black)
                    
                    Text(vm.phone.isEmpty ? "+7 (***) ***-**-**" : vm.phone)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.black.opacity(0.4))
                }
                
                Spacer(minLength: 0)
            }
            .padding(.bottom)
            
            HStack(spacing: 12.fitW) {
                VStack(alignment: .center, spacing: 3) {
                    Text("0")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.purple8B5CF6)
                    
                    Text("Заказов")
                        .font(.system(size: 13, weight: .regular))
                        .frame(width: 85.fitW)
                        .foregroundStyle(.gray6B7280)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.whiteF8F6FF)
                )
                
                VStack(alignment: .center, spacing: 3) {
                    Text("100%")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.purple8B5CF6)
                    
                    Text("Рейтинг")
                        .font(.system(size: 13, weight: .regular))
                        .frame(width: 85.fitW)
                        .foregroundStyle(.gray6B7280)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.whiteF8F6FF)
                )
                
                VStack(alignment: .center, spacing: 3) {
                    Text("0 мес")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.purple8B5CF6)
                    
                    Text("С нами")
                        .font(.system(size: 13, weight: .regular))
                        .frame(width: 85.fitW)
                        .foregroundStyle(.gray6B7280)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.whiteF8F6FF)
                )
            }
        }
        .padding(20)
        .background(.white)
    }
    
    private var documents: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Документы")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.black.opacity(0.4))
                .padding(.leading)
            
            Button {
                showSheet = true
            } label: {
                HStack(alignment: .center, spacing: 12) {
                    Image(.transportIcon)
                        .resizable()
                        .size(44)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Транспорт")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.black)
                        
                        Text(transportDisplay)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.black.opacity(0.4))
                    }
                    
                    Spacer()
                    
                    Image(.rightArrowIcon)
                        .resizable()
                        .frame(width: 8, height: 13)
                }
                .padding(20)
                .background(Rectangle().fill(.white))
            }
            .buttonStyle(.plain)
        }
    }
    
    private var settings: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Поддержка")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.black.opacity(0.4))
                .padding(.leading)
            
            Button {
                vm.openSettings()
            } label: {
                HStack(alignment: .center, spacing: 12) {
                    Image(.settingsBigIcon)
                        .resizable()
                        .size(44)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Настройки")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.black)
                        
                        Text("Уведомления, язык ")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.black.opacity(0.4))
                    }
                    
                    Spacer()
                    
                    Image(.rightArrowIcon)
                        .resizable()
                        .frame(width: 8, height: 13)
                }
                .padding(20)
                .background(Rectangle().fill(.white))
            }
            .buttonStyle(.plain)
        }
    }
  
    private var header: some View {
        VStack(alignment: .center, spacing: 24) {
            Text("Профиль")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.black)
                .padding(.top)
            
            Divider()
                .background(.black.opacity(0.1))
        }
    }
}
