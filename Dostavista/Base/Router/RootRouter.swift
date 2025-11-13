//
//  RootRouter.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 09.11.2025.
//

import Foundation
import SwiftUI
import Combine

final class RootRouter: ObservableObject {
    @Published var isTabBarHidden: Bool = false

    func setTabBarHidden(_ hidden: Bool, animated: Bool = true) {
        withAnimation(animated ? .easeInOut(duration: 0.25) : nil) {
            isTabBarHidden = hidden
        }
    }
}
