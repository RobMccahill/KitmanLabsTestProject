//
//  KitmanLabsTestProjectApp.swift
//  KitmanLabsTestProject
//
//  Created by Robert Mccahill on 14/05/2025.
//

import SwiftUI

@main
struct KitmanLabsTestProjectApp: App {
    let session = AppSession()
    @State var userLoggedIn: Bool = false
    @State var selectedAthlete: [AthleteModel] = []
    
    var body: some Scene {
        WindowGroup {
            if !userLoggedIn {
                LoginView(viewModel: LoginViewModel(
                    loginService: session.loginService,
                    onLoginSuccess: { _ in userLoggedIn = true }
                ))
            } else {
                NavigationStack(path: $selectedAthlete) {
                    AthletesListView(viewModel: AthletesListViewModel(
                        athletesService: session.athletesService,
                        squadService: session.squadService,
                        onAthleteSelected: { model in selectedAthlete = [model] }
                    ))
                    .navigationDestination(for: AthleteModel.self) { athlete in
                        AthleteDetailView(athlete: athlete)
                    }
                }
            }
            
        }
    }
}

