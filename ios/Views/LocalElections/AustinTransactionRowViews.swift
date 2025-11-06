//
//  AustinContributionRowView.swift
//  VoteVault
//

import SwiftUI

// MARK: - Austin Contribution Row View

struct AustinContributionRowView: View {
    let contribution: AustinContribution

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(contribution.donor?.capitalized ?? "N/A")
                    .font(.headline)
                Spacer()
                Text(formatAmount(contribution.amount))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green) // Green for contributions
            }

            InfoRow(label: "Date", value: formattedDate(contribution.contribution_date))
            
            if let location = contribution.city_state_zip, !location.isEmpty {
                InfoRow(label: "Location", value: location)
            }
            
            let employerOcc = contribution.employerOccupation
            if !employerOcc.isEmpty {
                 InfoRow(label: "Employer/Occ", value: employerOcc)
            }
            
            if let type = contribution.donor_type, !type.isEmpty {
                 InfoRow(label: "Donor Type", value: type)
            }

            // Add the "More details" link if the URL exists
            if let urlString = contribution.view_report?.url, let url = URL(string: urlString) {
                HStack {
                    Spacer()
                    Link("More details", destination: url)
                        .font(.caption)
                        .foregroundColor(.accentColor)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Austin Expenditure Row View

struct AustinExpenditureRowView: View {
    let expenditure: AustinExpenditure

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(expenditure.payee?.capitalized ?? "N/A")
                    .font(.headline)
                Spacer()
                Text(formatAmount(expenditure.amount))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.orange) // Orange for expenditures
            }

            InfoRow(label: "Date", value: formattedDate(expenditure.payment_date))
            
            if let location = expenditure.city_state_zip, !location.isEmpty {
                InfoRow(label: "Location", value: location)
            }
            
            // Use 'expense_description' for Purpose as it's more specific
            if let purpose = expenditure.expense_description, !purpose.isEmpty {
                 InfoRow(label: "Purpose", value: purpose)
            }
            
            // Use 'exp_desc' as a fallback description
            else if let desc = expenditure.exp_desc, !desc.isEmpty {
                 InfoRow(label: "Description", value: desc)
            }
            
            if let type = expenditure.payee_type, !type.isEmpty {
                 InfoRow(label: "Payee Type", value: type)
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
