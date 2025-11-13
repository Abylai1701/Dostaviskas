//
//  FullDetailCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import Foundation

protocol FullDetailCoordinatorProtocol {
    func pop()
    func finish()
    func chat(order: FullOrder)
}

final class FullDetailCoordinator: FullDetailCoordinatorProtocol {
    
    private var router: MainRouter
    
    init(router: MainRouter) {
        self.router = router
    }
    
    func pop() {
        router.pop()
    }
    
    func finish() {
        router.popToRoot()
    }
    
    func chat(order: FullOrder) {
        router.push(.chat(order: order))
    }
}

final class FullDetailCoordinatorForOrders: FullDetailCoordinatorProtocol {
    
    private var router: OrdersRouter
    
    init(router: OrdersRouter) {
        self.router = router
    }
    
    func pop() {
        router.pop()
    }
    
    func finish() {
        router.popToRoot()
    }
    
    func chat(order: FullOrder) {
        router.push(.chat(order: order))
    }
}
