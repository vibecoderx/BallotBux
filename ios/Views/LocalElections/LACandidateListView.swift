//
//  LACandidateListView.swift
//  VoteVault
//
//  This view lists the mayoral candidates for a specific year in Los Angeles.
//

import SwiftUI

struct LACandidateListView: View {
    let year: String
    // Fetch candidates for the selected year from the data store
    let candidates: [LAMayoralCandidate]

    init(year: String) {
        self.year = year
        self.candidates = getLAMayoralCandidates(for: year)
    }

    var body: some View {
        VStack {
            if candidates.isEmpty {
                Text("No mayoral candidates found for \(year).")
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            } else {
                List(candidates) { candidate in
                    NavigationLink(destination: LACandidateDetailView(candidate: candidate, year: year)) {
                        LACandidateTileView(candidate: candidate)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(year) Mayoral Race")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LACandidateListView_Previews: PreviewProvider {
    static var previews: some View {
        LACandidateListView(year: "2022")
    }
}
