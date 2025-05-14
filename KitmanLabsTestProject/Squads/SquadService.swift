//
//  SquadService.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 14/05/2025.
//

import Foundation

protocol SquadService {
    func getSquads() async throws -> [Squad]
}

struct Squad: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let organisationId: Int
    let createdAt: Date
    let updatedAt: Date
    let name: String
}


class NetworkSquadService: SquadService {
    let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func getSquads() async throws -> [Squad] {
        return try await client.sendGetRequest(toPath: "squads", responseType: [Squad].self)
    }
}
