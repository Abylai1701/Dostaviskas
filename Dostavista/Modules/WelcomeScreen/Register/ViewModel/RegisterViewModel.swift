//
//  RegisterViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import Foundation
import Observation

@Observable
final class RegisterViewModel {
    var city = ""
    var phoneText = "+7 "
    var fioText = ""
    var mail = ""
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    private let coordinator: RegisterCoordinatorProtocol
    private let authEnd: () -> Void
    
    init(coordinator: RegisterCoordinatorProtocol, authEnd: @escaping () -> Void) {
        self.coordinator = coordinator
        self.authEnd = authEnd
    }
    
    func start() {
        coordinator.start()
    }
    
    func pop() {
        coordinator.pop()
    }
    
    func register() {
        
        guard !fioText.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Введите ваше ФИО"
            return
        }
        
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Введите город"
            return
        }
        
        Task {
            isLoading = true
            do {
                // 1️⃣ Очищаем номер от всего, кроме цифр
                let digits = phoneText.filter { "0123456789".contains($0) }
                
                // 2️⃣ Формируем корректный формат
                let formatted = digits.hasPrefix("7") ? "+\(digits)" : "+7\(digits)"
                
                // 3️⃣ Отправляем на сервер
                let response = try await NetworkManager.shared.registerAsync(fullName: fioText, city: city, phone: formatted, email: mail)
                
                print(response)
                
                await continueTap(phone: formatted)
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = "Ошибка подключения. Попробуйте позже."
                print("❌ Error:", error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func continueTap(phone: String) {
        Task {
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
