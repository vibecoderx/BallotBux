//
//  IAElectionYearsView.swift
//  VoteVault
//

import SwiftUI

struct IAElectionYearsView: View {
    let office: String
    
    // Dynamically fetch years available for the selected office
    private var electionYears: [Int] {
        return getIAElectionYears(for: office)
    }
    
    var body: some View {
        VStack {
            if electionYears.isEmpty {
                Text("No election data found for this office.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                VStack(spacing: 20) {
                    Text("Select an Election Year")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    List(electionYears, id: \.self) { year in
                        NavigationLink(destination: IACandidateListView(office: office, year: year)) {
                            ElectionTypeRow(title: "\(year) Election", icon: "calendar")
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(.top)
            }
        }
        .navigationTitle(office)
        .navigationBarTitleDisplayMode(.inline)
    }
}
