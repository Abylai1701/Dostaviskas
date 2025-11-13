//
//  ChatCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import Foundation

protocol ChatCoordinatorProtocol: AnyObject {
    func pop()
}

final class MainChatCoordinator: ChatCoordinatorProtocol {
    
    private let router: MainRouter
    
    init(router: MainRouter) {
        self.router = router
    }
    
    func pop() {
        router.pop()
    }
}

final class OrdersChatCoordinator: ChatCoordinatorProtocol {
    
    private let router: OrdersRouter
    
    init(router: OrdersRouter) {
        self.router = router
    }
    
    func pop() {
        router.pop()
    }
}
