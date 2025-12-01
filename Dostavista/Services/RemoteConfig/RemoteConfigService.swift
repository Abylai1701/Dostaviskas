//
//  RemoteConfigService.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 01.12.2025.
//

import Foundation
import FirebaseRemoteConfig

final class RemoteConfigService {
    static let shared = RemoteConfigService()
    
    private let rc = RemoteConfig.remoteConfig()
    
    private init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        rc.configSettings = settings
        
        rc.setDefaults([
            "telegram_bot_url": "www.google.com" as NSObject
        ])
    }
    
    func fetchAndActivate() async throws {
        let status = try await rc.fetchAndActivate()
        print("✅ Remote Config fetched: \(status)")
    }
    
    var tg: String {
        rc["telegram_bot_url"].stringValue
    }
}
