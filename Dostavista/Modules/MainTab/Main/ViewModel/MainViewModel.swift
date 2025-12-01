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
    
    private var cities: [City] = []

    init(coordinator: MainCoordinatorProtocol) {
        self.coordinator = coordinator
        
        let center = CLLocationCoordinate2D(latitude: 55.75222, longitude: 37.61556)
        camera = .region(.init(center: center,
                               span: .init(latitudeDelta: 0.04, longitudeDelta: 0.04)))
        
        loadMockOrders(for: "Москва")
    }
    
    private func setupCameraFromUserCity() async {
        do {
            let profile = try await NetworkManager.shared.fetchUserProfileAsync()
            let profileCityName = profile.city.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !profileCityName.isEmpty else { return }

            // Центруем карту
            if let city = cities.first(where: {
                $0.name.compare(profileCityName, options: .caseInsensitive) == .orderedSame
            }) {
                let center = CLLocationCoordinate2D(latitude: city.latt, longitude: city.long)
                camera = .region(.init(center: center,
                                       span: .init(latitudeDelta: 0.04, longitudeDelta: 0.04)))
            }

            // Загружаем 5 моков для этого города (с учётом всех fallback’ов)
            loadMockOrders(for: profileCityName)

        } catch {
            print("fetchUserProfileAsync error: \(error)")
            // при ошибке можно оставить Москву и loadMockOrders(for: "Москва")
            loadMockOrders(for: "Москва")
        }
    }


    
    func onAppear() async {
        loadCities()
        await setupCameraFromUserCity()
    }
    
    private func loadCities() {
        guard cities.isEmpty else { return }
        
        guard let url = Bundle.main.url(forResource: "cities", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([City].self, from: data) else {
            return
        }
        
        self.cities = decoded
    }
    
    func loadMockOrders(for cityName: String) {
        let baseOrders: [Order]

        // 1. Читаем то, что есть в mockData.json (Москва / Питер и т.п.)
        if let url = Bundle.main.url(forResource: "mockData", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Order].self, from: data) {
            baseOrders = decoded
        } else {
            baseOrders = []   // если файла нет — будем полностью генерировать
        }

        // 2. Пытаемся взять реальные заказы для города
        var cityOrders = baseOrders.filter { $0.city == cityName }

        if cityOrders.count >= 5 {
            cityOrders = Array(cityOrders.prefix(5))
        } else if cityOrders.count > 0 {
            // есть 1–4 реальных заказа — дублируем их, чтобы стало 5
            var extended: [Order] = []
            while extended.count < 5 {
                extended.append(cityOrders[extended.count % cityOrders.count])
            }
            cityOrders = extended
        } else {
            // 3. В mockData.json вообще нет этого города — генерируем 5 штук вокруг центра города
            cityOrders = generateSyntheticOrders(for: cityName)
        }

        // 4. Обогащаем и строим точки
        let full = enrichOrders(Array(cityOrders.prefix(5)))
        self.orders = full

        self.points = full.map {
            OrderPoint(
                coord: CLLocationCoordinate2D(
                    latitude: $0.from_point_lat,
                    longitude: $0.from_point_lon
                ),
                price: "\(Int($0.price_usd)) ₽"
            )
        }
    }
    private func generateSyntheticOrders(for cityName: String) -> [Order] {
        // Находим координаты города из cities.json
        let center: CLLocationCoordinate2D

        if let city = cities.first(where: {
            $0.name.compare(cityName, options: .caseInsensitive) == .orderedSame
        }) {
            center = CLLocationCoordinate2D(latitude: city.latt, longitude: city.long)
        } else {
            // если города даже в cities.json нет — fallback Москва
            center = CLLocationCoordinate2D(latitude: 55.75222, longitude: 37.61556)
        }

        // Небольшие смещения от центра, чтобы точки не лежали в одной точке
        let offsets: [(Double, Double)] = [
            ( 0.01,  0.01),
            (-0.01,  0.015),
            ( 0.015, -0.01),
            (-0.012, -0.012),
            ( 0.007, -0.018)
        ]

        var result: [Order] = []

        for (index, offset) in offsets.enumerated() {
            let fromLat = center.latitude + offset.0
            let fromLon = center.longitude + offset.1
            let toLat   = center.latitude - offset.0
            let toLon   = center.longitude - offset.1

            let order = Order(
                from_point_lat: fromLat,
                from_point_lon: fromLon,
                to_point_lat: toLat,
                to_point_lon: toLon,
                city: cityName,
                price_usd: 500 + Double(index) * 150, // любые тестовые суммы
                id: 10_000 + index,
                created_at: "2025-11-13 12:00:00",
                updated_at: "2025-11-13 12:00:00"
            )

            result.append(order)
        }

        return result
    }

    
    func push(order: FullOrder) {
        coordinator.seeDetails(for: order)
    }
}
