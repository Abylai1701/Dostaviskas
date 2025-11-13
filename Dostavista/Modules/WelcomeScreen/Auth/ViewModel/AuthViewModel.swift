//
//  AuthViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 07.11.2025.
//

import Foundation
import Observation

@Observable
final class AuthViewModel {
    
    private var coordinator: AuthCoordinatorProtocol
    private let authEnd: () -> Void

    var phoneText: String = "+7 "
    var isLoading: Bool = false
    var errorMessage: String? = nil

    init(coordinator: AuthCoordinatorProtocol, authEnd: @escaping () -> Void) {
        self.coordinator = coordinator
        self.authEnd = authEnd
    }
    
    func pop() {
        coordinator.pop()
    }
    
    @MainActor
    func continueTap(phone: String) {
        Task {
            isLoading = true
            do {
                // 1️⃣ Очищаем номер от всего, кроме цифр
                let digits = phone.filter { "0123456789".contains($0) }
                
                // 2️⃣ Формируем корректный формат
                let formatted = digits.hasPrefix("7") ? "+\(digits)" : "+7\(digits)"
                
                print(formatted)
                // 3️⃣ Отправляем на сервер
                let response = try await NetworkManager.shared.authorizeAsync(phone: formatted)
                
                print("✅ Token:", response.access_token)
                AuthStorage.shared.token = response.access_token
                isLoading = false
                
                authEnd()
            } catch {
                isLoading = false
                errorMessage = "Ошибка подключения. Попробуйте позже."
                print("❌ Error:", error.localizedDescription)
            }
        }
    }
}
