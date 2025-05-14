//
//  AthletesListView.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import SwiftUI

struct AthletesListView: View {
    @State var viewModel: AthletesListViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.viewState {
            case .waiting:
                EmptyView()
            case .loading:
                ProgressView()
            case .completed(let athletes, let squads):
                    ScrollView {
                        VStack {
                            VStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        Text("Squads: ")
                                        ForEach(squads) { squad in
                                            let squadIsSelected = viewModel.squadIdsToFilter.contains(squad.id)
                                            let backgroundColor = squadIsSelected ? Color.accentColor : Color.gray
                                            let textColor = squadIsSelected ? Color.white : Color.white
                                            Button(squad.name) {
                                                if squadIsSelected {
                                                    viewModel.squadIdsToFilter.remove(squad.id)
                                                } else {
                                                    viewModel.squadIdsToFilter.insert(squad.id)
                                                }
                                                
                                            }
                                            .buttonStyle(.plain)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(backgroundColor)
                                            .clipShape(Capsule())
                                            .foregroundStyle(textColor)
                                            
                                        }
                                    }
                                }.padding(4)
                            }
                            if !athletes.isEmpty {
                                ForEach(athletes) { athlete in
                                    AthleteItemView(athlete: athlete)
                                        .onTapGesture {
                                            viewModel.onAthleteSelected(athlete)
                                        }
                                }.animation(.easeInOut, value: viewModel.viewState)
                            } else {
                                Text("No athletes were found")
                            }
                        }
                    }.padding()
            case .error(let message):
                Text("An error occurred: \(message)")
            }
        }
        .navigationTitle("Athletes")
        .searchable(text: $viewModel.searchQuery, prompt: "Search")
        .onChange(of: viewModel.squadIdsToFilter, {
            Task {
                await viewModel.getAthletes()
            }
        })
        .onChange(of: viewModel.searchQuery) {
            Task {
                await viewModel.getAthletes()
            }
        }
        .onAppear {
            Task {
                await viewModel.getAthletes()
            }
        }
    }
}

struct AthleteItemView: View {
    let athlete: AthleteModel
    
    var body: some View {
        HStack {
            AsyncImage(url: athlete.imageURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .cornerRadius(10)
            Text(athlete.name)
            Spacer()
        }
    }
}

class PreviewAthletesService: AthletesService {
    private static let sampleAthletes: [Athlete] = .init(repeating:
        Athlete(
            id: 1964,
            username: "abeardathlete",
            firstName: "Adam",
            lastName: "Beard",
            squadIds: [1],
            image: .init(url: "https://kitman.imgix.net/avatar.jpg")
        ), count: 30)
    
    let athletes: [Athlete]
    
    init(athletes: [Athlete] = PreviewAthletesService.sampleAthletes) {
        self.athletes = athletes
    }
    
    func getAthletes() async throws -> [Athlete] {
        return athletes
    }
}

class PreviewSquadService: SquadService {
    private static let sampleSquads: [Squad] = [
        Squad(id: 1, organisationId: 1, createdAt: Date(), updatedAt: Date(), name: "Staff"),
        Squad(id: 2, organisationId: 2, createdAt: Date(), updatedAt: Date(), name: "Players")
    ]
    private let squads: [Squad]
    
    init(squads: [Squad] = PreviewSquadService.sampleSquads) {
        self.squads = squads
    }
    
    func getSquads() async throws -> [Squad] {
        return squads
    }
}

#Preview {
    NavigationStack {
        AthletesListView(viewModel: AthletesListViewModel(athletesService: PreviewAthletesService(), squadService: PreviewSquadService()))
            .padding()
    }
}
