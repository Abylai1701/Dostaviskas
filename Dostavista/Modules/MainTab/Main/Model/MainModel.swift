//
//  MainModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import Foundation
import MapKit

struct OrderCardData: Identifiable, Hashable {
    let id = UUID()
    var price: String                 // "710 ₽"
    var distance: String              // "2.3 км"
    var eta: String                   // "15 мин"
    var tags: [OrderTag]              // [.urgent, .nearby]
    var fromAddress: String           // "Москва, Тверская, 10"
    var toAddress: String             // "Москва, Пушкина, 5"
    var cargo: String                 // "Посылка 3 кг"
    var timeWindow: String            // "14:00–16:00"
    var paymentBadge: PaymentBadge    // .card
    
    static func mock() -> OrderCardData {
        return .init(
            price: "710 ₽",
            distance: "2.3 км",
            eta: "15 мин",
            tags: [.urgent, .nearby],
            fromAddress: "Москва, Тверская, 10",
            toAddress:   "Москва, Пушкина, 5",
            cargo: "Посылка 3 кг",
            timeWindow: "14:00–16:00",
            paymentBadge: .card
        )
    }
}


struct OrderPoint: Identifiable, Hashable {
    let id = UUID()
    var coord: CLLocationCoordinate2D
    var price: String

    static func == (lhs: OrderPoint, rhs: OrderPoint) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(price)
        hasher.combine(coord.latitude)
        hasher.combine(coord.longitude)
    }
}

