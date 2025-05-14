//
//  AppSession.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import Foundation

class AppSession {
    let client: NetworkClient
    let loginService: LoginService
    let athletesService: AthletesService
    let squadService: SquadService
    
    init(client: NetworkClient = NetworkClient(baseURL: Constants.baseURL, decoder: Constants.snakeCaseJSONDecoder)) {
        self.client = client
        self.loginService = NetworkLoginService(client: client)
        self.athletesService = NetworkAthletesService(client: client)
        self.squadService = NetworkSquadService(client: client)
    }
}
