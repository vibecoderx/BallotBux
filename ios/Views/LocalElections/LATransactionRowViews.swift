//
//  LATransactionRowViews.swift
//  VoteVault
//

import SwiftUI

// MARK: - LA Contribution Row View

struct LAContributionRowView: View {
    let contribution: LAContribution

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(contribution.con_name?.capitalized ?? "N/A")
                    .font(.headline)
                Spacer()
                Text(formatAmount(contribution.amount))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green) // Green for contributions
            }

            InfoRow(label: "Date", value: formattedDate(contribution.con_date))
            
            let location = contribution.location
            if !location.isEmpty {
                InfoRow(label: "Location", value: location)
            }
            
            let employerOcc = contribution.employerOccupation
            if !employerOcc.isEmpty {
                 InfoRow(label: "Employer/Occ", value: employerOcc)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - LA Expenditure Row View

struct LAExpenditureRowView: View {
    let expenditure: LAExpenditure

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(expenditure.payee_name?.capitalized ?? "N/A")
                    .font(.headline)
                Spacer()
                Text(formatAmount(expenditure.amount))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.orange) // Orange for expenditures
            }

            InfoRow(label: "Date", value: formattedDate(expenditure.exp_date))
            
            let location = expenditure.location
            if !location.isEmpty {
                InfoRow(label: "Location", value: location)
            }
            
            if let purpose = expenditure.exp_desc, !purpose.isEmpty {
                 InfoRow(label: "Purpose", value: purpose)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Helper Functions (shared)

private func formatAmount(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
}

// Handle ISO 8601 date strings (e.g., "2023-10-27T00:00:00.000")
private func formattedDate(_ dateString: String?) -> String {
    guard let dateString = dateString else { return "N/A" }
    
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    if let date = formatter.date(from: dateString) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        return displayFormatter.string(from: date)
    }
    
    // Fallback for just date part if time parsing fails
    formatter.formatOptions = [.withFullDate]
    if let date = formatter.date(from: String(dateString.prefix(10))) {
         let displayFormatter = DateFormatter()
         displayFormatter.dateStyle = .medium
         return displayFormatter.string(from: date)
    }
    
    return dateString // Return original if all parsing fails
}
