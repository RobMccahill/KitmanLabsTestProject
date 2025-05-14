//
//  AthletesService.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import Foundation

protocol AthletesService {
    func getAthletes() async throws -> [Athlete]
}

struct Athlete: Codable {
    let id: Int
    let username: String
    let firstName: String
    let lastName: String
    let squadIds: [Int]
    let image: Image
    
    struct Image: Codable {
        let url: String
    }
}


class NetworkAthletesService: AthletesService {
    let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func getAthletes() async throws -> [Athlete] {
        return try await client.sendGetRequest(toPath: "athletes", responseType: [Athlete].self)
    }
}
