//
//  AuthNavigationHost.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import SwiftUI
import Combine

struct AuthNavigationHost: View {
    @StateObject private var router = AuthRouter()
    private let mainVM: AuthMainViewModel
    private let authVM: AuthViewModel
    private let registerVM: RegisterViewModel

    var authEnd: () -> Void
    
    init(authEnd: @escaping () -> Void) {
        self.authEnd = authEnd

        let router = AuthRouter()

        let mainCoordinator = AuthMainCoordinator(router: router)
        mainVM = AuthMainViewModel(coordinator: mainCoordinator)

        let authCoordinator = AuthCoordinator(router: router)
        authVM = AuthViewModel(coordinator: authCoordinator, authEnd: authEnd)
        
        let registerCoordinator = RegisterCoordinator(router: router)
        registerVM = RegisterViewModel(coordinator: registerCoordinator, authEnd: authEnd)

        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            AuthMainView(vm: mainVM)
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .auth:
                        AuthView(vm: authVM)
                    case .register:
                        RegisterVIew(vm: registerVM)
                    }
                }
        }
    }
}


enum AuthRoute: Hashable {
    case auth
    case register
}

final class AuthRouter: ObservableObject {
    @Published var path: [AuthRoute] = []

    func push(_ route: AuthRoute) {
        path.append(route)
    }
    func pop() {
        if !path.isEmpty {
            _ = path.removeLast()
        }
    }
    func popToRoot() {
        path.removeAll()
    }
}
