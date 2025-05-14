//
//  AthletesListViewModel.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import Foundation

@Observable
@MainActor
class AthletesListViewModel {
    private let athletesService: AthletesService
    private let squadsService: SquadService
    var onAthleteSelected: (AthleteModel) -> Void
    private var athletes: [AthleteModel]?
    private var squads: [Int: Squad]?
    
    private(set) var viewState: ViewState = .waiting
    var searchQuery: String = ""
    var squadIdsToFilter: Set<Int> = []
    
    init(athletesService: AthletesService, squadService: SquadService, onAthleteSelected: @escaping (AthleteModel) -> Void = { _ in }) {
        self.athletesService = athletesService
        self.squadsService = squadService
        self.onAthleteSelected = onAthleteSelected
    }
    
    func getAthletes() async {
        if let athletes = athletes, let squads = squads {
            updateViewState(withAthletes: athletes, squads: squads)
            return
        }
        
        guard viewState != .loading else { return }
        
        viewState = .loading
        
        do {
            //creates a dictionary of squads from the response, using the squad ID as the key - it's more awkward to work with, but it is more convenient / faster for looking up a name for a squad, and for filtering out athletes from a list.
            let squads = try await squadsService.getSquads().toDictionary()
            let athletes = try await athletesService.getAthletes().map { athlete in
                //map the squads for each squad id that the athlete is part of
                let athleteSquads = athlete.squadIds.reduce(into: [Int: Squad]()) { athleteSquads, squadId in
                    athleteSquads[squadId] = squads[squadId]
                }
                
                return AthleteModel(from: athlete, squads: athleteSquads)
            }
            
            //cache response for future lookups
            self.squads = squads
            self.athletes = athletes
            
            updateViewState(withAthletes: athletes, squads: squads)
        } catch {
            viewState = .error(message: "Something went wrong")
        }
    }
    
    func updateViewState(withAthletes athletes: [AthleteModel], squads: [Int: Squad]) {
        let filteredAthletes = filterAthletes(athletes: athletes)
        let squadList = Array(squads.values).sorted { $0.id < $1.id }
        viewState = .completed(athletes: filteredAthletes, squads: squadList)
    }
    
    func filterAthletes(athletes: [AthleteModel]) -> [AthleteModel] {
        let query = searchQuery.lowercased()
        let squadIdsToFilter = squadIdsToFilter
        
        return athletes.filter { athlete in
            let athleteMatchesSquad = athlete.squads.keys.contains { id in squadIdsToFilter.contains(id) }
            
            let nameIsValid = query.isEmpty || athlete.name.lowercased().contains(query)
            let squadIsValid = squadIdsToFilter.isEmpty || athleteMatchesSquad
            return nameIsValid && squadIsValid
        }
    }
}

fileprivate extension Collection where Element == Squad {
    func toDictionary() -> [Int: Squad] {
        return self.reduce(into: [Int: Squad]()) { result, squad in
            result[squad.id] = squad
        }
    }
}

extension AthletesListViewModel {
    enum ViewState: Equatable {
        case waiting
        case loading
        case completed(athletes: [AthleteModel], squads: [Squad])
        case error(message: String)
    }
}
