//
//  AustinDataModels.swift
//  VoteVault
//

import Foundation

// MARK: - Total Sum Models
struct AustinTotalContribution: Codable {
    let sum_contribution_amount: String?
}

struct AustinTotalExpenditure: Codable {
    let sum_payment_amount: String?
}

// MARK: - Link Model
struct ReportLink: Codable {
    let url: String?
    let description: String?
}


// MARK: - Transaction Row Models

// Model for a single Contribution from '3kfv-biw6'
struct AustinContribution: Codable, Identifiable {
    // Use date, name, and amount for a reasonable ID
    var id: String { (contribution_date ?? "") + (donor ?? "") + (contribution_amount ?? "") }
    
    let donor: String?
    let contribution_amount: String?
    let contribution_date: String?
    let donor_type: String?
    let city_state_zip: String?
    let donor_reported_occupation: String?
    let donor_reported_employer: String?
    let view_report: ReportLink?
    
    // Computed property to safely convert amount string to Double
    var amount: Double {
        guard let amountString = contribution_amount else { return 0.0 }
        return Double(amountString) ?? 0.0
    }
    
    // Computed property for employer/occupation
    var employerOccupation: String {
        let components = [donor_reported_employer, donor_reported_occupation].compactMap { $0 }.filter { !$0.isEmpty }
        return components.joined(separator: " / ")
    }
}

// Model for a single Expenditure from 'gd3e-xut2'
struct AustinExpenditure: Codable, Identifiable {
    // Use date, payee, and amount for a reasonable ID
    var id: String { (payment_date ?? "") + (payee ?? "") + (payment_amount ?? "") }

    let payee: String?
    let city_state_zip: String?
    let exp_desc: String? // Description
    let payment_date: String?
    let payee_type: String?
    let payment_amount: String?
    let expense_description: String? // Purpose
    
    // Computed property to safely convert amount string to Double
    var amount: Double {
        guard let amountString = payment_amount else { return 0.0 }
        return Double(amountString) ?? 0.0
    }
}

