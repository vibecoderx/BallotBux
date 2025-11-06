//
//  AustinCandidateListView.swift
//  VoteVault
//

import SwiftUI

struct AustinCandidateListView: View {
    let year: String
    // Fetch candidates for the selected year from the data store
    let candidates: [AustinMayoralCandidate]

    init(year: String) {
        self.year = year
        self.candidates = getAustinMayoralCandidates(for: year)
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
                    NavigationLink(destination: AustinCandidateDetailView(candidate: candidate, year: year)) {
                        AustinCandidateTileView(candidate: candidate)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(year) Mayoral Race")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AustinCandidateListView_Previews: PreviewProvider {
    static var previews: some View {
        AustinCandidateListView(year: "2024")
    }
}
