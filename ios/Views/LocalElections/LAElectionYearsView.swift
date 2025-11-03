//
//  LAElectionYearsView.swift
//  VoteVault
//
//  This view displays the available mayoral election years for Los Angeles.
//

import SwiftUI

struct LAElectionYearsView: View {
    // Fetch years from the LA data store
    let electionYears = getLAMayoralElectionYears() // Returns [String]

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Select an Election Year")
                    .font(.headline)
                    .foregroundColor(.secondary)

                if electionYears.isEmpty {
                    Text("No election data found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List(electionYears, id: \.self) { year in
                        NavigationLink(destination: LACandidateListView(year: year)) {
                            ElectionTypeRow(title: "\(year) Election", icon: "calendar")
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding(.top)
        }
        .navigationTitle("LA Mayoral Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LAElectionYearsView_Previews: PreviewProvider {
    static var previews: some View {
        LAElectionYearsView()
    }
}
