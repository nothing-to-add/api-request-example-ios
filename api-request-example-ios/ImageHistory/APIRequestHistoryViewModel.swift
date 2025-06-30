//
//  File name: APIRequestHistoryViewModel.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI
import SwiftData

@MainActor
@Observable
final class APIRequestHistoryViewModel {
    private var modelContext: ModelContext?
    private(set) var apiRequests: [ImageModel] = []
    
    init() {}
    
    func configure(with modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchAPIRequests()
    }
    
    private func fetchAPIRequests() {
        guard let modelContext = modelContext else { 
            apiRequests = []
            return 
        }
        
        let descriptor = FetchDescriptor<ImageModel>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            apiRequests = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch API request history: \(error)")
            apiRequests = []
        }
    }
    
    func clearAllRequests() {
        guard let modelContext = modelContext else { return }
        
        do {
            try modelContext.delete(model: ImageModel.self)
            try modelContext.save()
            // Refresh the data after clearing
            fetchAPIRequests()
        } catch {
            print("Failed to clear API request history: \(error)")
        }
    }
}
