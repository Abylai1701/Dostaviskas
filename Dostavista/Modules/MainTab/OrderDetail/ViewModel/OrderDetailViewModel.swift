//
//  OrderDetailViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 09.11.2025.
//

import Foundation
import Observation

@Observable
final class OrderDetailViewModel {
    var text = "Hello, World!"
    private let coordinator: OrderDetailCoordinatorProtocol
    let order: FullOrder
    
    init(coordinator: OrderDetailCoordinatorProtocol, order: FullOrder) {
        self.coordinator = coordinator
        self.order = order
    }
    
    func pop() {
        coordinator.pop()
    }
    
    func push() {
        coordinator.push(order: order)
    }
    
    func openMap() {
        coordinator.openMap(for: order)
    }
    
    func openChat() {
        coordinator.chat(order: order)
    }
}
