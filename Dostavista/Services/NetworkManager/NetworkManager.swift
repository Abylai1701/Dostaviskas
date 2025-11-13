//
//  NetworkManager.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let baseURL = "https://courier.webberapp.shop/api"
    
    // MARK: - Generic async request
    
    @discardableResult
    private func request<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        let url = baseURL + endpoint
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url,
                       method: method,
                       parameters: parameters,
                       encoding: encoding,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let decoded):
                    continuation.resume(returning: decoded)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Endpoints
    
    func authorizeAsync(phone: String) async throws -> AuthResponse {
        let params: [String: Any] = [
            "phone": phone,
            "password": "password"
        ]
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Content-Type": "application/json"
        ]
        return try await request("/user/authorize",
                                 method: .post,
                                 parameters: params,
                                 encoding: JSONEncoding.default,
                                 headers: headers)
    }
    
    func registerAsync(
        fullName: String,
        city: String,
        phone: String,
        email: String
    ) async throws -> RegisterResponse {
        let params: [String: Any] = [
            "full_name": fullName,
            "city": city,
            "phone": phone,
            "email": email,
            "password": "password"
        ]
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Content-Type": "application/json"
        ]
        return try await request("/user",
                                 method: .post,
                                 parameters: params,
                                 encoding: JSONEncoding.default,
                                 headers: headers)
    }
}

extension NetworkManager {
    func fetchUserProfileAsync() async throws -> RegisterResponse {
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(AuthStorage.shared.token ?? "")"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                baseURL + "/user/me",
                method: .get,
                headers: headers
            )
            .validate()
            .responseDecodable(of: RegisterResponse.self) { response in
                switch response.result {
                case .success(let user):
                    continuation.resume(returning: user)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
