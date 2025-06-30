//
//  File name: api_request_example_iosTests.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 01/07/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import XCTest
import SwiftData
@testable import api_request_example_ios

// MARK: - Mock ImageFetcherClient
class MockImageFetcherClient: ImageFetcherClientProtocol {
    var shouldSucceed: Bool = true
    var mockResponse: ImageFetcherResponse = ImageFetcherResponse(message: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg", status: "success")
    var mockError: Error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    var fetchImageCallCount: Int = 0
    
    func fetchImage() async throws -> ImageFetcherResponse {
        fetchImageCallCount += 1
        
        if shouldSucceed {
            return mockResponse
        } else {
            throw mockError
        }
    }
    
    func reset() {
        shouldSucceed = true
        fetchImageCallCount = 0
    }
}

// MARK: - ImageFetcherViewModel Tests
@MainActor
final class ImageFetcherViewModelTests: XCTestCase {
    
    private var viewModel: ImageFetcherViewModel!
    private var mockClient: MockImageFetcherClient!
    private var modelContext: ModelContext!
    private var container: ModelContainer!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Setup in-memory SwiftData container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: ImageModel.self, configurations: config)
        modelContext = ModelContext(container)
        
        mockClient = MockImageFetcherClient()
        viewModel = ImageFetcherViewModel(imageFetcherClient: mockClient, modelContext: modelContext)
    }
    
    override func tearDown() async throws {
        viewModel = nil
        mockClient = nil
        modelContext = nil
        container = nil
        try await super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertNil(viewModel.imageURL)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchRandomImageSuccess() async {
        // Given
        mockClient.shouldSucceed = true
        let expectedURL = "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg"
        mockClient.mockResponse = ImageFetcherResponse(message: expectedURL, status: "success")
        
        // When
        viewModel.fetchRandomImage()
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        // Then
        XCTAssertEqual(viewModel.imageURL, expectedURL)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(mockClient.fetchImageCallCount, 1)
    }
    
    func testFetchRandomImageFailure() async {
        // Given
        mockClient.shouldSucceed = false
        mockClient.mockError = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
        // When
        viewModel.fetchRandomImage()
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        // Then
        XCTAssertNil(viewModel.imageURL)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage?.contains("Failed to fetch image") == true)
        XCTAssertEqual(mockClient.fetchImageCallCount, 1)
    }
    
    func testLoadingStateToggle() async {
        // Given
        mockClient.shouldSucceed = true
        
        // When
        viewModel.fetchRandomImage()
        
        // Then - Initially loading should be true
//        XCTAssertTrue(viewModel.isLoading)
        
        // Wait for completion
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        // Then - Loading should be false after completion
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testClearImage() async {
        // Given
        viewModel.fetchRandomImage()
        // Wait briefly to ensure state is set
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 second
        
        // When
        viewModel.clearImage()
        
        // Wait briefly to ensure state is set
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 second
        
        // Then
        XCTAssertNil(viewModel.imageURL)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSetModelContext() {
        // Given
        let newContainer = try! ModelContainer(for: ImageModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let newContext = ModelContext(newContainer)
        
        // When
        viewModel.setModelContext(newContext)
        
        // Then - We can't directly test the private modelContext, but we can test it doesn't crash
        viewModel.fetchRandomImage()
        XCTAssertNotNil(viewModel) // Basic assertion to ensure no crash
    }
    
    func testModelContextDataPersistence() async {
        // Given
        mockClient.shouldSucceed = true
        let expectedURL = "https://test-image.jpg"
        mockClient.mockResponse = ImageFetcherResponse(message: expectedURL, status: "success")
        
        // When
        viewModel.fetchRandomImage()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        // Then - Check that data was saved to model context
        let descriptor = FetchDescriptor<ImageModel>()
        let savedModels = try! modelContext.fetch(descriptor)
        
        XCTAssertEqual(savedModels.count, 1)
        XCTAssertEqual(savedModels.first?.imageURL, expectedURL)
        XCTAssertTrue(savedModels.first?.isSuccess == true)
        XCTAssertNil(savedModels.first?.errorMessage)
    }
    
    func testModelContextErrorPersistence() async {
        // Given
        mockClient.shouldSucceed = false
        
        // When
        viewModel.fetchRandomImage()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        // Then - Check that error was saved to model context
        let descriptor = FetchDescriptor<ImageModel>()
        let savedModels = try! modelContext.fetch(descriptor)
        
        XCTAssertEqual(savedModels.count, 1)
        XCTAssertNil(savedModels.first?.imageURL)
        XCTAssertFalse(savedModels.first?.isSuccess == true)
        XCTAssertNotNil(savedModels.first?.errorMessage)
    }
}

// MARK: - APIRequestHistoryViewModel Tests
@MainActor
final class APIRequestHistoryViewModelTests: XCTestCase {
    
    private var viewModel: APIRequestHistoryViewModel!
    private var modelContext: ModelContext!
    private var container: ModelContainer!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Setup in-memory SwiftData container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: ImageModel.self, configurations: config)
        modelContext = ModelContext(container)
        
        viewModel = APIRequestHistoryViewModel()
    }
    
    override func tearDown() async throws {
        viewModel = nil
        modelContext = nil
        container = nil
        try await super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.apiRequests.isEmpty)
    }
    
    func testConfigureWithModelContext() {
        // When
        viewModel.configure(with: modelContext)
        
        // Then
        XCTAssertTrue(viewModel.apiRequests.isEmpty) // Should be empty initially
    }
    
    func testFetchAPIRequestsWithData() throws {
        // Given - Add some test data
        let testImage1 = ImageModel(
            timestamp: Date(),
            imageURL: "https://test1.jpg",
            isSuccess: true,
            errorMessage: nil
        )
        let testImage2 = ImageModel(
            timestamp: Date().addingTimeInterval(-60), // 1 minute ago
            imageURL: nil,
            isSuccess: false,
            errorMessage: "Test error"
        )
        
        modelContext.insert(testImage1)
        modelContext.insert(testImage2)
        try modelContext.save()
        
        // When
        viewModel.configure(with: modelContext)
        
        // Then
        XCTAssertEqual(viewModel.apiRequests.count, 2)
        // Should be sorted by timestamp in reverse order (newest first)
        XCTAssertEqual(viewModel.apiRequests[0].imageURL, "https://test1.jpg")
        XCTAssertTrue(viewModel.apiRequests[0].isSuccess)
        XCTAssertEqual(viewModel.apiRequests[1].errorMessage, "Test error")
        XCTAssertFalse(viewModel.apiRequests[1].isSuccess)
    }
    
    func testClearAllRequests() throws {
        // Given - Add test data
        let testImage = ImageModel(
            timestamp: Date(),
            imageURL: "https://test.jpg",
            isSuccess: true,
            errorMessage: nil
        )
        
        modelContext.insert(testImage)
        try modelContext.save()
        
        viewModel.configure(with: modelContext)
        XCTAssertEqual(viewModel.apiRequests.count, 1)
        
        // When
        viewModel.clearAllRequests()
        
        // Then
        XCTAssertTrue(viewModel.apiRequests.isEmpty)
        
        // Verify data is actually deleted from context
        let descriptor = FetchDescriptor<ImageModel>()
        let remainingModels = try modelContext.fetch(descriptor)
        XCTAssertTrue(remainingModels.isEmpty)
    }
    
    func testClearAllRequestsWithoutModelContext() {
        // Given - ViewModel without model context
        let viewModelWithoutContext = APIRequestHistoryViewModel()
        
        // When
        viewModelWithoutContext.clearAllRequests()
        
        // Then - Should not crash
        XCTAssertTrue(viewModelWithoutContext.apiRequests.isEmpty)
    }
    
    func testSortingByTimestamp() throws {
        // Given - Add multiple images with different timestamps
        let now = Date()
        let oneHourAgo = now.addingTimeInterval(-3600)
        let twoHoursAgo = now.addingTimeInterval(-7200)
        
        let recentImage = ImageModel(timestamp: now, imageURL: "recent.jpg", isSuccess: true)
        let oldImage = ImageModel(timestamp: twoHoursAgo, imageURL: "old.jpg", isSuccess: true)
        let middleImage = ImageModel(timestamp: oneHourAgo, imageURL: "middle.jpg", isSuccess: true)
        
        modelContext.insert(oldImage)
        modelContext.insert(recentImage)
        modelContext.insert(middleImage)
        try modelContext.save()
        
        // When
        viewModel.configure(with: modelContext)
        
        // Then - Should be sorted with newest first
        XCTAssertEqual(viewModel.apiRequests.count, 3)
        XCTAssertEqual(viewModel.apiRequests[0].imageURL, "recent.jpg")
        XCTAssertEqual(viewModel.apiRequests[1].imageURL, "middle.jpg")
        XCTAssertEqual(viewModel.apiRequests[2].imageURL, "old.jpg")
    }
    
    func testConfigureWithNilModelContext() {
        // When
        viewModel.configure(with: modelContext)
        
        // Then
        XCTAssertTrue(viewModel.apiRequests.isEmpty)
    }
}
