//
//  LADataModels.swift
//  VoteVault
//

import Foundation

// MARK: - Model for SUM Query
// Socrata returns an array: [ { "sum_con_amount": "12345.67" } ]
struct LATotalContribution: Codable {
    let sum_con_amount: String?
}

// Socrata returns an array: [ { "sum_exp_amount": "12345.67" } ]
struct LATotalExpenditure: Codable {
    let sum_exp_amount: String?
}

// MARK: - Model for Transaction Row
// This is a placeholder for now. We will populate this in the next step.
// For now, it provides a type for the empty arrays in LACandidateDetailView.
struct LATransaction: Codable, Identifiable {
    var id = UUID()
    let name: String
    let location: String
    let date: String
    let amount: Double
    let purpose: String?
}

// MARK: - Model for Transaction Row (Expenditure)
// We may use a separate struct if expenditures are very different
struct LAExpenditure: Codable, Identifiable {
    var id = UUID()
    let name: String
    let location: String
    let date: String
    let amount: Double
    let purpose: String?
}


