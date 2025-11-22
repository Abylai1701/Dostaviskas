//
//  RegisterCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import Foundation

protocol RegisterCoordinatorProtocol: AnyObject {
    func pop()
    func start()
}

final class RegisterCoordinator: RegisterCoordinatorProtocol {
    
    private let router: AuthRouter
    
    init(router: AuthRouter) {
        self.router = router
    }
    
    func pop() {
        print("RegisterCoordinator.pop router:", ObjectIdentifier(router))
        router.pop()
    }
    func start() {
    }
}
