//
//  MainViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//

import Foundation
import Observation
import MapKit
import _MapKit_SwiftUI

@Observable
final class MainViewModel {
    
    // Map
    var camera: MapCameraPosition
    var points: [OrderPoint] = []
    
    // UI state (sheet + фильтры)
    /// Текущая доля высоты sheet (0…1). Привязываем к снапам.
    var sheetFraction: CGFloat = 0.6
    var orders: [FullOrder] = []
    var selectedFilterIndex: Int = 0
    
    // Конфиг снапов (низ/середина/высоко)
    let snapFractions: [CGFloat] = [0.28, 0.6, 0.98]
    
    var midStop: CGFloat { snapFractions[1] }
    var topStop: CGFloat { snapFractions[2] }
    
    /// Прогресс от середины к верхнему снапу: 0...1
    var expandProgress: CGFloat {
        guard topStop > midStop else { return 0 }
        let p = (sheetFraction - midStop) / (topStop - midStop)
        return max(0, min(1, p))
    }
    
    /// Непрозрачность оверлея (0...0.6)
    var overlayOpacity: Double { Double(expandProgress) * 0.6 }
    
    private var coordinator: MainCoordinatorProtocol
    
    init(coordinator: MainCoordinatorProtocol) {
        self.coordinator = coordinator
        
        let center = CLLocationCoordinate2D(latitude: 55.75222, longitude: 37.61556)
        camera = .region(.init(center: center,
                               span: .init(latitudeDelta: 0.04, longitudeDelta: 0.04)))
        
        loadMockOrders()
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
        
        points = orders
            .prefix(10) // первые 10 заказов
            .map {
                OrderPoint(
                    coord: CLLocationCoordinate2D(
                        latitude: $0.from_point_lat,
                        longitude: $0.from_point_lon
                    ),
                    price: "\(Int($0.price_usd)) ₽"
                )
            }
    }
    
    func push(order: FullOrder) {
        coordinator.seeDetails(for: order)
    }
}
