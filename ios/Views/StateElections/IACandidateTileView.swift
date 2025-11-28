//
//  IACandidateTileView.swift
//  VoteVault
//

import SwiftUI

struct IACandidateTileView: View {
    let candidate: IACandidateInfo

    private var backgroundColor: Color {
        switch candidate.party.lowercased() {
        case "democratic":
            return Color.blue
        case "republican":
            return Color.red
        case "libertarian":
            return Color.orange
        default:
            return Color(UIColor.lightGray)
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
                Text(candidate.party)
                    .font(.subheadline)
                Text("Committee ID: " + candidate.committee_id)
                    .font(.caption)
                    .opacity(0.8)
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
