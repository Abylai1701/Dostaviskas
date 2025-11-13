//
//  RegisterModel.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import Foundation

struct RegisterResponse: Decodable {
    let id: String
    let full_name: String
    let city: String
    let phone: String
    let email: String
}
