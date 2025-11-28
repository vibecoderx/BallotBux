//
//  IADataStore.swift
//  VoteVault
//

import Foundation

// MARK: - Iowa Candidate Data Model

struct IACandidateInfo: Identifiable {
    var id: String { committee_id }
    let name: String
    let party: String
    let committee_id: String
}

// MARK: - Iowa Election Data Store

// Maps Election Office -> Year -> List of Candidates
let iowaElectionData: [String: [Int: [IACandidateInfo]]] = [
    "Governor": [
        2022: [
            IACandidateInfo(name: "Kim Reynolds", party: "Republican", committee_id: "5173"),
            IACandidateInfo(name: "Deidre DeJear", party: "Democratic", committee_id: "6328"),
            IACandidateInfo(name: "Rick Stewart", party: "Libertarian", committee_id: "2077")
        ],
        2018: [
            IACandidateInfo(name: "Kim Reynolds", party: "Republican", committee_id: "5173"),
            IACandidateInfo(name: "Fred Hubbell", party: "Democratic", committee_id: "5157")
        ]
    ],
    "Lt Governor": [
        2022: [
            IACandidateInfo(name: "Adam Gregg", party: "Republican", committee_id: "5200"), // Often runs on ticket, committee might be shared or separate
            IACandidateInfo(name: "Eric Van Lancker", party: "Democratic", committee_id: "5201")
        ]
    ],
    "Attorney General": [
        2022: [
            IACandidateInfo(name: "Brenna Bird", party: "Republican", committee_id: "6335"),
            IACandidateInfo(name: "Tom Miller", party: "Democratic", committee_id: "1071")
        ]
    ],
    "Secretary of State": [
        2022: [
            IACandidateInfo(name: "Paul Pate", party: "Republican", committee_id: "5032"),
            IACandidateInfo(name: "Joel Miller", party: "Democratic", committee_id: "6340")
        ]
    ],
    "State Senate": [
        2022: [
            // Placeholder examples
            IACandidateInfo(name: "Sample Senator A", party: "Republican", committee_id: "0001"),
            IACandidateInfo(name: "Sample Senator B", party: "Democratic", committee_id: "0002")
        ]
    ],
    "State House": [
        2022: [
            // Placeholder examples
            IACandidateInfo(name: "Sample Rep A", party: "Republican", committee_id: "0003"),
            IACandidateInfo(name: "Sample Rep B", party: "Democratic", committee_id: "0004")
        ]
    ]
]

// MARK: - Helper Functions

func getIAElectionYears(for office: String) -> [Int] {
    guard let yearsData = iowaElectionData[office] else { return [] }
    return yearsData.keys.sorted(by: >)
}

func getIACandidates(office: String, year: Int) -> [IACandidateInfo] {
    return iowaElectionData[office]?[year] ?? []
}
