//
//  AppHudUserManager.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 17.11.2025.
//

import Foundation
import ApphudSDK
import Security

final class ApphudUserManager {
    
    static let shared = ApphudUserManager()
    private init() {}
        
    // MARK: - Public
    
    @MainActor
    func start() {
        Apphud.start(apiKey: "app_AcJn8ymNjMtQT5Nn9d4frQVu85Edsj")
    }
}
