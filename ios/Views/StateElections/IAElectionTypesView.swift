//
//  IAElectionTypesView.swift
//  VoteVault
//

import SwiftUI

struct IAElectionTypesView: View {
    // The keys from our data store represent the offices
    let electionTypes = [
        "Governor",
        "Lt Governor",
        "Attorney General",
        "Secretary of State",
        "State Senate",
        "State House"
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Select an Election Type")
                .font(.headline)
                .foregroundColor(.secondary)

            List(electionTypes, id: \.self) { office in
                NavigationLink(destination: IAElectionYearsView(office: office)) {
                    ElectionTypeRow(title: office, icon: "person.badge.shield.checkmark.fill")
                }
            }
            .listStyle(.plain)
        }
        .padding(.top)
        .navigationTitle("Iowa Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IAElectionTypesView_Previews: PreviewProvider {
    static var previews: some View {
        IAElectionTypesView()
    }
}
