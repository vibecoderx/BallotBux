//
//  AustinElectionYearsView.swift
//  VoteVault
//

import SwiftUI

struct AustinElectionYearsView: View {
    // Fetch years from the Austin data store
    let electionYears = getAustinMayoralElectionYears() // Returns [String]

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
                        NavigationLink(destination: AustinCandidateListView(year: year)) {
                            ElectionTypeRow(title: "\(year) Election", icon: "calendar")
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding(.top)
        }
        .navigationTitle("Austin Mayoral Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AustinElectionYearsView_Previews: PreviewProvider {
    static var previews: some View {
        AustinElectionYearsView()
    }
}
