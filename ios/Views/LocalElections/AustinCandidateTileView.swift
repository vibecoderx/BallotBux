//
//  AustinCandidateTileView.swift
//  VoteVault
//

import SwiftUI

struct AustinCandidateTileView: View {
    let candidate: AustinMayoralCandidate

    // Determine color based on party string (handles optional)
    private var backgroundColor: Color {
        // Default for non-partisan or other
        return Color.gray.opacity(0.8)
    }

    private var textColor: Color {
        return .white
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(candidate.name)
                    .font(.title2).bold()
                // Display the party, or "Non-Partisan" if nil
                Text("Non-Partisan")
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(8)
            .padding(.top, -8)
            .padding(.horizontal, -12)
        }
        .padding(.vertical)
    }
}

struct AustinCandidateTileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCandidate = AustinMayoralCandidate(
            name: "Kirk Watson",
            query_name: "Watson, Kirk P."
        )
        AustinCandidateTileView(candidate: sampleCandidate)
            .padding()
    }
}
