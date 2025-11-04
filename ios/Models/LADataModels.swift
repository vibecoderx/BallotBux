//
//  LADataModels.swift
//  VoteVault
//

import Foundation

// MARK: - Total Sum Models

struct LATotalContribution: Codable {
    let sum_con_amount: String?
}

struct LATotalExpenditure: Codable {
    let sum_exp_amount: String?
}

// MARK: - Transaction Row Models

struct LAContribution: Codable, Identifiable {
    
    // Use con_date and con_name to form a unique-enough ID
    var id: String { (con_date ?? "") + (con_name ?? "") + (con_amount ?? "") }
    
    let con_date: String?
    let con_name: String?
    let con_city_nm: String?
    let con_state_nm: String?
    let con_occp: String?
    let con_empr: String?
    let con_amount: String?
    
    // Computed property to safely convert amount string to Double
    var amount: Double {
        guard let amountString = con_amount else { return 0.0 }
        return Double(amountString) ?? 0.0
    }
    
    // Computed property to get location
    var location: String {
        let components = [con_city_nm?.capitalized, con_state_nm?.uppercased()].compactMap { $0 }.filter { !$0.isEmpty }
        return components.joined(separator: ", ")
    }
    
    // Computed property for employer/occupation
    var employerOccupation: String {
        let components = [con_empr, con_occp].compactMap { $0 }.filter { !$0.isEmpty }
        return components.joined(separator: " / ")
    }
}

// Model for a single Expenditure from '5mrt-4zhe'
struct LAExpenditure: Codable, Identifiable {
    
    // Use exp_date and payee_name to form a unique-enough ID
    var id: String { (exp_date ?? "") + (payee_name ?? "") + (exp_amount ?? "") }

    let exp_date: String?
    let payee_name: String?
    let payee_addr_cty: String?
    let payee_addr_st: String?
    let exp_desc: String?
    let exp_amount: String?
    
    // Computed property to safely convert amount string to Double
    var amount: Double {
        guard let amountString = exp_amount else { return 0.0 }
        return Double(amountString) ?? 0.0
    }
    
    // Computed property to get location
    var location: String {
        let components = [payee_addr_cty?.capitalized, payee_addr_st?.uppercased()].compactMap { $0 }.filter { !$0.isEmpty }
        return components.joined(separator: ", ")
    }
}

