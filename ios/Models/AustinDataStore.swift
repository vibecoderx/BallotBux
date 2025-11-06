//
//  AustinDataStore.swift
//  VoteVault
//

import Foundation

// MARK: - Austin Mayoral Candidate Data Model

struct AustinMayoralCandidate: Identifiable {
    var id: String { name }
    let name: String
    let query_name: String
}

// MARK: - Austin Mayoral Election Data Store (Placeholder)

// Note: This is placeholder data. Committee IDs and names are invented.
let austinMayoralElectionData: [String: [AustinMayoralCandidate]] = [

    "2024": [
        AustinMayoralCandidate(name: "Kirk Watson", query_name: "Watson, Kirk P."),
        AustinMayoralCandidate(name: "Carmen Llanes-Pulido", query_name: "Llanes-Pulido, Carmen D."),
        AustinMayoralCandidate(name: "Kathie Tovo", query_name: "Tovo, Kathryne Beth"),
        AustinMayoralCandidate(name: "Jeffrey Bowen", query_name: "Bowen, Jeffery L.")
    ],
    
    "2022": [
        AustinMayoralCandidate(name: "Kirk Watson", query_name: "Watson, Kirk P."),
        AustinMayoralCandidate(name: "Celia Israel", query_name: "Israel, Celia M."),  //
        AustinMayoralCandidate(name: "Jennifer Virden", query_name: "Virden, Jennifer M"),
    ],

    "2018": [
        AustinMayoralCandidate(name: "Steve Adler", query_name: "Adler, Stephen"),
        AustinMayoralCandidate(name: "Laura Morrison", query_name: "Morrison, Laura")
    ]
]

// MARK: - Helper Functions

// Function to easily get candidates for a specific year
func getAustinMayoralCandidates(for year: String) -> [AustinMayoralCandidate] {
    return austinMayoralElectionData[year] ?? []
}

// Function to get available election years (as Strings, sorted descending)
func getAustinMayoralElectionYears() -> [String] {
    return austinMayoralElectionData.keys.sorted(by: >)
}
