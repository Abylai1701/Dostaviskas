//
//  SettingsViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 11.11.2025.
//

import Foundation
import Observation

@Observable
final class SettingsViewModel {
    
    private let coordinator: SettingsCoordinatorProtocol

    init(coordinator: SettingsCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func pop() {
        coordinator.pop()
    }
}
