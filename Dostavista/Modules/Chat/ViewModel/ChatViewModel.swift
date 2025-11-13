//
//  ChatViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import Foundation
import Observation
import StoreKit

@Observable
final class ChatViewModel {
    private let coordinator: ChatCoordinatorProtocol
    private let intercom = IntercomService()
    
    var messages: [Message] = []
    var text: String = ""
    var contactId: String?
    
    init(coordinator: ChatCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func pop() { coordinator.pop() }
    
    // Инициализация контакта
    func startChat(email: String) async {
        do {
            contactId = try await intercom.getOrCreateContact(email: email)
        } catch {
            print("❌ Не удалось получить контакт:", error)
        }
    }
    
    // Отправка
    func sendMessage() async {
        guard let contactId, !text.isEmpty else { return }
        let currentText = text
        text = ""
        
        // 1) Локально добавляем "отправляется"
        let tempId = UUID().uuidString
        let local = Message(
            id: tempId,
            body: currentText,
            sender: .user,
            status: .sending,
            createdAt: Date()
        )
        messages.append(local)
        
        // 2) Пытаемся отправить
        do {
            try await intercom.sendMessage(from: contactId, text: currentText)
            updateMessageStatus(id: tempId, to: .sent)
        } catch {
            print("❌ Ошибка при отправке:", error)
            updateMessageStatus(id: tempId, to: .failed)
            // По желанию вернём текст в поле ввода:
            // self.text = currentText
        }
    }
    
    // Повторная отправка для сообщения со статусом .failed
    func retrySend(message: Message) async {
        guard message.sender == .user, message.status == .failed, let contactId else { return }
        updateMessageStatus(id: message.id, to: .sending)
        do {
            try await intercom.sendMessage(from: contactId, text: message.body)
            updateMessageStatus(id: message.id, to: .sent)
        } catch {
            updateMessageStatus(id: message.id, to: .failed)
        }
    }
    
    private func updateMessageStatus(id: String, to status: Message.DeliveryStatus) {
        if let i = messages.firstIndex(where: { $0.id == id }) {
            messages[i].status = status
        }
    }
}


struct Message: Identifiable, Codable, Equatable {
    let id: String
    let body: String
    let sender: SenderType
    var status: DeliveryStatus
    let createdAt: Date
    
    enum SenderType: String, Codable {
        case user
        case admin
    }
    
    enum DeliveryStatus: String, Codable {
        case sending
        case sent
        case failed
    }
}
