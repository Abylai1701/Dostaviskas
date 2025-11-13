//
//  PastOrdersViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import Foundation
import Observation

@Observable
final class PastOrdersViewModel {
    private let coordinator: PastOrdersCoordinator
    
    init(coordinator: PastOrdersCoordinator) {
        self.coordinator = coordinator
    }
    
    func pop() {
        coordinator.pop()
    }
}
