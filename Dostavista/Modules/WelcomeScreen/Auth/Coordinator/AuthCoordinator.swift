//
//  AuthCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 07.11.2025.
//

import Foundation

protocol AuthCoordinatorProtocol {
    func goToApp()
    func pop()
}

final class AuthCoordinator: AuthCoordinatorProtocol {
    
    private var router: AuthRouter
    
    init(router: AuthRouter) {
        self.router = router
    }
    
    
    func goToApp() {
        print("GoToApp")
    }
    
    func pop() {
        print("AuthCoordinator.pop router:", ObjectIdentifier(router))
        router.pop()
    }
}
