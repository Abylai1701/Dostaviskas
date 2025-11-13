//
//  AuthModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import Foundation

struct AuthResponse: Decodable {
    let access_token: String
    let token_type: String
}
