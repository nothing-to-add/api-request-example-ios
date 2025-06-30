//
//  File name: APIRequestHistoryView.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI
import SwiftData

struct APIRequestHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = APIRequestHistoryViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Explanation text about functionality
                VStack(spacing: 8) {
                    Text("This view shows the history of all API requests")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                        Text("• Tracks successful and failed requests")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("• Shows timestamps and URLs")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    
                    Text("• Persistent storage using SwiftData")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGroupedBackground))
                
                List(viewModel.apiRequests, id: \.timestamp) { request in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(request.timestamp, style: .time)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(request.isSuccess ? "Success" : "Failed")
                                .font(.caption)
                                .foregroundColor(request.isSuccess ? .green : .red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(request.isSuccess ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                )
                        }
                        
                        if let imageURL = request.imageURL {
                            Text("URL: \(imageURL)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        
                        if let errorMessage = request.errorMessage {
                            Text("Error: \(errorMessage)")
                                .font(.caption2)
                                .foregroundColor(.red)
                                .lineLimit(3)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .navigationTitle("API Request History")
                .navigationBarItems(trailing: clearAllButton)
            }
            .onAppear {
                viewModel.configure(with: modelContext)
            }
        }
    }
    
    private var clearAllButton: some View {
        Button("Clear All") {
            viewModel.clearAllRequests()
        }
        .foregroundColor(.red)
    }
}

#Preview {
    APIRequestHistoryView()
        .modelContainer(for: ImageModel.self, inMemory: true)
}
