//
//  UserDefaults.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import Foundation

final class AuthStorage {
    static let shared = AuthStorage()
    private init() {}
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: "access_token") }
        set { UserDefaults.standard.setValue(newValue, forKey: "access_token") }
    }
}
