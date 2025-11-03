//
//  LADataStore.swift
//  VoteVault
//

import Foundation

// MARK: - Los Angeles Mayoral Candidate Data Model

struct LAMayoralCandidate: Identifiable {
    var id: String { committeeId } // Use Committee ID as the unique identifier
    let name: String
    let party: String
    let committeeId: String
    let committeeName: String
}

// MARK: - Los Angeles Mayoral Election Data Store

let laMayoralElectionData: [String: [LAMayoralCandidate]] = [

    "2026": [
        LAMayoralCandidate(name: "Karen Bass", party: "Democratic", committeeId: "1471359", committeeName: "Re-Elect Karen Bass for Mayor 2026")
    ],

    "2022": [
        LAMayoralCandidate(name: "Rick Caruso", party: "Democratic", committeeId: "1444972", committeeName: "RICK CARUSO FOR MAYOR 2022"),
        LAMayoralCandidate(name: "Karen Bass", party: "Democratic", committeeId: "1441328", committeeName: "Karen Bass for Mayor 2022")
    ],

    "2017": [
        LAMayoralCandidate(name: "Eric Garcetti", party: "Democratic", committeeId: "1376009", committeeName: "Garcetti for Mayor 2017"),
        LAMayoralCandidate(name: "Mitchell Schwartz", party: "Democratic", committeeId: "1382596", committeeName: "Schwartz for Mayor 2017")
    ],

    "2013": [
        LAMayoralCandidate(name: "Eric Garcetti", party: "Democratic", committeeId: "1341339", committeeName: "Garcetti for Mayor 2013"),
        LAMayoralCandidate(name: "Wendy Greuel", party: "Democratic", committeeId: "1337185", committeeName: "Wendy Greuel for Mayor 2013")
    ],

    "2009": [
        LAMayoralCandidate(name: "Antonio Villaraigosa", party: "Democratic", committeeId: "1305101", committeeName: "Villaraigosa for Mayor 2009"),
        LAMayoralCandidate(name: "Walter Moore", party: "Democratic", committeeId: "1297003", committeeName: "Committee to Elect Walter Moore"),
        LAMayoralCandidate(name: "Gordon Turner", party: "Democratic", committeeId: "1313965", committeeName: "Citizens to Elect Gordon Turner")
    ],

    "2005": [
        LAMayoralCandidate(name: "Antonio Villaraigosa", party: "Democratic", committeeId: "1275257", committeeName: "Villaraigosa for Mayor 2005 - General"),
        LAMayoralCandidate(name: "James Hahn", party: "Democratic", committeeId: "1254386", committeeName: "Hahn for Mayor 2005"),
        LAMayoralCandidate(name: "Robert Hertzberg", party: "Democratic", committeeId: "1265178", committeeName: "Bob Hertzberg for a Great L.A."),
        LAMayoralCandidate(name: "Bernard C. Parks", party: "Democratic", committeeId: "1264812", committeeName: "Bernard Parks for Mayor")
    ],

    "2001": [
        LAMayoralCandidate(name: "James Hahn", party: "Democratic", committeeId: "1234276", committeeName: "Hahn for Mayor - General"),
        LAMayoralCandidate(name: "Antonio Villaraigosa", party: "Democratic", committeeId: "991904", committeeName: "Villaraigosa for Mayor"),
        LAMayoralCandidate(name: "Steven Soboroff", party: "Republican", committeeId: "990804", committeeName: "Soboroff for Mayor"),
        LAMayoralCandidate(name: "Joel Wachs", party: "Independent", committeeId: "990836", committeeName: "Joel Wachs for Mayor"),
        LAMayoralCandidate(name: "Xavier Becerra", party: "Democratic", committeeId: "1219963", committeeName: "Becerra for Mayor")
    ]
]

// MARK: - Helper Functions

// Function to easily get candidates for a specific year
func getLAMayoralCandidates(for year: String) -> [LAMayoralCandidate] {
    return laMayoralElectionData[year] ?? []
}

// Function to get available election years (as Strings, sorted descending)
func getLAMayoralElectionYears() -> [String] {
    return laMayoralElectionData.keys.sorted(by: >)
}
