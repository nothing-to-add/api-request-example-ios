//
//  File name: ImageFetcherViewModel.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation
import SwiftUI
import Combine
import SwiftData

@MainActor
class ImageFetcherViewModel: ObservableObject {
    @Published var imageURL: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let imageFetcherClient: ImageFetcherClientProtocol
    private var modelContext: ModelContext?
    
    private var errorMessageSubject = CurrentValueSubject<String?, Never>(nil)
    private var isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private var imageURLSubject = CurrentValueSubject<String?, Never>(nil)
    private var cancellables: Set<AnyCancellable> = []
    
    init(imageFetcherClient: ImageFetcherClientProtocol = ImageFetcherClient(), modelContext: ModelContext? = nil) {
        self.imageFetcherClient = imageFetcherClient
        self.modelContext = modelContext
        initCombine()
    }
    
    private func initCombine() {
        errorMessageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.errorMessage = errorMessage
            }
            .store(in: &cancellables)
        
        isLoadingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
            }
            .store(in: &cancellables)
        
        imageURLSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageURL in
                self?.imageURL = imageURL
            }
            .store(in: &cancellables)
    }
    
    func fetchRandomImage() {
        isLoadingSubject.send(true)
        errorMessageSubject.send(nil)
        imageURLSubject.send(nil)
        
        let requestTimestamp = Date()
        
        Task {
            do {
                let response = try await imageFetcherClient.fetchImage()
                imageURLSubject.send(response.message)
                self.isLoadingSubject.send(false)
                
                // Save successful request to SwiftData
                saveAPIRequest(timestamp: requestTimestamp, imageURL: response.message, isSuccess: true, errorMessage: nil)
            } catch {
                let errorMessage = "Failed to fetch image: \(error.localizedDescription)"
                self.errorMessageSubject.send(errorMessage)
                self.isLoadingSubject.send(false)
                
                // Save failed request to SwiftData
                saveAPIRequest(timestamp: requestTimestamp, imageURL: nil, isSuccess: false, errorMessage: errorMessage)
            }
        }
    }
    
    private func saveAPIRequest(timestamp: Date, imageURL: String?, isSuccess: Bool, errorMessage: String?) {
        guard let modelContext = modelContext else { return }
        
        let imageModel = ImageModel(
            timestamp: timestamp,
            imageURL: imageURL,
            isSuccess: isSuccess,
            errorMessage: errorMessage
        )
        
        modelContext.insert(imageModel)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save API request to SwiftData: \(error)")
        }
    }
    
    func clearImage() {
        imageURLSubject.send(nil)
        errorMessageSubject.send(nil)
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
}
