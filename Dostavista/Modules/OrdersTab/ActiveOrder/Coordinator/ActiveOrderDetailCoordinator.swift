//
//  ActiveOrderDetailCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import Foundation

final class ActiveOrderDetailCoordinator: OrderDetailCoordinatorProtocol {
    
    private var router: OrdersRouter
    
    init(router: OrdersRouter) {
        self.router = router
    }

    func pop() {
        router.pop()
    }
    
    func push(order: FullOrder) {
        router.push(.detailFull(order: order))
    }
    
    func openMap(for order: FullOrder) {
        router.push(.orderMap(order: order))
    }
    
    func chat(order: FullOrder) {
        router.push(.chat(order: order))
    }
}
