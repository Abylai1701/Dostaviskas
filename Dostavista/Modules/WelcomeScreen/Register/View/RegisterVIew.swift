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
    
    @State private var robot = false
    
    private var isPhoneValid: Bool {
        rawDigits.count == 11 && rawDigits.first == "7"
    }
    
    private var phoneEnabled: Bool {
        isPhoneValid
    }
    
    private var headerTitle: String {
        switch vm.step {
        case .phone:
            "Контактные данные"
        case .verify:
            "Верификация"
        case .fio:
            "Личные данные"
        case .city:
            "Выберите регион"
        case .done:
            "Done"
        }
    }
    
    private var headerStep: String {
        switch vm.step {
        case .phone:
            "1/5"
        case .verify:
            "2/5"
        case .fio:
            "3/5"
        case .city:
            "4/5"
        case .done:
            "5/5"
        }
    }
    // MARK: - Body
    var body: some View {
        ZStack {
            
            if vm.step != .done {
                
                Color.white.ignoresSafeArea()

                VStack(spacing: .zero) {
                    header
                    
                    superContent
                    
                    bottomButton
                }
            } else {
                
                Color.grayF2F2F2.ignoresSafeArea()

                VStack(spacing: .zero) {
                    headerForDone
                        .padding(.bottom, 32.fitH)
                        .padding(.horizontal)

                    FeatureRow(
                        systemIcon: .timeMainIcon,
                        title: "Свободный график",
                        subtitle: "Бери заказ хоть сейчас"
                    )
                    .padding(.bottom, 12.fitH)
                    .padding(.horizontal)

                    FeatureRow(
                        systemIcon: .geoMiniMainIcon,
                        title: "Рядом с домом",
                        subtitle: "Доставляй в своём районе"
                    )
                    .padding(.bottom, 12.fitH)
                    .padding(.horizontal)

                    FeatureRow(
                        systemIcon: .moneyMainIcon,
                        title: "Быстрый доход",
                        subtitle: "Всегда под рукой"
                    )
                    .padding(.bottom, 12.fitH)
                    .padding(.horizontal)

                    FeatureRow(
                        systemIcon: .dateMainIcon,
                        title: "Ежедневные выплаты",
                        subtitle: "С Пн по Чт"
                    )
                    .padding(.horizontal)

                    Spacer()
                    
                    bottomButton
                        .background(.white)
                }
                .padding(.top, 32)
                .overlay(alignment: .topLeading) {
                    Button {
                        vm.pop()
                    } label: {
                        Image(.backIcon)
                            .resizable()
                            .frame(width: 20, height: 16)
                            .padding(16)
                    }
                }
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
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var phoneStep: some View {
        VStack(spacing: 16.fitH) {
            
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
    
    @ViewBuilder
    private var superContent: some View {
        switch vm.step {
        case .phone:
            ScrollView(.vertical, showsIndicators: false) {
                phoneStep
            }
            .background(.grayF2F2F2)
        case .verify:
            ScrollView(.vertical, showsIndicators: false) {
                verifyStep
            }
            .background(.grayF2F2F2)
        case .fio:
            ScrollView(.vertical, showsIndicators: false) {
                fioStep
            }
            .background(.grayF2F2F2)
        case .city:
            citiesStep
                .background(.grayF2F2F2)
        case .done:
            phoneStep
        }
    }
    
    private var verifyStep: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(alignment: .center, spacing: 8) {
                Button {
                    robot.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(robot ? .purple8B5CF6 : .clear)
                        .stroke(Color("purple8B5CF6"), lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
                Text("Я не робот")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.bottom, 8)
            
            VStack(alignment: .leading, spacing: .zero) {
                Text("Нажмите, чтобы продолжить")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.black.opacity(0.5))
                    .padding(.bottom, 14)
                
                Text("Обработка данных • Поддержка")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.black.opacity(0.3))
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private var fioStep: some View {
        VStack(spacing: 16.fitH) {
            
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
        }
        .padding(.horizontal, 24)
        .padding(.top, 20.fitH)
    }
    
    private var header: some View {
        HStack {
            Button {
                switch vm.step {
                case .phone:
                    vm.pop()
                case .verify:
                    vm.step = .phone
                case .fio:
                    vm.step = .verify
                case .city:
                    vm.step = .fio
                case .done:
                    vm.pop()
                }
            } label: {
                Image(.backIcon)
                    .resizable()
                    .frame(width: 20, height: 16)
                    .padding(16)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Text(headerTitle)
                .font(.system(size: 17.fitW, weight: .semibold))
                .foregroundStyle(.black)
            
            Spacer()
            
            Text(headerStep)
                .font(.system(size: 17.fitW, weight: .semibold))
                .foregroundStyle(.purple8B5CF6)
                .padding(.trailing)
        }
        .padding(.bottom, 8)
    }
    
    private var citiesStep: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black.opacity(0.5))
                
                TextField("Поиск...", text: $vm.searchText)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal)
            .padding(.vertical, 20)
            
            // Список городов
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(vm.filteredCities, id: \.self) { c in
                        Button {
                            vm.city = c
                        } label: {
                            HStack {
                                Text(c)
                                    .foregroundStyle(.black)
                                    .font(.system(size: 17, weight: .medium))
                                
                                Spacer()
                                
                                if vm.city == c {
                                    Image(.checkIcon)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 24)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .background(Color.grayF2F2F2)
        }
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
        Text("Регистрируясь или входя в приложение, я подтверждаю согласие с Правилами использования сервиса «Достависта» и Политикой обработки персональных данных.")
            .font(.system(size: 15))
            .lineSpacing(3)
            .padding()
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("purple8B5CF6").opacity(0.1))
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
            switch vm.step {
            case .phone:
                if phoneEnabled {
                    vm.step = .verify
                } else {
                    vm.errorMessage = "Ошибка номера"
                }
            case .verify:
                if robot {
                    vm.step = .fio
                } else {
                    vm.errorMessage = "Подтвердите что вы не робот"
                }
            case .fio:
                if vm.fioText.trimmingCharacters(in: .whitespaces).isEmpty {
                    vm.errorMessage = "Введите ваше ФИО"
                } else {
                    vm.step = .city
                }
            case .city:
                vm.register()
            case .done:
                vm.pop()
            }
        } label: {
            Text(vm.step == .done ? "Начать работу" : "Продолжить")
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
        .padding(.bottom, 10.fitH)
        .padding(.top, 20.fitH)
    }
    
    private var headerForDone: some View {
        VStack(alignment: .center, spacing: .zero) {
            Image(.champIcon)
                .resizable()
                .frame(width: 80.fitH, height: 80.fitH)
                .padding(.bottom, 24.fitH)
            
            Text("Вы зарегестрировались!")
                .font(.system(size: 22.fitW, weight: .bold))
                .foregroundStyle(.black)
                .padding(.top, 4.fitH)
                .padding(.bottom, 8.fitH)

            Text("Теперь вы можете принимать заказы и начать зарабатывать")
                .font(.system(size: 16.fitW, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(.black.opacity(0.4))
        }
    }
}

#Preview {
    RegisterVIew(
        vm: RegisterViewModel(coordinator: RegisterCoordinator(router: AuthRouter()), authEnd: {})
    )
}
