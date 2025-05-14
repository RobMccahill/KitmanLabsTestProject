//
//  LoginService.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import Foundation

protocol LoginService {
    ///Attempts to log in using the passed username and password
    ///Returns void on success, otherwise throws an error
    func logIn(username: String, password: String) async throws -> Void
}

class NetworkLoginService: LoginService {
    let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func logIn(username: String, password: String) async throws {
        let body = LoginRequestBody(username: username, password: password)
        let (_, response) = try await client.sendPostRequest(toPath: "session", body: body)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            return
        } else {
            throw NetworkClient.HTTPClientError.requestFailed
        }
    }
}

fileprivate extension NetworkLoginService {
    struct LoginRequestBody: Encodable {
        let username: String
        let password: String
    }
}
