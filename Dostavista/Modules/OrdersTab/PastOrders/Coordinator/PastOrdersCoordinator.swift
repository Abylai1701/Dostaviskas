//
//  PastOrdersCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import Foundation

final class PastOrdersCoordinator {
    private let router: OrdersRouter
    
    init(router: OrdersRouter) {
        self.router = router
    }
    
    func pop() {
        router.pop()
    }
}
