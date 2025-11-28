//
//  IACandidateListView.swift
//  VoteVault
//

import SwiftUI

struct IACandidateListView: View {
    let office: String
    let year: Int

    private var candidates: [IACandidateInfo] {
        return getIACandidates(office: office, year: year)
    }

    var body: some View {
        VStack {
            if candidates.isEmpty {
                Text("No candidates found for this selection.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(candidates) { candidate in
                    NavigationLink(destination: IACandidateDetailView(candidate: candidate)) {
                        IACandidateTileView(candidate: candidate)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(year) \(office) Race")
        .navigationBarTitleDisplayMode(.inline)
    }
}
