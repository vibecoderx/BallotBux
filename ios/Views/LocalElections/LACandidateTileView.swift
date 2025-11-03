//
//  LACandidateTileView.swift
//  VoteVault
//
//  This view displays a single LA mayoral candidate in a list.
//

import SwiftUI

struct LACandidateTileView: View {
    let candidate: LAMayoralCandidate

    // Determine color based on party string (handles optional)
    private var backgroundColor: Color {
        let partyLower = candidate.party.lowercased()
        
        if partyLower.contains("democratic") {
            return Color.blue
        } else if partyLower.contains("republican") {
            return Color.red
        } else if partyLower.contains("independent") {
            return Color.gray
        } else {
            return Color(UIColor.lightGray) // Default
        }
    }

    private var textColor: Color {
        return .white
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(candidate.name)
                    .font(.title2).bold()
                // Display the party, or "N/A" if nil
                Text(candidate.party)
                    .font(.subheadline)
                 // Display Committee ID
                 Text("Committee ID: \(candidate.committeeId)")
                     .font(.caption)
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

struct LACandidateTileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCandidate = LAMayoralCandidate(
            name: "Karen Bass",
            party: "Democratic",
            committeeId: "1441328",
            committeeName: "Karen Bass for Mayor 2022"
        )
        LACandidateTileView(candidate: sampleCandidate)
            .padding()
    }
}
