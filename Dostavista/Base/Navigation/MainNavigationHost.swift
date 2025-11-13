//
//  MainNavigationHost.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import SwiftUI
import Combine

struct MainNavigationHost: View {
    @ObservedObject var router: MainRouter
    let vm: MainViewModel
    
    var body: some View {
        NavigationStack(path: $router.path) {
            MainView(vm: vm)
                .navigationDestination(for: MainRoute.self) { route in
                    switch route {
                    case .detail(let order):
                        OrderDetailView(order: order, router: router)
                    case .detailFull(let order):
                        FullDetailView(router: router, order: order)
                    case .orderMap(let order):
                        OrderMapView(order: order, router: router)
                    case .chat(let order):
                        ChatView(router: router, order: order)
                    }
                }
        }
    }
}


enum MainRoute: Hashable {
    case detail(order: FullOrder)
    case detailFull(order: FullOrder)
    case orderMap(order: FullOrder)
    case chat(order: FullOrder)
}

final class MainRouter: ObservableObject {
    @Published var path: [MainRoute] = []
    weak var rootRouter: RootRouter?

    func push(_ route: MainRoute) {
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
        case .detail, .detailFull, .orderMap, .chat:
            rootRouter?.setTabBarHidden(true)
        }
    }

}
