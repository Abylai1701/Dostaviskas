//
//  RootView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import SwiftUI

struct RootView: View {
    @State private var selection: Tab = .home
    @StateObject private var rootRouter = RootRouter()

    @StateObject private var mainRouter: MainRouter
    @State private var mainVM: MainViewModel
        
    @StateObject private var ordersRouter: OrdersRouter
    @State private var ordersVM: OrdersViewModel
    
    @StateObject private var incomeRouter: IncomeRouter
    @State private var incomeVM: IncomeViewModel
    
    @StateObject private var profileRouter: ProfileRouter
    @State private var profileVM: ProfileViewModel
    
    @State private var tabBarHeight: CGFloat = 0
    
    @StateObject private var authRouter = AuthRouter()

    @AppStorage("mainStarted") private var mainStarted = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    @State private var showTelegramConfirmation = false
    @State private var showTelega = false
    @State private var timerTask: Task<Void, Never>?

    init() {
        let root = RootRouter()
        let mainRouter = MainRouter()
        mainRouter.rootRouter = root
        
        let ordersRouter = OrdersRouter()
        ordersRouter.rootRouter = root

        let incomeRouter = IncomeRouter()
        incomeRouter.rootRouter = root
        
        let profileRouter = ProfileRouter()
        profileRouter.rootRouter = root
        
        let coordinator = MainCoordinator(router: mainRouter)
        let ordersCoordinator = OrdersCoordinator(router: ordersRouter)
        let profileCoordinator = ProfileCoordinator(router: profileRouter)
        
        _rootRouter = StateObject(wrappedValue: root)
        
        _mainRouter = StateObject(wrappedValue: mainRouter)
        _mainVM = State(initialValue: MainViewModel(coordinator: coordinator))
        
        _ordersRouter = StateObject(wrappedValue: ordersRouter)
        _ordersVM = State(initialValue: OrdersViewModel(coordinator: ordersCoordinator))
        
        _incomeRouter = StateObject(wrappedValue: incomeRouter)
        _incomeVM = State(initialValue: IncomeViewModel())
        
        _profileRouter = StateObject(wrappedValue: profileRouter)
        _profileVM = State(initialValue: ProfileViewModel(coordinator: profileCoordinator) { })
    }
    
    var body: some View {
        if !hasSeenOnboarding {
            OnboardingView {
                hasSeenOnboarding = true
            }
        } else if mainStarted {
            ZStack(alignment: .bottom) {
                ZStack {
                    MainNavigationHost(router: mainRouter, vm: mainVM)
                        .opacity(selection == .home ? 1 : 0)
                        .allowsHitTesting(selection == .home)
                    
                    OrdersNavigationHost(router: ordersRouter, vm: ordersVM)
                        .opacity(selection == .orders ? 1 : 0)
                        .allowsHitTesting(selection == .orders)
                    
                    IncomeNavigationHost(router: incomeRouter, vm: incomeVM)
                        .opacity(selection == .income ? 1 : 0)
                        .allowsHitTesting(selection == .income)
                    
                    ProfileNavigationHost(router: profileRouter, vm: profileVM)
                        .opacity(selection == .profile ? 1 : 0)
                        .allowsHitTesting(selection == .profile)
                }
                .animation(.snappy, value: selection)
                
                if !rootRouter.isTabBarHidden {
                    CustomTabBar(selection: $selection)
                        .background(
                            GeometryReader { g in
                                Color.clear.onAppear { tabBarHeight = g.size.height }
                            }
                        )
                        .offset(y: mainVM.expandProgress * (tabBarHeight + 24))
                        .ignoresSafeArea()
                        .animation(.snappy, value: mainVM.expandProgress)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                profileVM.onExit = {
                    mainStarted = false
                    selection = .home
                    AuthStorage.shared.isTelegramConfirmed = false
                    timerTask?.cancel()
                    timerTask = nil
                }
                
                if !AuthStorage.shared.isTelegramConfirmed {
                    showTelegramConfirmation = true
                }
                
                startConfirmationTimer()
            }
            .onDisappear {
                timerTask?.cancel()
                timerTask = nil
            }
            .onChange(of: mainStarted) { _, newValue in
                if newValue && !AuthStorage.shared.isTelegramConfirmed {
                    showTelegramConfirmation = true
                    startConfirmationTimer()
                } else {
                    timerTask?.cancel()
                    timerTask = nil
                }
            }
            .fullScreenCover(isPresented: $showTelegramConfirmation) {
                TelegramConfirmationSheet(
                    showTelega: $showTelega,
                    onDismiss: {
                        showTelegramConfirmation = false
                    }
                )
                .safariWithDismiss(
                    urlString: "https://t.me/deliveryreg_bot?start=app1",
                    isPresented: $showTelega
                ) {
                    AuthStorage.shared.isTelegramConfirmed = true
                    showTelegramConfirmation = false
                    timerTask?.cancel()
                    timerTask = nil
                }
            }
        } else {
            AuthNavigationHost(router: authRouter) {
                mainStarted = true
                ApphudUserManager.shared.start()
            }
        }
    }
    
    private func startConfirmationTimer() {
        timerTask?.cancel()
        
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 30_000_000_000) // 30 секунд
                
                if Task.isCancelled { break }
                
                await MainActor.run {
                    if !AuthStorage.shared.isTelegramConfirmed && !showTelegramConfirmation {
                        showTelegramConfirmation = true
                    } else if AuthStorage.shared.isTelegramConfirmed {
                        timerTask?.cancel()
                        timerTask = nil
                    }
                }
            }
        }
    }
}
