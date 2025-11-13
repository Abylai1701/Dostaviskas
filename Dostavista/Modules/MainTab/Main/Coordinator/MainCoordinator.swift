//
//  MainCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import Foundation

protocol MainCoordinatorProtocol {
    func seeDetails(for order: FullOrder)
}

final class MainCoordinator: MainCoordinatorProtocol {
    private var router: MainRouter
    
    init(router: MainRouter) {
        self.router = router
    }
    
    func seeDetails(for order: FullOrder) {
        router.push(.detail(order: order))
    }
}
