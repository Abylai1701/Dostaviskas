//
//  IntercomService.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import Foundation

final class IntercomService {
    private let baseURL = URL(string: "https://api.intercom.io")!
    private let token = "Bearer Shefer22311-1112"
    
    private func makeRequest(
        _ path: String,
        method: String = "GET",
        body: [String: Any]? = nil
    ) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        return request
    }

    /// Найти или создать контакт по email
    func getOrCreateContact(email: String) async throws -> String {
        // 1. Попробуем найти
        let findURL = URL(string: "https://api.intercom.io/contacts?email=\(email)")!
        var findReq = URLRequest(url: findURL)
        findReq.httpMethod = "GET"
        findReq.setValue(token, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: findReq)
        
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let dataArr = json["data"] as? [[String: Any]],
           let first = dataArr.first,
           let id = first["id"] as? String {
            return id
        }

        // 2. Если нет — создаём
        let createReq = makeRequest("contacts", method: "POST", body: ["email": email])
        let (createData, _) = try await URLSession.shared.data(for: createReq)
        let obj = try JSONSerialization.jsonObject(with: createData) as? [String: Any]
        return obj?["id"] as? String ?? ""
    }

    /// Отправить сообщение от пользователя
    func sendMessage(from contactId: String, text: String) async throws {
        let body: [String: Any] = [
            "message_type": "inapp",
            "body": text,
            "from": ["type": "contact", "id": contactId]
        ]
        let request = makeRequest("messages", method: "POST", body: body)
        let (_, response) = try await URLSession.shared.data(for: request)
        print(response)
    }
}
