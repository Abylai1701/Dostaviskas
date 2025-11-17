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
    
    @AppStorage("mainStarted") private var mainStarted = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

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
                }
            }
        } else {
            AuthNavigationHost {
                mainStarted = true
                ApphudUserManager.shared.start()
            }
        }
    }
}
