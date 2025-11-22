//
//  AuthMainViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 07.11.2025.
//

import Foundation
import Observation

@Observable
final class AuthMainViewModel {
    private var coordinator: AuthMainCoordinatorProtocol
    
    init(coordinator: AuthMainCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func signIn() {
        coordinator.goAuth()
    }
    
    func sighUp() {
        coordinator.goRegister()
    }
}
