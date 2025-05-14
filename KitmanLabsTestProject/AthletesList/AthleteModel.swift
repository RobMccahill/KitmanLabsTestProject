//
//  AthleteModel.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import Foundation

struct AthleteModel: Equatable, Identifiable, Hashable {
    let id: Int
    let name: String
    let squads: [Int: Squad]
    let imageURL: URL?
}

extension AthleteModel {
    init(from athlete: Athlete, squads: [Int: Squad]) {
        self.id = athlete.id
        self.name = [athlete.firstName, athlete.lastName].joined(separator: " ")
        self.squads = squads
        self.imageURL = URL(string: athlete.image.url)
    }
}
