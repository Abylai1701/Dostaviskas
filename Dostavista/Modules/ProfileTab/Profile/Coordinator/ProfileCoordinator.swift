//
//  ProfileCoordinator.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 11.11.2025.
//

import Foundation

protocol ProfileCoordinatorProtocol: AnyObject {
    func settings()
}


final class ProfileCoordinator: ProfileCoordinatorProtocol {
    
    private let router: ProfileRouter
    
    init(router: ProfileRouter) {
        self.router = router
    }
    
    func settings() {
        router.push(.settings)
    }
}
