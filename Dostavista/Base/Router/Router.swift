import SwiftUI
import Observation
import Combine

// MARK: - ROUTER

import Foundation

enum Route: Hashable {
    case auth
    case main
}

final class Router: ObservableObject {
    @Published var path: [Route] = []

    init() {
        print("Create Router")
    }
    
    deinit {
        print("Kill Router")
    }
    func push(_ route: Route) { path.append(route) }
    func pop() { if !path.isEmpty { _ = path.removeLast() } }
    func popToRoot() { path.removeAll() }
}
