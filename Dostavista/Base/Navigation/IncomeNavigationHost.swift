//
//  IncomeNavigationHost.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import SwiftUI
import Combine

struct IncomeNavigationHost: View {
    @ObservedObject var router: IncomeRouter
    let vm: IncomeViewModel
    
    var body: some View {
        NavigationStack(path: $router.path) {
            IncomeView(vm: vm)
        }
    }
}


enum IncomeRoute: Hashable {
    case none
}

final class IncomeRouter: ObservableObject {
    @Published var path: [IncomeRoute] = []
    weak var rootRouter: RootRouter?

    func push(_ route: IncomeRoute) {
        path.append(route)
    }
    func pop() {
        if !path.isEmpty {
            _ = path.removeLast()
        }
    }
    func popToRoot() {
        path.removeAll()
    }
}
