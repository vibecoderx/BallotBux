//
//  IACandidateDetailView.swift
//  VoteVault

import SwiftUI

// Struct to model Iowa Contribution from Socrata
struct IowaContribution: Codable, Identifiable {
    var id = UUID() // Socrata rows might not have unique IDs exposed easily, using UUID
    let date: String?
    let contribution_amount: String?
    let contributor_name: String?
    let contributor_city: String?
    let contributor_state: String?
    
    var amount: Double {
        return Double(contribution_amount ?? "0") ?? 0.0
    }
}

struct IACandidateDetailView: View {
    let candidate: IACandidateInfo
    
    @State private var contributions: [IowaContribution] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Iowa Data...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            } else if contributions.isEmpty {
                Text("No contributions found for this committee.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(contributions) { item in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(item.contributor_name?.capitalized ?? "Unknown Donor")
                                .font(.headline)
                            Spacer()
                            Text(formatCurrency(item.amount))
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                        HStack {
                            Text("Date: \(formatDate(item.date))")
                            Spacer()
                            if let city = item.contributor_city, let state = item.contributor_state {
                                Text("\(city.capitalized), \(state)")
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(candidate.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchContributions()
        }
    }
    
    private func fetchContributions() {
        isLoading = true
        
        // Iowa Socrata Endpoint: https://data.iowa.gov/resource/smfg-ds7h.json
        // We filter by 'receiving_committee_code' which matches our local 'committee_id'
        
        let baseURL = "https://data.iowa.gov/resource/smfg-ds7h.json"
        let query = "?receiving_committee_code=\(candidate.committee_id)&$order=contribution_amount DESC&$limit=100"
        
        guard let url = URL(string: baseURL + query) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received."
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode([IowaContribution].self, from: data)
                    self.contributions = decodedData
                } catch {
                    self.errorMessage = "Failed to parse data. The committee ID might be incorrect or no data exists for this period."
                    // print("DEBUG Parsing Error: \(error)")
                }
            }
        }.resume()
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "N/A" }
        // Handle ISO8601 or similar formats if needed. 
        // Socrata dates are often ISO8601.
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        // Fallback: simple split if T exists (e.g. 2022-01-01T00:00:00)
        return dateString.components(separatedBy: "T").first ?? dateString
    }
}
