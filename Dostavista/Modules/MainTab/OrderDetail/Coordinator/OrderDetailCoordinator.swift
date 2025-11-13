//
//  OrderDetailCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 09.11.2025.
//

import Foundation

protocol OrderDetailCoordinatorProtocol {
    func pop()
    func push(order: FullOrder)
    func openMap(for order: FullOrder)
    func chat(order: FullOrder)
}

final class OrderDetailCoordinator: OrderDetailCoordinatorProtocol {
    
    private var router: MainRouter
    
    init(router: MainRouter) {
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
