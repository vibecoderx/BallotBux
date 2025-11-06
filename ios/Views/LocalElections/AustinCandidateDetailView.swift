//
//  AustinCandidateDetailView.swift
//  VoteVault
//

import SwiftUI

struct AustinCandidateDetailView: View {
    let candidate: AustinMayoralCandidate
    let year: String
    
    @State private var selectedTab = 0
    
    // States for Tabs
    @State private var contributions: [AustinContribution] = []
    @State private var expenditures: [AustinExpenditure] = []
    
    @State private var totalContributions: Double? = nil
    @State private var totalExpenditures: Double? = nil
    
    @State private var isLoadingContributions = false
    @State private var isLoadingExpenditures = false
    @State private var contributionError: String? = nil
    @State private var expenditureError: String? = nil
    
    @State private var hasFetchedContributions = false
    @State private var hasFetchedExpenditures = false
    
    // SF App Token (used for Austin API as well)
    @State private var appToken: String?
    
    var body: some View {
        VStack {
            Picker("Data", selection: $selectedTab) {
                Text("Contributions").tag(0)
                Text("Expenditures").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Group {
                if selectedTab == 0 {
                    contributionsView
                } else {
                    expendituresView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle(candidate.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadAppTokenAndFetch()
        }
        .onChange(of: selectedTab) {
            // Only fetch if token is loaded and data hasn't been fetched
            if appToken != nil {
                fetchDataForCurrentTab()
            }
        }
    }
    
    // MARK: - View Builders
    
    @ViewBuilder
    private var contributionsView: some View {
        if isLoadingContributions {
            ProgressView("Fetching Contributions...").padding(.top)
        } else if let error = contributionError {
            VStack {
                 Text("Error Loading Contributions")
                     .font(.headline).foregroundColor(.red)
                 Text(error).font(.callout).foregroundColor(.gray).multilineTextAlignment(.center)
             }.padding()
        } else if contributions.isEmpty && totalContributions == nil && hasFetchedContributions {
             Text("No contributions found for this candidate.").foregroundColor(.secondary).padding()
        } else {
            List {
                // Section for Total Contributions
                if let total = totalContributions {
                    Section {
                        HStack {
                            Text("Total Contributions:")
                                .font(.headline)
                            Spacer()
                            Text(formatAmount(total))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                // Section for Top 100 Contributions
                if !contributions.isEmpty {
                    Section(header: Text("Top 100 Contributions").font(.headline)) {
                        ForEach(contributions) { contribution in
                            AustinContributionRowView(contribution: contribution)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var expendituresView: some View {
        if isLoadingExpenditures {
            ProgressView("Fetching Expenditures...").padding(.top)
        } else if let error = expenditureError {
            VStack {
                 Text("Error Loading Expenditures")
                     .font(.headline).foregroundColor(.red)
                 Text(error).font(.callout).foregroundColor(.gray).multilineTextAlignment(.center)
             }.padding()
        } else if expenditures.isEmpty && totalExpenditures == nil && hasFetchedExpenditures {
            Text("No expenditures found for this candidate.").foregroundColor(.secondary).padding()
        } else {
             List {
                 // Section for Total Expenditures
                 if let total = totalExpenditures {
                     Section {
                         HStack {
                             Text("Total Expenditures:")
                                 .font(.headline)
                             Spacer()
                             Text(formatAmount(total))
                                 .font(.headline)
                                 .fontWeight(.bold)
                                 .foregroundColor(.blue)
                         }
                     }
                 }
                 
                 // Section for Top 100 Expenditures
                 if !expenditures.isEmpty {
                     Section(header: Text("Top 100 Expenditures").font(.headline)) {
                         ForEach(expenditures) { expenditure in
                             AustinExpenditureRowView(expenditure: expenditure)
                         }
                     }
                 }
             }
             .listStyle(.plain)
        }
    }
    
    // MARK: - Data Fetching
    
    private func loadAppTokenAndFetch() {
        guard let token = Secrets.get(key: "SF_APP_TOKEN") else {
            let errorMsg = "App Token (SF_APP_TOKEN) is missing. Please check Secrets.xcconfig."
            self.contributionError = errorMsg
            self.expenditureError = errorMsg
            return
        }
        self.appToken = token
        
        // Fetch data for the currently selected tab
        fetchDataForCurrentTab()
    }
    
    private func fetchDataForCurrentTab() {
        let group = DispatchGroup()
        
        if selectedTab == 0 && !hasFetchedContributions {
            isLoadingContributions = true
            contributionError = nil
            hasFetchedContributions = true
            
            fetchTotal(isContribution: true, group: group)
            fetchTransactions(isContribution: true, group: group)
            
            group.notify(queue: .main) {
                isLoadingContributions = false
            }
            
        } else if selectedTab == 1 && !hasFetchedExpenditures {
            isLoadingExpenditures = true
            expenditureError = nil
            hasFetchedExpenditures = true
            
            fetchTotal(isContribution: false, group: group)
            fetchTransactions(isContribution: false, group: group)
            
            group.notify(queue: .main) {
                isLoadingExpenditures = false
            }
        }
    }
    
    private func fetchTotal(isContribution: Bool, group: DispatchGroup) {
        guard let appToken = appToken else { return }
        group.enter()

        let endpoint = isContribution ? "3kfv-biw6" : "gd3e-xut2"
        let query: String
        
        if isContribution {
            query = "SELECT sum(contribution_amount) WHERE recipient = '\(candidate.query_name)' AND contribution_year = '\(year)'"
        } else {
            query = "SELECT sum(payment_amount) WHERE paid_by = '\(candidate.query_name)' AND payment_year = '\(year)'"
        }
        
        guard let url = buildQueryURL(endpoint: endpoint, query: query, appToken: appToken) else {
            let errorMsg = "Internal error: Could not create total API URL."
            if isContribution { self.contributionError = errorMsg }
            else { self.expenditureError = errorMsg }
            group.leave()
            return
        }
        
        print("DEBUG: url: \(url.absoluteString)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { group.leave() }
            DispatchQueue.main.async {
                let errorState = isContribution ? $contributionError : $expenditureError
                
                if let error = error {
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nNetwork error (total): \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nNo data received (total)."
                    return
                }

                do {
                    if isContribution {
                        let totalResponse = try JSONDecoder().decode([AustinTotalContribution].self, from: data)
                        if let totalString = totalResponse.first?.sum_contribution_amount, let totalValue = Double(totalString) {
                            self.totalContributions = totalValue
                        } else {
                            self.totalContributions = 0.0
                        }
                    } else {
                        let totalResponse = try JSONDecoder().decode([AustinTotalExpenditure].self, from: data)
                        if let totalString = totalResponse.first?.sum_payment_amount, let totalValue = Double(totalString) {
                            self.totalExpenditures = totalValue
                        } else {
                            self.totalExpenditures = 0.0
                        }
                    }
                } catch {
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nFailed to parse total: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func fetchTransactions(isContribution: Bool, group: DispatchGroup) {
        guard let appToken = appToken else { return }
        group.enter()

        let endpoint = isContribution ? "3kfv-biw6" : "gd3e-xut2"
        let query: String
        
        if isContribution {
            query = "SELECT * WHERE recipient = '\(candidate.query_name)' AND contribution_year = '\(year)' ORDER BY contribution_amount DESC LIMIT 100"
        } else {
            query = "SELECT * WHERE paid_by = '\(candidate.query_name)' AND payment_year = '\(year)' ORDER BY payment_amount DESC LIMIT 100"
        }
        
        guard let url = buildQueryURL(endpoint: endpoint, query: query, appToken: appToken) else {
            let errorMsg = "Internal error: Could not create transaction API URL."
            if isContribution { self.contributionError = errorMsg }
            else { self.expenditureError = errorMsg }
            group.leave()
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { group.leave() }
            DispatchQueue.main.async {
                let errorState = isContribution ? $contributionError : $expenditureError
                
                if let error = error {
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nNetwork error (list): \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nNo data received (list)."
                    return
                }
                
                do {
                    if isContribution {
                        self.contributions = try JSONDecoder().decode([AustinContribution].self, from: data)
                    } else {
                        self.expenditures = try JSONDecoder().decode([AustinExpenditure].self, from: data)
                    }
                } catch {
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nFailed to parse list: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    // MARK: - Helpers

    private func buildQueryURL(endpoint: String, query: String, appToken: String) -> URL? {
        var urlComponents = URLComponents(string: "https://data.austintexas.gov/api/v3/views/\(endpoint)/query.json")
        urlComponents?.queryItems = [
            URLQueryItem(name: "$$app_token", value: appToken),
            URLQueryItem(name: "query", value: query)
        ]
        return urlComponents?.url
    }
    
    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

// MARK: - Preview

struct AustinCandidateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCandidate = AustinMayoralCandidate(
            name: "Kirk Watson",
            query_name: "Watson, Kirk P."
        )
        NavigationView {
            AustinCandidateDetailView(candidate: sampleCandidate, year: "2024")
        }
    }
}

