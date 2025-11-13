//
//  ProfileNavigationHost.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 11.11.2025.
//

import SwiftUI
import Combine

struct ProfileNavigationHost: View {
    @ObservedObject var router: ProfileRouter
    let vm: ProfileViewModel
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ProfileView(vm: vm)
                .navigationDestination(for: ProfileRoute.self) { route in
                    switch route {
                    case .settings:
                        SettingsView(router: router) {
                            vm.onExit()
                        }
                    }
                }
        }
    }
}


enum ProfileRoute: Hashable {
    case settings
}

final class ProfileRouter: ObservableObject {
    @Published var path: [ProfileRoute] = []
    weak var rootRouter: RootRouter?

    func push(_ route: ProfileRoute) {
        path.append(route)
        updateTabBarVisibility()
    }
    func pop() {
        if !path.isEmpty {
            _ = path.removeLast()
            updateTabBarVisibility()
        }
    }
    func popToRoot() {
        path.removeAll()
        updateTabBarVisibility()
    }
    
    private func updateTabBarVisibility() {
        guard let last = path.last else {
            rootRouter?.setTabBarHidden(false)
            return
        }

        switch last {
        case .settings:
            rootRouter?.setTabBarHidden(true)
        }
    }

}
