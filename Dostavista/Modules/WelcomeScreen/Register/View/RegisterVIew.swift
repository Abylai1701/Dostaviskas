//
//  RegisterVIew.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import SwiftUI

struct RegisterVIew: View {
    @State private var vm: RegisterViewModel
    
    init(vm: RegisterViewModel) {
        _vm = State(initialValue: vm)
    }
    
    @State private var rawDigits: String = "7"
    @State private var agreed: Bool = false
    
    @State private var showTerms: Bool = false
    @State private var showPolicy: Bool = false
    
    @State private var showErrorAlert = false
    @State private var showCitySheet = false

    let cities = [
        "Москва",
        "Санкт-Петербург",
        "Новосибирск",
        "Екатеринбург",
        "Казань",
        "Нижний Новгород",
        "Челябинск",
        "Омск",
        "Самара",
        "Ростов-на-Дону",
        "Уфа",
        "Красноярск",
        "Пермь",
        "Воронеж",
        "Волгоград",
        "Саратов",
        "Тольятти",
        "Краснодар",
        "Ижевск",
        "Барнаул"
    ]

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
                            Text("ФИО")
                                .font(.system(size: 13.fitW, weight: .medium))
                                .foregroundStyle(.black.opacity(0.4))
                            
                            TextField("Иванов Иван Иванович", text: $vm.fioText)
                                .font(.system(size: 17.fitW))
                                .foregroundStyle(.black)
                                .frame(height: 54)
                                .padding(.horizontal, 16.fitW)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(.white)
                                        .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8.fitH) {
                            Text("Город")
                                .font(.system(size: 13.fitW, weight: .medium))
                                .foregroundStyle(.black.opacity(0.4))

                            HStack(spacing: 0) {
                                TextField("Введите или выберите город", text: $vm.city)
                                    .font(.system(size: 17.fitW))
                                    .foregroundStyle(.black)
                                
                                Button {
                                    showCitySheet = true
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .foregroundStyle(.black.opacity(0.4))
                                        .padding(.horizontal, 12)
                                }
                                .buttonStyle(.plain)
                            }
                            .frame(height: 54)
                            .padding(.horizontal, 16.fitW)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.white)
                                    .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
                            )
                        }


                        VStack(alignment: .leading, spacing: 8.fitH) {
                            Text("Email")
                                .font(.system(size: 13.fitW, weight: .medium))
                                .foregroundStyle(.black.opacity(0.4))
                            
                            TextField("Почта (необязательно)", text: $vm.mail)
                                .keyboardType(.emailAddress)
                                .font(.system(size: 17.fitW))
                                .foregroundStyle(.black)
                                .frame(height: 54)
                                .padding(.horizontal, 16.fitW)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(.white)
                                        .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8.fitH) {
                            Text("Номер телефона")
                                .font(.system(size: 13.fitW, weight: .medium))
                                .foregroundStyle(.black.opacity(0.4))
                            
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
        .hideKeyboardOnTap()
        .safari(urlString: "https://docs.google.com/document/d/1MJXu-7E_GZil58clMVkBvQFbkbcB6PLxIxGic_fob_s/edit?usp=sharing", isPresented: $showTerms)
        .safari(urlString: "https://docs.google.com/document/d/1Tck59S23Zh6vMMMLqwpy65bbV7LeadlGcsGbcHk4KWo/edit?tab=t.0", isPresented: $showPolicy)
        .sheet(isPresented: $showCitySheet) {
            citySheet
        }
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
            
            Text("Регистрация")
                .font(.system(size: 22.fitW, weight: .bold))
                .foregroundStyle(.black)
                .padding(.bottom, 8.fitH)
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
    
    private var bottomButton: some View {
        Button {
            vm.register()
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
    
    // MARK: - City Sheet
    private var citySheet: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(cities, id: \.self) { city in
                        Button {
                            vm.city = city
                            showCitySheet = false
                        } label: {
                            HStack {
                                Text(city)
                                    .foregroundStyle(.black)
                                    .font(.system(size: 17))
                                Spacer()
                                
                                if vm.city == city {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color("purple8B5CF6"))
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.plain)
                        
                        if city != cities.last {
                            Divider()
                                .padding(.leading, 24)
                        }
                    }
                }
            }
            .background(Color.grayF2F2F2)
            .navigationTitle("Выберите город")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        showCitySheet = false
                    }
                    .foregroundStyle(Color("purple8B5CF6"))
                }
            }
        }
    }
}
