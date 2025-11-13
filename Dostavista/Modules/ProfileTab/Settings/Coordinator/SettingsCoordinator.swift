//
//  SettingsCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 11.11.2025.
//

import Foundation

protocol SettingsCoordinatorProtocol: AnyObject {
    func pop()
}

final class SettingsCoordinator: SettingsCoordinatorProtocol {
    
    private let router: ProfileRouter
    
    init(router: ProfileRouter) {
        self.router = router
    }
    
    func pop() {
        router.pop()
    }
}
