//
//  AuthMainCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 07.11.2025.
//

import Foundation
import SwiftUI

protocol AuthMainCoordinatorProtocol {
    func goAuth()
    func goRegister()
}

final class AuthMainCoordinator: AuthMainCoordinatorProtocol {
    
    private let router: AuthRouter
    
    init(router: AuthRouter) {
        self.router = router
        
        print("Create AuthMainCoordinator")
    }
    
    deinit {
        print("Kill AuthMainCoordinator")
    }
    
    func goAuth() {
        router.push(.auth)
    }
    
    func goRegister() {
        router.push(.register)
    }
}
