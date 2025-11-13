//
//  OrdersCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import Foundation

final class OrdersCoordinator {
    
    private var router: OrdersRouter
    
    init(router: OrdersRouter) {
        self.router = router
    }
    
    func goToDetailHistoryOrder(order: FullOrder) {
        router.push(.detailHistory(order: order))
    }
    
    func goToDetailActiveOrder(order: FullOrder) {
        router.push(.detailActive(order: order))
    }
    
    func chat(order: FullOrder) {
        router.push(.chat(order: order))
    }
}
