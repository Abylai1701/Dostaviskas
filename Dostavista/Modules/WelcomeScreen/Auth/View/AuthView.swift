//
//  AuthView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 07.11.2025.
//

import SwiftUI

struct AuthView: View {
    @State private var vm: AuthViewModel
    
    init(vm: AuthViewModel) {
        _vm = State(initialValue: vm)
    }
    
    @State private var rawDigits: String = "7"
    @State private var agreed: Bool = false
    
    @State private var showTerms: Bool = false
    @State private var showPolicy: Bool = false
    @State private var showErrorAlert = false
    
    private var isPhoneValid: Bool {
        rawDigits.count == 11 && rawDigits.first == "7"
    }
    
    private var continueEnabled: Bool {
        isPhoneValid && agreed
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Фон
            Color.white.ignoresSafeArea()
            
            VStack(spacing: .zero) {
                header
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16.fitH) {
                        topCard
                            .padding(.bottom)
                        VStack(alignment: .leading, spacing: 8.fitH) {
                            Text("Номер телефона")
                                .font(.system(size: 13.fitW, weight: .medium))
                                .foregroundStyle(.black.opacity(0.4))
                            
                            // ВАЖНО: пробрасываем и phone, и rawDigits
                            PhoneMaskField(phone: $vm.phoneText, rawDigits: $rawDigits)
                        }
                        
                        consentCard
                        
                        securityCard
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20.fitH)
                }
                .background(.grayF2F2F2)
                
                bottomButton
            }
            if vm.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Загрузка…")
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .foregroundColor(.white)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .alert("Ошибка", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.errorMessage ?? "Попробуйте позже")
        }
        .onChange(of: vm.errorMessage) { _, newValue in
            showErrorAlert = newValue != nil
        }
        .ignoresSafeArea(.keyboard)
        .hideKeyboardOnTap()
        .safari(urlString: "https://docs.google.com/document/d/1MJXu-7E_GZil58clMVkBvQFbkbcB6PLxIxGic_fob_s/edit?usp=sharing", isPresented: $showTerms)
        .safari(urlString: "https://docs.google.com/document/d/1Tck59S23Zh6vMMMLqwpy65bbV7LeadlGcsGbcHk4KWo/edit?tab=t.0", isPresented: $showPolicy)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    // MARK: - Header (кастомный)
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
            Text("Вход")
                .font(.system(size: 17.fitW, weight: .semibold))
                .foregroundStyle(.black)
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Верхний блок с иконкой и заголовком
    private var topCard: some View {
        VStack(spacing: .zero) {
            Image(.phoneMainIcon)
                .resizable()
                .frame(width: 80.fitH, height: 80.fitH)
                .padding(.bottom, 24.fitH)
            
            Text("Вход в приложение")
                .font(.system(size: 22.fitW, weight: .bold))
                .foregroundStyle(.black)
                .padding(.bottom, 8.fitH)
            
            Text("Введите номер телефона\nдля получения кода подтверждения")
                .font(.system(size: 17.fitW, weight: .regular))
                .foregroundStyle(.black.opacity(0.4))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Чекбокс согласия
    private var consentCard: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                Button {
                    withAnimation(.snappy) {
                        agreed.toggle()
                    }
                } label: {
                    Image(agreed ? .agreeIcon : .notAgreeIcon)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .offset(y: 1)
                }
                .buttonStyle(.plain)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("Я соглашаюсь с")
                            .font(.system(size: 15.fitH, weight: .regular))
                            .foregroundStyle(.black)
                        Button {
                            showTerms = true
                        } label: {
                            Text("правилами сервиса")
                                .font(.system(size: 15.fitH, weight: .semibold))
                                .foregroundStyle(Color("purple8B5CF6"))
                        }
                        .buttonStyle(.plain)
                    }
                    HStack(spacing: 4) {
                        Text("и")
                            .font(.system(size: 15.fitH, weight: .regular))
                            .foregroundStyle(.black)
                        Button {
                            showPolicy = true
                        } label: {
                            Text("политикой обработки данных")
                                .font(.system(size: 15.fitH, weight: .semibold))
                                .foregroundStyle(Color("purple8B5CF6"))
                        }
                        .buttonStyle(.plain)
                    }
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical)
        }
        .background(
            agreed
            ? Color("purple8B5CF6").opacity(0.15)
            : Color.white
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
    }
    
    // MARK: - Инфо блок безопасности
    private var securityCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Image(.securityMainIcon)
                    .resizable()
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Безопасность")
                        .font(.system(size: 16.fitH, weight: .semibold))
                        .foregroundStyle(.black)
                    
                    Text("Ваши данные защищены\nи используются только для авторизации")
                        .font(.system(size: 13.fitH, weight: .regular))
                        .foregroundStyle(.blue2B7FFF1A)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.blue2B7FFF1A.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.blue2B7FFF1A, lineWidth: 1)
        )
    }
    
    // MARK: - Нижняя кнопка
    private var bottomButton: some View {
        Button {
            vm.continueTap(phone: vm.phoneText)
        } label: {
            Text("Продолжить")
                .font(.system(size: 16.fitW, weight: .medium))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16.fitH)
                .background(Color("purple8B5CF6"))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 4)
        }
        .disabled(!continueEnabled)
        .buttonStyle(.plain)
        .padding(.horizontal, 24.fitW)
        .padding(.bottom, 10.fitH)
        .padding(.top, 20.fitH)
    }
}
