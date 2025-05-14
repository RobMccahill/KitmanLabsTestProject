//
//  NetworkClient.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import Foundation

class NetworkClient {
    private let urlSession: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let baseURL: URL
    
    init(
        baseURL: URL,
        urlSession: URLSession = .shared,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.encoder = encoder
        self.decoder = decoder
        self.baseURL = baseURL
    }
    
    func sendGetRequest<Response: Decodable>(toPath path: any StringProtocol, responseType: Response.Type) async throws -> Response {
        let url = baseURL.appending(path: path)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await urlSession.data(for: request)
        
        return try decoder.decode(responseType, from: data)
    }
    
    func sendPostRequest(toPath path: any StringProtocol, body: Encodable) async throws -> (Data, URLResponse) {
        let url = baseURL.appending(path: path)
        let bodyData = try encoder.encode(body)
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return try await urlSession.data(for: request)
    }
}

extension NetworkClient {
    enum HTTPClientError: Error {
        case requestFailed
    }
}
