//
//  AthleteDetailView.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import SwiftUI

struct AthleteDetailView: View {
    let athlete: AthleteModel
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: athlete.imageURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .cornerRadius(25)
                Text(athlete.name)
                    .font(.title)
                    .fontWeight(.bold)
                
            }.padding(.top, 24)
            Text("Squads: \(athlete.squads.values.map(\.name).joined(separator: ", "))")
            Spacer()
        }.padding(.top, 24)
    }
}

#Preview {
    AthleteDetailView(athlete: .init(
        id: 1,
        name: "Adam Beard",
        squads: [1 : Squad(id: 1, organisationId: 1, createdAt: Date(), updatedAt: Date(), name: "Staff")],
        imageURL: URL(string: "https://kitman.imgix.net/avatar.jpg")!
    ))
}
