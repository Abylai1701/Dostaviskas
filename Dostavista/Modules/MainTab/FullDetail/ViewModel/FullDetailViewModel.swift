//
//  FullDetailViewModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import Foundation
import Observation


@Observable
final class FullDetailViewModel {
        
    enum OrderState: Int, CaseIterable {
        case roadA = 0
        case took
        case roadB
        case finish
    }
    
    enum StepVisual {
        case done, active, idle
    }

    var state: OrderState = .roadA
    
    var buttonTitle: String {
        switch state {
        case .roadA:
            "Я на месте"
        case .took:
            "Груз получен"
        case .roadB:
            "Груз получен"
        case .finish:
            "Завершить заказ"
        }
    }
    
    var firstViewTitle: String {
        switch state {
        case .roadA:
            "Едете к отправителю"
        case .took:
            "Получение груза"
        case .roadB:
            "Едет к получателю"
        case .finish:
            "Доставка груза"
        }
    }
        
    private var coordinator: FullDetailCoordinatorProtocol
    let order: FullOrder

    init(coordinator: FullDetailCoordinatorProtocol, order: FullOrder) {
        self.coordinator = coordinator
        self.order = order
    }
    
    func pop() {
        coordinator.pop()
    }
    
    func finish() {
        coordinator.finish()
    }
    
    func chat() {
        coordinator.chat(order: order)
    }
    
    func advance() {
        guard let next = OrderState(rawValue: state.rawValue + 1) else { return }
        state = next
    }

    func visual(for step: OrderState) -> StepVisual {
        if step.rawValue < state.rawValue { return .done }
        if step == state { return .active }
        return .idle
    }
}
