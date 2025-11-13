//
//  OrdersViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import Foundation
import Observation

@Observable
final class OrdersViewModel {
    
    private let coordinator: OrdersCoordinator
    var orders: [FullOrder] = []

    init(coordinator: OrdersCoordinator) {
        self.coordinator = coordinator
        loadMockOrders()
    }
    
    func goToHistoryDetail(order: FullOrder) {
        coordinator.goToDetailHistoryOrder(order: order)
    }
    
    func goToActiveDetail(order: FullOrder) {
        coordinator.goToDetailActiveOrder(order: order)
    }
    
    func chat(order: FullOrder) {
        coordinator.chat(order: order)
    }
    func loadMockOrders() {
        // Пример: загрузка локального файла JSON
        if let url = Bundle.main.url(forResource: "mockData", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let baseOrders = try? JSONDecoder().decode([Order].self, from: data) {
            orders = enrichOrders(baseOrders)
        } else {
            // fallback — создаём мок вручную
            let mockOrder = Order(from_point_lat: 55.75,
                                  from_point_lon: 37.61,
                                  to_point_lat: 55.78,
                                  to_point_lon: 37.62,
                                  city: "Москва",
                                  price_usd: 9.48,
                                  id: 1,
                                  created_at: "2025-11-13T12:00:00Z",
                                  updated_at: "2025-11-13T12:00:00Z")
            orders = enrichOrders([mockOrder])
        }
    }
}
