//
//  MainModels.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 13.11.2025.
//

import Foundation

struct Order: Codable {
    let from_point_lat: Double
    let from_point_lon: Double
    let to_point_lat: Double
    let to_point_lon: Double
    let city: String
    let price_usd: Double
    let id: Int
    let created_at: String
    let updated_at: String
}

struct FullOrder: Codable, Hashable {
    let id: Int
    let city: String
    let price_usd: Double
    let from_point_lat: Double
    let from_point_lon: Double
    let to_point_lat: Double
    let to_point_lon: Double
    let created_at: String
    let updated_at: String

    // добавленные поля
    let weight_kg: Int
    let distance_km: Double
    let delivery_minutes: Int
    let from_address: String
    let to_address: String
    let sender_name: String
    let sender_phone: String
    let receiver_name: String
    let receiver_phone: String
    let note: String
    let order_number: String
}

extension FullOrder {
    var toStreet: String {
        let parts = to_address.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        return parts.count > 1 ? parts[1] : to_address
    }
}
func randomRussianName() -> String {
    let names = ["Александр", "Дмитрий", "Иван", "Сергей", "Андрей", "Николай", "Олег", "Павел", "Евгений", "Максим",
                 "Мария", "Анна", "Екатерина", "Ольга", "Наталья", "Татьяна", "Виктория", "Светлана", "Юлия", "Елена"]
    return names.randomElement()!
}

func randomPhone() -> String {
    let prefix = ["+7901", "+7902", "+7903", "+7905", "+7906", "+7909", "+7911", "+7912", "+7921", "+7926", "+7950"].randomElement()!
    let number = (0..<7).map { _ in String(Int.random(in: 0...9)) }.joined()
    return prefix + number
}

func randomStreet() -> String {
    let streets = [
        "Ленина", "Пушкина", "Гагарина", "Советская", "Центральная",
        "Тургенева", "Мира", "Кирова", "Космонавтов", "Школьная",
        "Зеленая", "Полевая", "Набережная", "Парковая", "Садовая"
    ]
    let house = Int.random(in: 1...120)
    return "\(streets.randomElement()!) \(house)"
}

let notesList: [String] = [
    "Домофон 125, подъезд 3, квартира 47, звонить за 5 минут.",
    "Оставить у двери, звонить не нужно — всё видно с камеры.",
    "Подъезд справа, лифт не работает — 5 этаж, пешком.",
    "Домофон не работает, позвонить на мобильный +79213562325.",
    "Оставить на балконе, дверь открыта — ключ под ковриком.",
    "Квартира 112, 2 этаж, звонить, когда на лестничной площадке.",
    "Нет домофона, сказать «Андрей» — сосед откроет.",
    "Оставить в почтовом ящике.",
    "Подъезд с торца, красная дверь, 4 этаж, звонить за 10 минут.",
    "У двери есть корзина — оставить туда, спасибо!",
    "Не звонить после 22:00 — дети спят.",
    "Домофон 302, код 1737, если не работает — нажать «звонок» 3 раза.",
    "Оставить у соседа 111 — скажите, что от курьера.",
    "На входе — табличка «Инсомниа», подняться на 3 этаж, дверь с синей ручкой.",
    "Если не могу открыть — оставить в шкафу у входа, ключ под цветочным горшком."
]

func enrichOrders(_ orders: [Order]) -> [FullOrder] {
    return orders.enumerated().map { index, order in
        FullOrder(
            id: order.id,
            city: order.city,
            price_usd: order.price_usd,
            from_point_lat: order.from_point_lat,
            from_point_lon: order.from_point_lon,
            to_point_lat: order.to_point_lat,
            to_point_lon: order.to_point_lon,
            created_at: order.created_at,
            updated_at: order.updated_at,
            weight_kg: Int.random(in: 1...10),
            distance_km: Double.random(in: 2...10).rounded(toPlaces: 2),
            delivery_minutes: Int.random(in: 15...60),
            from_address: "\(order.city), \(randomStreet())",
            to_address: "\(order.city), \(randomStreet())",
            sender_name: randomRussianName(),
            sender_phone: randomPhone(),
            receiver_name: randomRussianName(),
            receiver_phone: randomPhone(),
            note: notesList.randomElement() ?? "Без заметки",
            order_number: "#A" + String(format: "%03d", index + 1)
        )
    }
}


extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
