//
//  OrdersNavigationHost.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import SwiftUI
import Combine

struct OrdersNavigationHost: View {
    @ObservedObject var router: OrdersRouter
    let vm: OrdersViewModel
    
    var body: some View {
        NavigationStack(path: $router.path) {
            OrdersView(vm: vm)
                .navigationDestination(for: OrdersRoute.self) { route in
                    switch route {
                    case .detailHistory(let order):
                        OrderDetailView(order: order, router: router)
                    case .detailActive(let order):
                        OrderDetailView(order: order, router: router)
                    case .chat(let order):
                        ChatView(routerForOrders: router, order: order)
                    case .detailFull(let order):
                        FullDetailView(ordersRouter: router, order: order)
                    case .orderMap(order: let order):
                        OrderMapViewForOrders(order: order, router: router)
                    }
                }
        }
    }
}


enum OrdersRoute: Hashable {
    case detailActive(order: FullOrder)
    case detailHistory(order: FullOrder)
    case chat(order: FullOrder)
    case detailFull(order: FullOrder)
    case orderMap(order: FullOrder)
}

final class OrdersRouter: ObservableObject {
    @Published var path: [OrdersRoute] = []
    weak var rootRouter: RootRouter?

    func push(_ route: OrdersRoute) {
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
        case .detailActive, .detailHistory, .chat, .detailFull, .orderMap:
            rootRouter?.setTabBarHidden(true)
        }
    }

}
