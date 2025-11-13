//
//  PhoneTextField.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 07.11.2025.
//

import Foundation
import SwiftUI

struct PhoneMaskField: View {
    @Binding var phone: String
    @Binding var rawDigits: String
    
    var body: some View {
        UITextFieldWrapper(text: $phone, rawDigits: $rawDigits)
            .frame(height: 54)
            .padding(.leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
            )
    }
}

// MARK: - UIKit UITextField inside SwiftUI
fileprivate struct UITextFieldWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var rawDigits: String
    
    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.textContentType = .telephoneNumber
        field.font = .systemFont(ofSize: 17, weight: .medium)
        field.textColor = .black
        field.delegate = context.coordinator
        // Инициализируем из текущего биндинга, если пусто — "+7 "
        field.text = text.isEmpty ? "+7 " : text
        return field
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        // синхронизируем при обновлениях
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: UITextFieldWrapper
        init(_ parent: UITextFieldWrapper) { self.parent = parent }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Удаление (backspace)
            if string.isEmpty {
                var currentDigits = parent.rawDigits
                if !currentDigits.isEmpty {
                    currentDigits.removeLast()
                }
                if currentDigits.isEmpty {
                    currentDigits = "7"
                }
                parent.rawDigits = currentDigits
                let formatted = Self.formatRuPhone(from: currentDigits)
                parent.text = formatted
                textField.text = formatted
                return false
            }
            
            // Только цифры
            guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
            
            // Текущий ввод
            var newDigits = parent.rawDigits + string
            
            // Принудительная 7 в начале
            if newDigits.isEmpty {
                newDigits = "7"
            } else if newDigits.first != "7" {
                // убираем все '7' и добавляем одну ведущую
                newDigits.removeAll(where: { $0 == "7" })
                newDigits = "7" + newDigits
            }
            
            // Ограничиваем 11 цифрами
            if newDigits.count > 11 {
                newDigits = String(newDigits.prefix(11))
            }
            
            parent.rawDigits = newDigits
            
            // Форматируем
            let formatted = Self.formatRuPhone(from: newDigits)
            parent.text = formatted
            textField.text = formatted
            
            return false
        }
        
        static func formatRuPhone(from digits: String) -> String {
            let numbers = Array(digits.dropFirst()) // без первой 7
            var result = "+7"
            
            // Обязательный пробел после +7
            result += " "
            if numbers.isEmpty { return result }
            
            // Открывающая скобка и первые 3 цифры
            result += "("
            for i in 0..<min(numbers.count, 3) {
                result.append(numbers[i])
            }
            // Закрывающая скобка после третьей цифры
            if numbers.count >= 3 { result += ")" }
            
            // Следующие группы: 3 2 2
            if numbers.count > 3 {
                result += " "
                for i in 3..<min(numbers.count, 6) {
                    result.append(numbers[i])
                }
            }
            
            if numbers.count > 6 {
                result += " "
                for i in 6..<min(numbers.count, 8) {
                    result.append(numbers[i])
                }
            }
            
            if numbers.count > 8 {
                result += " "
                for i in 8..<min(numbers.count, 10) {
                    result.append(numbers[i])
                }
            }
            
            return result
        }
    }
}

