//
//  ProfileViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 11.11.2025.
//

import Foundation
import Observation

@Observable
final class ProfileViewModel {
    private let coordinator: ProfileCoordinatorProtocol
    var onExit: () -> Void
    
    var fullName: String = ""
    var phone: String = ""
    var isLoading = false
    var errorMessage: String?

    init(coordinator: ProfileCoordinatorProtocol, onExit: @escaping () -> Void) {
        self.coordinator = coordinator
        self.onExit = onExit
    }
    
    func openSettings() {
        coordinator.settings()
    }
    
    @MainActor
    func loadProfile() async {
        isLoading = true
        do {
            let user = try await NetworkManager.shared.fetchUserProfileAsync()
            fullName = user.full_name
            phone = user.phone
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Не удалось загрузить профиль"
            print("❌ Profile error:", error.localizedDescription)
        }
    }
}

