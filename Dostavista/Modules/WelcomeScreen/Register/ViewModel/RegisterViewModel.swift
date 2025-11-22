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
    
    var allCities: [String] = []
    var searchText: String = ""
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    private let coordinator: RegisterCoordinatorProtocol
    private let authEnd: () -> Void
    
    enum Step {
        case phone
        case verify
        case fio
        case city
        case done
    }
    
    var step: Step = .phone

    init(coordinator: RegisterCoordinatorProtocol, authEnd: @escaping () -> Void) {
        self.coordinator = coordinator
        self.authEnd = authEnd
        loadCities()
    }
    
    func loadCities() {
        guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        guard let decoded = try? JSONDecoder().decode([String].self, from: data) else { return }

        self.allCities = decoded
    }

    var filteredCities: [String] {
        if searchText.isEmpty { return allCities }
        return allCities.filter { $0.lowercased().contains(searchText.lowercased()) }
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
                
                step = .done
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = "Ошибка подключения. Попробуйте позже."
                print("❌ Error:", error.localizedDescription)
            }
        }
    }
}
