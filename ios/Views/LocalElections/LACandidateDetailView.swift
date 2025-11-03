//
//  LACandidateDetailView.swift
//  VoteVault
//
//  This view shows contributions and expenditures for an LA mayoral candidate.
//

import SwiftUI

struct LACandidateDetailView: View {
    let candidate: LAMayoralCandidate
    let year: String
    
    @State private var selectedTab = 0
    
    // States for Tabs
    @State private var contributions: [LATransaction] = []
    @State private var expenditures: [LAExpenditure] = []
    
    // Initialize totals to 0.0 to display the "Total" sections as requested
    @State private var totalContributions: Double? = 0.0
    @State private var totalExpenditures: Double? = 0.0
    
    // Loading/Error states (set to false/true since we aren't fetching)
    @State private var isLoadingContributions = false
    @State private var isLoadingExpenditures = false
    @State private var contributionError: String? = nil
    @State private var expenditureError: String? = nil
    
    // Set to true to show the "No contributions" message
    @State private var hasFetchedContributions = true
    @State private var hasFetchedExpenditures = true
    
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
            // We will fetch data here in the next step
            // For now, we just ensure the view shows the empty state
            if !hasFetchedContributions {
                 // fetchContributions()
                 hasFetchedContributions = true
                 isLoadingContributions = false
            }
        }
        .onChange(of: selectedTab) {
            // We will fetch data here in the next step
            if selectedTab == 1 && !hasFetchedExpenditures {
                // fetchExpenditures()
                hasFetchedExpenditures = true
                isLoadingExpenditures = false
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
        // Show empty message if list is empty AND we have "fetched"
        } else if contributions.isEmpty && hasFetchedContributions {
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
                 // Section for the empty message
                 Section {
                     Text("No contributions found for this candidate.").foregroundColor(.secondary)
                 }
             }
        } else {
            // This is the state where we have contributions
            List {
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
                
                Section(header: Text("Top Contributions").font(.headline)) {
                    // This will be populated by the API call
                    ForEach(contributions) { transaction in
                        // We'll need a LATransactionRowView, but for now:
                        Text(transaction.name)
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
        // Show empty message if list is empty AND we have "fetched"
        } else if expenditures.isEmpty && hasFetchedExpenditures {
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
                 // Section for the empty message
                 Section {
                     Text("No expenditures found for this candidate.").foregroundColor(.secondary)
                 }
             }
        } else {
             // This is the state where we have expenditures
             List {
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
                 
                 Section(header: Text("Top Expenditures").font(.headline)) {
                     // This will be populated by the API call
                     ForEach(expenditures) { expenditure in
                         // We'll need a row view, but for now:
                         Text(expenditure.name)
                     }
                 }
             }
             .listStyle(.plain)
        }
    }
    
    // Helper function to format currency
    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct LACandidateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCandidate = LAMayoralCandidate(
            name: "Karen Bass",
            party: "Democratic",
            committeeId: "1441328",
            committeeName: "Karen Bass for Mayor 2022"
        )
        NavigationView {
            LACandidateDetailView(candidate: sampleCandidate, year: "2022")
        }
    }
}
